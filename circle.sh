#!/bin/bash
set -ex
set -o pipefail

CIRCLEUTIL_TAG="v1.37"

export CIRCLE_ARTIFACTS="${CIRCLE_ARTIFACTS-/tmp}"
export BASE_DIR="$HOME"

# Cache phase of circleci
function do_cache() {
  echo "BASE_DIR IS $BASE_DIR"

  [ ! -d "$HOME/circleutil" ] && git clone https://github.com/signalfx/circleutil.git "$HOME/circleutil"
  (
    cd "$HOME/circleutil"
    git fetch -a -v
    git fetch --tags
    git reset --hard $CIRCLEUTIL_TAG
  )
  . "$HOME/circleutil/scripts/common.sh"

  clone_repo git@github.com:signalfx/collectd-build-ubuntu.git "$BASE_DIR"/collectd-build-ubuntu origin/testci
  clone_repo git@github.com:signalfx/collectd-build-rpm.git "$BASE_DIR"/collectd-build-rpm origin/testci
}

# Test phase of circleci
function do_test() {

  . "$HOME/circleutil/scripts/common.sh"

  export SFX_BUILD_PLATFORM="$1"
  export DISTRIBUTION="$2"
  export SFX_BUILD_DOCKER="$3"
  if [ "$SFX_BUILD_DOCKER" == "none" ]; then
    export JOB_NAME=cr_"$CIRCLE_PROJECT_REPONAME"_build_"$SFX_BUILD_PLATFORM"
    "$BASE_DIR"/collectd-build-ubuntu/build-collectd/sfx_scripts/jenkins-build
  else
    export JOB_NAME=cr-"$CIRCLE_PROJECT_REPONAME"-rpm-"$DISTRIBUTION"
    "$BASE_DIR"/collectd-build-rpm/build-collectd/build/jenkins-build  
  fi
}

# Deploy phase of circleci
function do_deploy() {

  . "$HOME/circleutil/scripts/common.sh"
  echo "no deploy for now!!!"
}

function do_all() {
  do_cache
  do_test "$2" "$3" "$4"
  do_deploy
}

case "$1" in
  cache)
    do_cache 
    ;;
  test)
    do_test "$2" "$3" "$4"
    ;;
  deploy)
    do_deploy
    ;;
  all)
    do_all "$2" "$3" "$4"
    ;;
  *)
  echo "Usage: $0 {cache|test|deploy|all}"
    exit 1
    ;;
esac
