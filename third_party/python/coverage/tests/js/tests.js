/* Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0 */
/* For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt */

// Tests of coverage.py HTML report chunk navigation.
/*global coverage, jQuery, $ */

// Test helpers

function selection_is(assert, sel) {
    raw_selection_is(assert, sel, true);
}

function raw_selection_is(assert, sel, check_highlight) {
    var beg = sel[0], end = sel[1];
    assert.equal(coverage.sel_begin, beg);
    assert.equal(coverage.sel_end, end);
    if (check_highlight) {
        assert.equal($(".linenos .highlight").length, end-beg);
    }
}

// The spec is a list of "rbw" letters, indicating colors of successive lines.
// We set the show_r and show_b classes for r and b.
function build_fixture(spec) {
    var i, data;
    $("#fixture-template").tmpl().appendTo("#qunit-fixture");
    for (i = 0; i < spec.length; i++) {
        data = {number: i+1, klass: spec.substr(i, 1)};
        $("#lineno-template").tmpl(data).appendTo("#qunit-fixture .linenos");
        $("#text-template").tmpl(data).appendTo("#qunit-fixture .text");
    }
    coverage.pyfile_ready(jQuery);
}

// Tests

// Zero-chunk tests

QUnit.module("Zero-chunk navigation", {
    beforeEach: function () {
        build_fixture("wwww");
    }
});

QUnit.test("set_sel defaults", function (assert) {
    coverage.set_sel(2);
    assert.equal(coverage.sel_begin, 2);
    assert.equal(coverage.sel_end, 3);
});

QUnit.test("No first chunk to select", function (assert) {
    coverage.to_first_chunk();
    assert.expect(0);
});

// One-chunk tests

$.each([
    ['rrrrr', [1,6]],
    ['r', [1,2]],
    ['wwrrrr', [3,7]],
    ['wwrrrrww', [3,7]],
    ['rrrrww', [1,5]]
], function (i, params) {

    // Each of these tests uses a fixture with one highlighted chunks.
    var id = params[0];
    var c1 = params[1];

    QUnit.module("One-chunk navigation - " + id, {
        beforeEach: function () {
            build_fixture(id);
        }
    });

    QUnit.test("First chunk", function (assert) {
        coverage.to_first_chunk();
        selection_is(assert, c1);
    });

    QUnit.test("Next chunk is first chunk", function (assert) {
        coverage.to_next_chunk();
        selection_is(assert, c1);
    });

    QUnit.test("There is no next chunk", function (assert) {
        coverage.to_first_chunk();
        coverage.to_next_chunk();
        selection_is(assert, c1);
    });

    QUnit.test("There is no prev chunk", function (assert) {
        coverage.to_first_chunk();
        coverage.to_prev_chunk();
        selection_is(assert, c1);
    });
});

// Two-chunk tests

$.each([
    ['rrwwrrrr', [1,3], [5,9]],
    ['rb', [1,2], [2,3]],
    ['rbbbbbbbbbb', [1,2], [2,12]],
    ['rrrrrrrrrrb', [1,11], [11,12]],
    ['wrrwrrrrw', [2,4], [5,9]],
    ['rrrbbb', [1,4], [4,7]]
], function (i, params) {

    // Each of these tests uses a fixture with two highlighted chunks.
    var id = params[0];
    var c1 = params[1];
    var c2 = params[2];

    QUnit.module("Two-chunk navigation - " + id, {
        beforeEach: function () {
            build_fixture(id);
        }
    });

    QUnit.test("First chunk", function (assert) {
        coverage.to_first_chunk();
        selection_is(assert, c1);
    });

    QUnit.test("Next chunk is first chunk", function (assert) {
        coverage.to_next_chunk();
        selection_is(assert, c1);
    });

    QUnit.test("Move to next chunk", function (assert) {
        coverage.to_first_chunk();
        coverage.to_next_chunk();
        selection_is(assert, c2);
    });

    QUnit.test("Move to first chunk", function (assert) {
        coverage.to_first_chunk();
        coverage.to_next_chunk();
        coverage.to_first_chunk();
        selection_is(assert, c1);
    });

    QUnit.test("Move to previous chunk", function (assert) {
        coverage.to_first_chunk();
        coverage.to_next_chunk();
        coverage.to_prev_chunk();
        selection_is(assert, c1);
    });

    QUnit.test("Next doesn't move after last chunk", function (assert) {
        coverage.to_first_chunk();
        coverage.to_next_chunk();
        coverage.to_next_chunk();
        selection_is(assert, c2);
    });

    QUnit.test("Prev doesn't move before first chunk", function (assert) {
        coverage.to_first_chunk();
        coverage.to_next_chunk();
        coverage.to_prev_chunk();
        coverage.to_prev_chunk();
        selection_is(assert, c1);
    });

});

QUnit.module("Miscellaneous");

QUnit.test("Jump from a line selected", function (assert) {
    build_fixture("rrwwrr");
    coverage.set_sel(3);
    coverage.to_next_chunk();
    selection_is(assert, [5,7]);
});

// Tests of select_line_or_chunk.

$.each([
    // The data for each test: a spec for the fixture to build, and an array
    // of the selection that will be selected by select_line_or_chunk for
    // each line in the fixture.
    ['rrwwrr', [[1,3], [1,3], [3,4], [4,5], [5,7], [5,7]]],
    ['rb', [[1,2], [2,3]]],
    ['r', [[1,2]]],
    ['w', [[1,2]]],
    ['www', [[1,2], [2,3], [3,4]]],
    ['wwwrrr', [[1,2], [2,3], [3,4], [4,7], [4,7], [4,7]]],
    ['rrrwww', [[1,4], [1,4], [1,4], [4,5], [5,6], [6,7]]],
    ['rrrbbb', [[1,4], [1,4], [1,4], [4,7], [4,7], [4,7]]]
], function (i, params) {

    // Each of these tests uses a fixture with two highlighted chunks.
    var id = params[0];
    var sels = params[1];

    QUnit.module("Select line or chunk - " + id, {
        beforeEach: function () {
            build_fixture(id);
        }
    });

    $.each(sels, function (i, sel) {
        i++;
        QUnit.test("Select line " + i, function (assert) {
            coverage.select_line_or_chunk(i);
            raw_selection_is(assert, sel);
        });
    });
});
