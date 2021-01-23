import mozunit
import os

LINTER = 'clippy'


def test_basic(lint, config, paths):
    results = lint(paths("test1/"))
    print(results)
    assert len(results) > 7

    assert "is never read" in results[0].message or 'but never used' in results[0].message
    assert results[0].level == "warning"
    assert results[0].lineno == 7
    assert results[0].column == 9
    assert results[0].rule == "unused_assignments"
    assert results[0].relpath == "test1/bad.rs"
    assert "tools/lint/test/files/clippy/test1/bad.rs" in results[0].path

    assert "value assigned to `b` is never read" in results[1].message
    assert results[1].level == "warning"
    assert results[1].relpath == "test1/bad.rs"

    assert "this looks like you are trying to swap `a` and `b`" in results[2].message
    assert results[2].level == "error"
    assert results[2].relpath == "test1/bad.rs"
    assert results[2].rule == "clippy::almost_swapped"
    assert "or maybe you should use `std::mem::replace`" in results[2].hint

    assert "variable does not need to be mutable" in results[6].message
    assert results[6].relpath == "test1/bad2.rs"
    assert results[6].rule == "unused_mut"

    assert "this range is empty so this for loop will never run" in results[7].message
    assert results[7].level == "error"
    assert results[7].relpath == "test1/bad2.rs"
    assert results[7].rule == "clippy::reverse_range_loop"


def test_error(lint, config, paths):
    results = lint(paths("test1/Cargo.toml"))
    # Should fail. We don't accept Cargo.toml as input
    assert results == 1


def test_file_and_path_provided(lint, config, paths):
    results = lint(paths("./test2/src/bad_1.rs", "test1/"))
    # even if clippy analyzed it
    # we should not have anything from bad_2.rs
    # as mozlint is filtering out the file
    print(results)
    assert len(results) > 16
    assert "value assigned to `a` is never read" in results[0].message
    assert results[0].level == "warning"
    assert results[0].lineno == 7
    assert results[0].column == 9
    assert results[0].rule == "unused_assignments"
    assert results[0].relpath == "test1/bad.rs"
    assert "tools/lint/test/files/clippy/test1/bad.rs" in results[0].path
    assert "value assigned to `a` is never read" in results[0].message
    assert results[8].level == "warning"
    assert results[8].lineno == 9
    assert results[8].column == 9
    assert results[8].rule == "unused_assignments"
    assert results[8].relpath == "test2/src/bad_1.rs"
    assert "tools/lint/test/files/clippy/test2/src/bad_1.rs" in results[8].path
    for r in results:
        assert "bad_2.rs" not in r.relpath


def test_file_provided(lint, config, paths):
    results = lint(paths("./test2/src/bad_1.rs"))
    # even if clippy analyzed it
    # we should not have anything from bad_2.rs
    # as mozlint is filtering out the file
    print(results)
    assert len(results) > 8
    assert results[0].level == "warning"
    assert results[0].lineno == 9
    assert results[0].column == 9
    assert results[0].rule == "unused_assignments"
    assert results[0].relpath == "test2/src/bad_1.rs"
    assert "tools/lint/test/files/clippy/test2/src/bad_1.rs" in results[0].path
    for r in results:
        assert "bad_2.rs" not in r.relpath


def test_cleanup(lint, paths, root):
    # If Cargo.lock does not exist before clippy run, delete it
    lint(paths("test1/"))
    assert not os.path.exists(os.path.join(root, "test1/target/"))
    assert not os.path.exists(os.path.join(root, "test1/Cargo.lock"))

    # If Cargo.lock exists before clippy run, keep it after cleanup
    lint(paths("test2/"))
    assert not os.path.exists(os.path.join(root, "test2/target/"))
    assert os.path.exists(os.path.join(root, "test2/Cargo.lock"))


if __name__ == '__main__':
    mozunit.main()
