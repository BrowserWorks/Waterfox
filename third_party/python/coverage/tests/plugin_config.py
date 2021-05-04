# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""A configuring plugin for test_plugins.py to import."""

import coverage


class Plugin(coverage.CoveragePlugin):
    """A configuring plugin for testing."""
    def configure(self, config):
        """Configure all the things!"""
        opt_name = "report:exclude_lines"
        exclude_lines = config.get_option(opt_name)
        exclude_lines.append(r"pragma: custom")
        exclude_lines.append(r"pragma: or whatever")
        config.set_option(opt_name, exclude_lines)


def coverage_init(reg, options):        # pylint: disable=unused-argument
    """Called by coverage to initialize the plugins here."""
    reg.add_configurer(Plugin())
