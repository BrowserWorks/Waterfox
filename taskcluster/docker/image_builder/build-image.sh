#!/bin/bash -vex

# Set bash options to exit immediately if a pipeline exists non-zero, expand
# print a trace of commands, and make output verbose (print shell input as it's
# read)
# See https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -x -e -v -o pipefail

# Prefix errors with taskcluster error prefix so that they are parsed by Treeherder
raise_error() {
  echo
  echo "[taskcluster-image-build:error] $1"
  exit 1
}

# Ensure that the PROJECT is specified so the image can be indexed
test -n "$PROJECT"    || raise_error "PROJECT must be provided."
test -n "$HASH"       || raise_error "Context HASH must be provided."
test -n "$IMAGE_NAME" || raise_error "IMAGE_NAME must be provided."

# Create artifact folder
mkdir -p /home/worker/workspace/artifacts

# Construct a CONTEXT_FILE
CONTEXT_FILE=/home/worker/workspace/context.tar

# Run ./mach taskcluster-build-image with --context-only to build context
run-task \
  --chown-recursive "/home/worker/workspace" \
  --vcs-checkout "/home/worker/checkouts/gecko" \
  -- \
  /home/worker/checkouts/gecko/mach taskcluster-build-image \
  --context-only "$CONTEXT_FILE" \
  "$IMAGE_NAME"
test -f "$CONTEXT_FILE" || raise_error "Context file wasn't created"

# Post context tar-ball to docker daemon
# This interacts directly with the docker remote API, see:
# https://docs.docker.com/engine/reference/api/docker_remote_api_v1.18/
curl -s --fail \
  -X POST \
  --header 'Content-Type: application/tar' \
  --data-binary "@$CONTEXT_FILE" \
  --unix-socket /var/run/docker.sock "http:/build?t=$IMAGE_NAME:$HASH" \
  | tee /tmp/docker-build.log \
  | jq -jr '(.status + .progress, .error | select(. != null) + "\n"), .stream | select(. != null)'

# Exit non-zero if there is error entries in the log
if cat /tmp/docker-build.log | jq -se 'add | .error' > /dev/null; then
  raise_error "Image build failed: `cat /tmp/docker-build.log | jq -rse 'add | .error'`";
fi

# Sanity check that image was built successfully
if ! cat /tmp/docker-build.log | tail -n 1 | jq -r '.stream' | grep '^Successfully built' > /dev/null; then
  echo 'docker-build.log for debugging:';
  cat /tmp/docker-build.log | tail -n 50;
  raise_error "Image build log didn't with 'Successfully built'";
fi

# Get image from docker daemon (try up to 10 times)
# This interacts directly with the docker remote API, see:
# https://docs.docker.com/engine/reference/api/docker_remote_api_v1.18/
#
# The script will retry up to 10 times.
/usr/local/bin/download-and-compress \
    http+unix://%2Fvar%2Frun%2Fdocker.sock/images/${IMAGE_NAME}:${HASH}/get \
    /home/worker/workspace/image.tar.zst.tmp \
    /home/worker/workspace/artifacts/image.tar.zst
