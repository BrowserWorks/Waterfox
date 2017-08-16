# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
"""
Transform the signing task into an actual task description.
"""

from __future__ import absolute_import, print_function, unicode_literals

from taskgraph.transforms.base import TransformSequence
from taskgraph.util.schema import validate_schema, Schema
from taskgraph.util.scriptworker import get_signing_cert_scope, get_devedition_signing_cert_scope
from taskgraph.transforms.task import task_description_schema
from voluptuous import Any, Required, Optional


# Voluptuous uses marker objects as dictionary *keys*, but they are not
# comparable, so we cast all of the keys back to regular strings
task_description_schema = {str(k): v for k, v in task_description_schema.schema.iteritems()}

transforms = TransformSequence()

# shortcut for a string where task references are allowed
taskref_or_string = Any(
    basestring,
    {Required('task-reference'): basestring})

signing_description_schema = Schema({
    # the dependant task (object) for this signing job, used to inform signing.
    Required('dependent-task'): object,

    # Artifacts from dep task to sign - Sync with taskgraph/transforms/task.py
    # because this is passed directly into the signingscript worker
    Required('upstream-artifacts'): [{
        # taskId of the task with the artifact
        Required('taskId'): taskref_or_string,

        # type of signing task (for CoT)
        Required('taskType'): basestring,

        # Paths to the artifacts to sign
        Required('paths'): [basestring],

        # Signing formats to use on each of the paths
        Required('formats'): [basestring],
    }],

    # depname is used in taskref's to identify the taskID of the unsigned things
    Required('depname', default='build'): basestring,

    # unique label to describe this signing task, defaults to {dep.label}-signing
    Optional('label'): basestring,

    # treeherder is allowed here to override any defaults we use for signing.  See
    # taskcluster/taskgraph/transforms/task.py for the schema details, and the
    # below transforms for defaults of various values.
    Optional('treeherder'): task_description_schema['treeherder'],

    # Routes specific to this task, if defined
    Optional('routes'): [basestring],

    # If True, adds a route which funsize uses to schedule generation of partial mar
    # files for updates. Expected to be added on nightly builds only.
    Optional('use-funsize-route'): bool,
})


@transforms.add
def validate(config, jobs):
    for job in jobs:
        label = job.get('dependent-task', object).__dict__.get('label', '?no-label?')
        yield validate_schema(
            signing_description_schema, job,
            "In signing ({!r} kind) task for {!r}:".format(config.kind, label))


@transforms.add
def make_task_description(config, jobs):
    for job in jobs:
        dep_job = job['dependent-task']

        signing_format_scopes = []
        formats = set([])
        for artifacts in job['upstream-artifacts']:
            for f in artifacts['formats']:
                formats.add(f)  # Add each format only once
        for format in formats:
            signing_format_scopes.append("project:releng:signing:format:{}".format(format))

        treeherder = job.get('treeherder', {})
        treeherder.setdefault('symbol', 'tc(Ns)')
        dep_th_platform = dep_job.task.get('extra', {}).get(
            'treeherder', {}).get('machine', {}).get('platform', '')
        treeherder.setdefault('platform', "{}/opt".format(dep_th_platform))
        treeherder.setdefault('tier', 1)
        treeherder.setdefault('kind', 'build')

        label = job.get('label', "{}-signing".format(dep_job.label))

        attributes = {
            'nightly': dep_job.attributes.get('nightly', False),
            'build_platform': dep_job.attributes.get('build_platform'),
            'build_type': dep_job.attributes.get('build_type'),
            'signed': True,
        }
        if dep_job.attributes.get('chunk_locales'):
            # Used for l10n attribute passthrough
            attributes['chunk_locales'] = dep_job.attributes.get('chunk_locales')

        # This code wasn't originally written with the possibility of using different
        # signing cert scopes for different platforms on the same branch. This isn't
        # ideal, but it's what we currently have to make this possible.
        if dep_job.attributes.get('build_platform') in set(
          ['linux64-devedition-nightly', 'linux-devedition-nightly']):
            signing_cert_scope = get_devedition_signing_cert_scope(config)
        else:
            signing_cert_scope = get_signing_cert_scope(config)

        task = {
            'label': label,
            'description': "{} Signing".format(
                dep_job.task["metadata"]["description"]),
            'worker-type': "scriptworker-prov-v1/signing-linux-v1",
            'worker': {'implementation': 'scriptworker-signing',
                       'upstream-artifacts': job['upstream-artifacts'],
                       'max-run-time': 3600},
            'scopes': [signing_cert_scope] + signing_format_scopes,
            'dependencies': {job['depname']: dep_job.label},
            'attributes': attributes,
            'run-on-projects': dep_job.attributes.get('run_on_projects'),
            'treeherder': treeherder,
            'routes': job.get('routes', []),
        }

        if job.get('use-funsize-route', False):
            task['routes'].append("project.releng.funsize.level-{level}.{project}".format(
                project=config.params['project'], level=config.params['level']))

        yield task
