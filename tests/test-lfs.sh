#!/bin/bash

set -e

#export GIT_TRACE=1

print_error() {
  >&2 echo -e "$@"
}

fail() {
  local code=${2:-1}
  [[ -n $1 ]] && print_error "$1"
  # shellcheck disable=SC2086
  exit $code
}

# check that all required env vars are set
check_vars() {
  local req_vars=(
    GITHUB_USER
    GITHUB_PASS
    LFS_SERVER
  )

  local err
  for v in ${req_vars[*]}; do
    eval "[[ -z \"\$$v\" ]]" && err="${err}Missing required env var: ${v}\n"
  done

  [[ -n $err ]] && fail "$err"

  # need explicit return status incase the last -z check returns 1
  return 0
}

# check that all required cli programs are present
check_cmds() {
  local cmds=(
    dd
    jq
    git
  )

  local err
  for c in ${cmds[*]}; do
    if ! hash "$c" 2>/dev/null; then
      err="${err}prog: ${c} is required\n"
    fi
  done

  [[ -n $err ]] && fail "$err"

  # need explicit return status incase the last -z check returns 1
  return 0
}

TEST_FILES=()

lfsfile() {
  local filename=$1
  local mb=$2

  dd if=/dev/zero of="$filename" bs=1M count="$mb"
  # append a random string value to= ensure there is not an existing lfs
  # object that will be 'skipped' instead of pushed to the lfs store
  # based on https://gist.github.com/earthgecko/3089509
  tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 8 | head -n 1 >> "$filename"
  git add "$filename"
  git commit -m'add lfs test file'

  TEST_FILES+=( "$filename" )
}

gitlfs_fqdn() {
  local script_path
  script_path="$( cd "$(dirname "$0")" ; pwd -P )"
  local root_path="${script_path}/.."

  local fqdn
  fqdn=$( set -e
    cd "${root_path}/tf"
    ./bin/terraform output --json | jq -r '.GITLFS_FQDN.value'
  )
  echo "$fqdn"
}

check_cmds

# set LFS_SERVER from terraform metadata, if not already set
export LFS_SERVER=${LFS_SERVER:-https://$(gitlfs_fqdn)}

check_vars

T_DIR="tmp"
PUSH_DIR="${T_DIR}/test-push"
PULL_DIR="${T_DIR}/test-pull"
rm -rf "$T_DIR"

mkdir -p "$PUSH_DIR"
( set -e
  cd "$PUSH_DIR"
  git init
  cat >.lfsconfig<<-END
	[lfs]
		url = ${LFS_SERVER}
	END
  git lfs track "*.lfstest"
  git add .lfsconfig .gitattributes
  git commit -m'lfs config'

  lfsfile test-1.lfstest 1
  lfsfile test-2.lfstest 1
  lfsfile test-3.lfstest 1
  lfsfile test-4.lfstest 1
  lfsfile test-5.lfstest 1

  # don't expand ! in string
  set +o histexpand
  git config --local credential.helper "!f() { cat > /dev/null; echo username=${GITHUB_USER}; echo password=${GITHUB_PASS}; }; f"
  # bogus remote; required to push lfs objects
  git remote add origin https://example.org
  git lfs push origin master
)

( set -e
  cd "$T_DIR"
  git clone ./test-push test-pull

  for f in "${TEST_FILES[@]}"; do
      diff -u "${PUSH_DIR}/${f}" "${PULL_DIR}/${f}"
  done
)

# vim: tabstop=2 shiftwidth=2 expandtab
