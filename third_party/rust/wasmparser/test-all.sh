#!/bin/bash
set -euo pipefail

# This is the top-level test script:
#
# - Check code formatting.
# - Make a debug build.
# - Make a release build.
# - Run unit tests for all Rust crates.
# - Build API documentation.
#
# All tests run by this script should be passing at all times.

# Repository top-level directory.
topdir=$(dirname "$0")
cd "$topdir"

function banner {
    echo "======  $*  ======"
}

# Run rustfmt if we have it.
banner "Rust formatting"
if type rustfmt > /dev/null; then
    if ! "$topdir/format-all.sh" --check ; then
        echo "Formatting diffs detected! Run \"cargo fmt --all\" to correct."
        exit 1
    fi
else
    echo "rustfmt not available; formatting not checked!"
    echo
    echo "If you are using rustup, rustfmt can be installed via"
    echo "\"rustup component add --toolchain=stable rustfmt-preview\", or see"
    echo "https://github.com/rust-lang-nursery/rustfmt for more information."
fi

# Make sure the code builds in release mode.
banner "Rust release build"
cargo build --release

# Make sure the code builds in debug mode.
banner "Rust debug build"
cargo build

# Run the tests. We run these in debug mode so that assertions are enabled.
banner "Rust unit tests"
cargo test --all

# Run only tests with "deterministic" feature.
banner "Rust deterministic unit tests"
cargo test --features "deterministic"

# Make sure the documentation builds.
banner "Rust documentation: $topdir/target/doc/wasmparser/index.html"
cargo doc

banner "OK"
