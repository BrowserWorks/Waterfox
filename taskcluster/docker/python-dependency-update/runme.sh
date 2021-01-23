#!/bin/bash

set -xe

# Things to be set by task definition.
# -b branch
# -f requirements_file
# -3 use python3


test "${BRANCH}"
test "${REQUIREMENTS_FILE}"

PIP_ARG="-2"
if [ -n "${PYTHON3}" ]; then
  PIP_ARG="-3"
fi

export ARTIFACTS_DIR="/home/worker/artifacts"
mkdir -p "$ARTIFACTS_DIR"

# duplicate the functionality of taskcluster-lib-urls, but in bash..
queue_base="$TASKCLUSTER_ROOT_URL/api/queue/v1"

# Get Arcanist API token

if [ -n "${TASK_ID}" ]
then
  curl --location --retry 10 --retry-delay 10 -o /home/worker/task.json "$queue_base/task/$TASK_ID"
  ARC_SECRET=$(jq -r '.scopes[] | select(contains ("arc-phabricator-token"))' /home/worker/task.json | awk -F: '{print $3}')
fi
if [ -n "${ARC_SECRET}" ] && getent hosts taskcluster
then
  set +x # Don't echo these
  secrets_url="${TASKCLUSTER_PROXY_URL}/api/secrets/v1/secret/${ARC_SECRET}"
  SECRET=$(curl "${secrets_url}")
  TOKEN=$(echo "${SECRET}" | jq -r '.secret.token')
elif [ -n "${ARC_TOKEN}" ] # Allow for local testing.
then
  TOKEN="${ARC_TOKEN}"
fi

if [ -n "${TOKEN}" ]
then
  cat >"${HOME}/.arcrc" <<END
{
  "hosts": {
    "https://phabricator.services.mozilla.com/api/": {
      "token": "${TOKEN}"
    }
  }
}
END
  set -x
  chmod 600 "${HOME}/.arcrc"
fi

export HGPLAIN=1

# shellcheck disable=SC2086
/home/worker/scripts/update_pipfiles.sh -b "${BRANCH}" -f "${REQUIREMENTS_FILE}" ${PIP_ARG}
