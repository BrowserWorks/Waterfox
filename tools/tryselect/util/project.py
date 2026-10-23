# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

"""Determine which project's checkout a `mach try` operation targets."""

import os


def get_project_topsrcdir(build):
    """
    Return the current project source directory for try pushes.

    The project comes from the build config (--enable-project), so this works
    before a build. A project is only treated as a separate try target when it
    has its own taskgraph config (e.g. comm/taskcluster/config.yml).
    """
    project_path = build.base_mozconfig_info["project"][0]
    project_topsrcdir = os.path.join(build.topsrcdir, project_path.split(os.sep)[0])

    if not os.path.exists(os.path.join(project_topsrcdir, "taskcluster", "config.yml")):
        return build.topsrcdir

    if os.getcwd().startswith(project_topsrcdir):
        return project_topsrcdir

    return build.topsrcdir


def is_thunderbird_try(build):
    """
    Return True if this is a Thunderbird try.
    """
    return build.topsrcdir != get_project_topsrcdir(build)
