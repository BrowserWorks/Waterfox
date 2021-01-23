# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
"""
Add notifications via taskcluster-notify for release tasks
"""

from __future__ import absolute_import, print_function, unicode_literals

from string import Formatter
from taskgraph.transforms.base import TransformSequence
from taskgraph.util.scriptworker import get_release_config
from taskgraph.util.schema import resolve_keyed_by


transforms = TransformSequence()


class TitleCaseFormatter(Formatter):
    """Support title formatter for strings"""
    def convert_field(self, value, conversion):
        if conversion == 't':
            return str(value).title()
        super(TitleCaseFormatter, self).convert_field(value, conversion)
        return value


titleformatter = TitleCaseFormatter()


@transforms.add
def add_notifications(config, jobs):
    release_config = get_release_config(config)

    for job in jobs:
        label = '{}-{}'.format(config.kind, job['name'])

        notifications = job.pop('notifications')
        if notifications:
            resolve_keyed_by(notifications, 'emails', label, project=config.params['project'])
            emails = notifications['emails']
            format_kwargs = dict(
                task=job,
                config=config.__dict__,
                release_config=release_config,
            )
            subject = titleformatter.format(notifications['subject'], **format_kwargs)
            message = titleformatter.format(notifications['message'], **format_kwargs)
            emails = [email.format(**format_kwargs) for email in emails]

            # We only send mail on success to avoid messages like 'blah is in the
            # candidates dir' when cancelling graphs, dummy job failure, etc
            job.setdefault('routes', []).extend(
                ['notify.email.{}.on-completed'.format(email) for email in emails]
            )

            # Customize the email subject to include release name and build number
            job.setdefault('extra', {}).update(
                {
                   'notify': {
                       'email': {
                            'subject': subject,
                        }
                    }
                }
            )
            if message:
                job['extra']['notify']['email']['content'] = message

        yield job
