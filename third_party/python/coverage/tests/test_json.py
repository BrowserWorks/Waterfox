# coding: utf-8
# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Test json-based summary reporting for coverage.py"""
from datetime import datetime
import json
import os

import coverage
from tests.coveragetest import UsingModulesMixin, CoverageTest


class JsonReportTest(UsingModulesMixin, CoverageTest):
    """Tests of the JSON reports from coverage.py."""
    def _assert_expected_json_report(self, cov, expected_result):
        """
        Helper for tests that handles the common ceremony so the tests can be clearly show the
        consequences of setting various arguments.
        """
        self.make_file("a.py", """\
            a = {'b': 1}
            if a.get('a'):
                b = 1
            """)
        a = self.start_import_stop(cov, "a")
        output_path = os.path.join(self.temp_dir, "a.json")
        cov.json_report(a, outfile=output_path)
        with open(output_path) as result_file:
            parsed_result = json.load(result_file)
        self.assert_recent_datetime(
            datetime.strptime(parsed_result['meta']['timestamp'], "%Y-%m-%dT%H:%M:%S.%f")
        )
        del (parsed_result['meta']['timestamp'])
        assert parsed_result == expected_result

    def test_branch_coverage(self):
        cov = coverage.Coverage(branch=True)
        expected_result = {
            'meta': {
                "version": coverage.__version__,
                "branch_coverage": True,
                "show_contexts": False,
            },
            'files': {
                'a.py': {
                    'executed_lines': [1, 2],
                    'missing_lines': [3],
                    'excluded_lines': [],
                    'summary': {
                        'missing_lines': 1,
                        'covered_lines': 2,
                        'num_statements': 3,
                        'num_branches': 2,
                        'excluded_lines': 0,
                        'num_partial_branches': 1,
                        'covered_branches': 1,
                        'missing_branches': 1,
                        'percent_covered': 60.0,
                    }
                }
            },
            'totals': {
                'missing_lines': 1,
                'covered_lines': 2,
                'num_statements': 3,
                'num_branches': 2,
                'excluded_lines': 0,
                'num_partial_branches': 1,
                'percent_covered': 60.0,
                'covered_branches': 1,
                'missing_branches': 1,
            }
        }
        self._assert_expected_json_report(cov, expected_result)

    def test_simple_line_coverage(self):
        cov = coverage.Coverage()
        expected_result = {
            'meta': {
                "version": coverage.__version__,
                "branch_coverage": False,
                "show_contexts": False,
            },
            'files': {
                'a.py': {
                    'executed_lines': [1, 2],
                    'missing_lines': [3],
                    'excluded_lines': [],
                    'summary': {
                        'excluded_lines': 0,
                        'missing_lines': 1,
                        'covered_lines': 2,
                        'num_statements': 3,
                        'percent_covered': 66.66666666666667
                    }
                }
            },
            'totals': {
                'excluded_lines': 0,
                'missing_lines': 1,
                'covered_lines': 2,
                'num_statements': 3,
                'percent_covered': 66.66666666666667
            }
        }
        self._assert_expected_json_report(cov, expected_result)

    def run_context_test(self, relative_files):
        """A helper for two tests below."""
        self.make_file("config", """\
            [run]
            relative_files = {}

            [json]
            show_contexts = True
            """.format(relative_files))
        cov = coverage.Coverage(context="cool_test", config_file="config")
        expected_result = {
            'meta': {
                "version": coverage.__version__,
                "branch_coverage": False,
                "show_contexts": True,
            },
            'files': {
                'a.py': {
                    'executed_lines': [1, 2],
                    'missing_lines': [3],
                    'excluded_lines': [],
                    "contexts": {
                        "1": [
                            "cool_test"
                        ],
                        "2": [
                            "cool_test"
                        ]
                    },
                    'summary': {
                        'excluded_lines': 0,
                        'missing_lines': 1,
                        'covered_lines': 2,
                        'num_statements': 3,
                        'percent_covered': 66.66666666666667
                    }
                }
            },
            'totals': {
                'excluded_lines': 0,
                'missing_lines': 1,
                'covered_lines': 2,
                'num_statements': 3,
                'percent_covered': 66.66666666666667
            }
        }
        self._assert_expected_json_report(cov, expected_result)

    def test_context_non_relative(self):
        self.run_context_test(relative_files=False)

    def test_context_relative(self):
        self.run_context_test(relative_files=True)
