# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import json
import os
import threading

from mozlog.formatters import TbplFormatter
from mozrunner.utils import get_stack_fixer_function


class ReftestFormatter(TbplFormatter):
    """
    Formatter designed to preserve the legacy "tbpl" format in reftest.

    This is needed for both the reftest-analyzer and mozharness log parsing.
    We can change this format when both reftest-analyzer and mozharness have
    been changed to read structured logs.
    """

    def __call__(self, data):
        if 'component' in data and data['component'] == 'mozleak':
            # Output from mozleak requires that no prefix be added
            # so that mozharness will pick up these failures.
            return "%s\n" % data['message']

        formatted = TbplFormatter.__call__(self, data)
        if data['action'] == 'process_output':
            return formatted
        return 'REFTEST %s' % formatted

    def log(self, data):
        prefix = "%s |" % data['level'].upper()
        return "%s %s\n" % (prefix, data['message'])

    def test_end(self, data):
        extra = data.get('extra', {})
        status = data['status']
        test = data['test']

        status_msg = "TEST-"
        if 'expected' in data:
            status_msg += "UNEXPECTED-%s" % status
        else:
            if status != "PASS":
                status_msg += "KNOWN-"
            status_msg += status
            if extra.get('status_msg') == 'Random':
                status_msg += "(EXPECTED RANDOM)"


        output_text = "%s | %s | %s" % (status_msg, test, data.get("message", ""))

        if "reftest_screenshots" in extra:
            screenshots = extra["reftest_screenshots"]
            if len(screenshots) == 3:
                output_text += ("\nREFTEST   IMAGE 1 (TEST): data:image/png;base64,%s\n"
                                "REFTEST   IMAGE 2 (REFERENCE): data:image/png;base64,%s") % (screenshots[0]["screenshot"],
                                                                         screenshots[2]["screenshot"])
            elif len(screenshots) == 1:
                output_text += "\nREFTEST   IMAGE: data:image/png;base64,%(image1)s" % screenshots[0]["screenshot"]


        output_text += "\nREFTEST TEST-END | %s" % test
        return "%s\n" % output_text

    def process_output(self, data):
        return "%s\n" % data["data"]

    def suite_end(self, data):
        lines = []
        summary = data['extra']['results']
        summary['success'] = summary['Pass'] + summary['LoadOnly']
        lines.append("Successful: %(success)s (%(Pass)s pass, %(LoadOnly)s load only)" %
                     summary)
        summary['unexpected'] = (summary['Exception'] + summary['FailedLoad'] +
                                 summary['UnexpectedFail'] + summary['UnexpectedPass'] +
                                 summary['AssertionUnexpected'] +
                                 summary['AssertionUnexpectedFixed'])
        lines.append(("Unexpected: %(unexpected)s (%(UnexpectedFail)s unexpected fail, "
                      "%(UnexpectedPass)s unexpected pass, "
                      "%(AssertionUnexpected)s unexpected asserts, "
                      "%(FailedLoad)s failed load, "
                      "%(Exception)s exception)") % summary)
        summary['known'] = (summary['KnownFail'] + summary['AssertionKnown'] +
                            summary['Random'] + summary['Skip'] + summary['Slow'])
        lines.append(("Known problems: %(known)s (" +
                      "%(KnownFail)s known fail, " +
                      "%(AssertionKnown)s known asserts, " +
                      "%(Random)s random, " +
                      "%(Skip)s skipped, " +
                      "%(Slow)s slow)") % summary)
        lines = ["REFTEST INFO | %s" % s for s in lines]
        lines.append("REFTEST SUITE-END | Shutdown")
        return "INFO | Result summary:\n{}\n".format('\n'.join(lines))


class OutputHandler(object):
    """Process the output of a process during a test run and translate
    raw data logged from reftest.js to an appropriate structured log action,
    where applicable.
    """

    def __init__(self, log, utilityPath, symbolsPath=None):
        self.stack_fixer_function = get_stack_fixer_function(utilityPath, symbolsPath)
        self.log = log
        # needed for b2gautomation.py
        self.suite_finished = False

    def __call__(self, line):
        # need to return processed messages to appease remoteautomation.py
        if not line.strip():
            return []

        try:
            data = json.loads(line)
        except ValueError:
            self.verbatim(line)
            return [line]

        if isinstance(data, dict) and 'action' in data:
            if data['action'] == 'suite_end':
                self.suite_finished = True

            self.log.log_raw(data)
        else:
            self.verbatim(json.dumps(data))

        return [data]

    def verbatim(self, line):
        if self.stack_fixer_function:
            line = self.stack_fixer_function(line)
        self.log.process_output(threading.current_thread().name, line)
