# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for coverage.py's results analysis."""

import pytest

from coverage.misc import CoverageException
from coverage.results import format_lines, Numbers, should_fail_under

from tests.coveragetest import CoverageTest


class NumbersTest(CoverageTest):
    """Tests for coverage.py's numeric measurement summaries."""

    run_in_temp_dir = False

    def test_basic(self):
        n1 = Numbers(n_files=1, n_statements=200, n_missing=20)
        self.assertEqual(n1.n_statements, 200)
        self.assertEqual(n1.n_executed, 180)
        self.assertEqual(n1.n_missing, 20)
        self.assertEqual(n1.pc_covered, 90)

    def test_addition(self):
        n1 = Numbers(n_files=1, n_statements=200, n_missing=20)
        n2 = Numbers(n_files=1, n_statements=10, n_missing=8)
        n3 = n1 + n2
        self.assertEqual(n3.n_files, 2)
        self.assertEqual(n3.n_statements, 210)
        self.assertEqual(n3.n_executed, 182)
        self.assertEqual(n3.n_missing, 28)
        self.assertAlmostEqual(n3.pc_covered, 86.666666666)

    def test_sum(self):
        n1 = Numbers(n_files=1, n_statements=200, n_missing=20)
        n2 = Numbers(n_files=1, n_statements=10, n_missing=8)
        n3 = sum([n1, n2])
        self.assertEqual(n3.n_files, 2)
        self.assertEqual(n3.n_statements, 210)
        self.assertEqual(n3.n_executed, 182)
        self.assertEqual(n3.n_missing, 28)
        self.assertAlmostEqual(n3.pc_covered, 86.666666666)

    def test_pc_covered_str(self):
        # Numbers._precision is a global, which is bad.
        Numbers.set_precision(0)
        n0 = Numbers(n_files=1, n_statements=1000, n_missing=0)
        n1 = Numbers(n_files=1, n_statements=1000, n_missing=1)
        n999 = Numbers(n_files=1, n_statements=1000, n_missing=999)
        n1000 = Numbers(n_files=1, n_statements=1000, n_missing=1000)
        self.assertEqual(n0.pc_covered_str, "100")
        self.assertEqual(n1.pc_covered_str, "99")
        self.assertEqual(n999.pc_covered_str, "1")
        self.assertEqual(n1000.pc_covered_str, "0")

    def test_pc_covered_str_precision(self):
        # Numbers._precision is a global, which is bad.
        Numbers.set_precision(1)
        n0 = Numbers(n_files=1, n_statements=10000, n_missing=0)
        n1 = Numbers(n_files=1, n_statements=10000, n_missing=1)
        n9999 = Numbers(n_files=1, n_statements=10000, n_missing=9999)
        n10000 = Numbers(n_files=1, n_statements=10000, n_missing=10000)
        self.assertEqual(n0.pc_covered_str, "100.0")
        self.assertEqual(n1.pc_covered_str, "99.9")
        self.assertEqual(n9999.pc_covered_str, "0.1")
        self.assertEqual(n10000.pc_covered_str, "0.0")
        Numbers.set_precision(0)

    def test_covered_ratio(self):
        n = Numbers(n_files=1, n_statements=200, n_missing=47)
        self.assertEqual(n.ratio_covered, (153, 200))

        n = Numbers(
            n_files=1, n_statements=200, n_missing=47,
            n_branches=10, n_missing_branches=3, n_partial_branches=1000,
        )
        self.assertEqual(n.ratio_covered, (160, 210))


@pytest.mark.parametrize("total, fail_under, precision, result", [
    # fail_under==0 means anything is fine!
    (0, 0, 0, False),
    (0.001, 0, 0, False),
    # very small fail_under is possible to fail.
    (0.001, 0.01, 0, True),
    # Rounding should work properly.
    (42.1, 42, 0, False),
    (42.1, 43, 0, True),
    (42.857, 42, 0, False),
    (42.857, 43, 0, False),
    (42.857, 44, 0, True),
    (42.857, 42.856, 3, False),
    (42.857, 42.858, 3, True),
    # If you don't specify precision, your fail-under is rounded.
    (42.857, 42.856, 0, False),
    # Values near 100 should only be treated as 100 if they are 100.
    (99.8, 100, 0, True),
    (100.0, 100, 0, False),
    (99.8, 99.7, 1, False),
    (99.88, 99.90, 2, True),
    (99.999, 100, 1, True),
    (99.999, 100, 2, True),
    (99.999, 100, 3, True),
])
def test_should_fail_under(total, fail_under, precision, result):
    assert should_fail_under(float(total), float(fail_under), precision) == result


def test_should_fail_under_invalid_value():
    with pytest.raises(CoverageException, match=r"fail_under=101"):
        should_fail_under(100.0, 101, 0)


@pytest.mark.parametrize("statements, lines, result", [
    (set([1,2,3,4,5,10,11,12,13,14]), set([1,2,5,10,11,13,14]), "1-2, 5-11, 13-14"),
    ([1,2,3,4,5,10,11,12,13,14,98,99], [1,2,5,10,11,13,14,99], "1-2, 5-11, 13-14, 99"),
    ([1,2,3,4,98,99,100,101,102,103,104], [1,2,99,102,103,104], "1-2, 99, 102-104"),
    ([17], [17], "17"),
    ([90,91,92,93,94,95], [90,91,92,93,94,95], "90-95"),
    ([1, 2, 3, 4, 5], [], ""),
    ([1, 2, 3, 4, 5], [4], "4"),
])
def test_format_lines(statements, lines, result):
    assert format_lines(statements, lines) == result


@pytest.mark.parametrize("statements, lines, arcs, result", [
    (
        set([1,2,3,4,5,10,11,12,13,14]),
        set([1,2,5,10,11,13,14]),
        (),
        "1-2, 5-11, 13-14"
        ),
    (
        [1,2,3,4,5,10,11,12,13,14,98,99],
        [1,2,5,10,11,13,14,99],
        [(3, [4]), (5, [10, 11]), (98, [100, -1])],
        "1-2, 3->4, 5-11, 13-14, 98->100, 98->exit, 99"
        ),
    (
        [1,2,3,4,98,99,100,101,102,103,104],
        [1,2,99,102,103,104],
        [(3, [4]), (104, [-1])],
        "1-2, 3->4, 99, 102-104"
        ),
])
def test_format_lines_with_arcs(statements, lines, arcs, result):
    assert format_lines(statements, lines, arcs) == result
