# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
"""
Transform the repo-update task into an actual task description.
"""

from taskgraph.transforms.base import TransformSequence
from taskgraph.util.schema import resolve_keyed_by

transforms = TransformSequence()


@transforms.add
def resolve_keys(config, tasks):
    for task in tasks:
        resolve_keyed_by(
            task,
            "description",
            item_name=task["name"],
            project=config.params["project"],
        )
        env = task["worker"].setdefault("env", {})
        env["BRANCH"] = config.params["project"]

        for envvar in list(env.keys()):
            if not env.get(envvar):
                del env[envvar]
        yield task
