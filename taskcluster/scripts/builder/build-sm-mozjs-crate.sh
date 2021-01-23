#!/usr/bin/env bash

set -xe

source $(dirname $0)/sm-tooltool-config.sh

cd "$SRCDIR/js/src"

cp $SRCDIR/.cargo/config.in $SRCDIR/.cargo/config

export PATH="$PATH:$MOZ_FETCHES_DIR/cargo/bin:$MOZ_FETCHES_DIR/rustc/bin"
export RUSTFMT="$MOZ_FETCHES_DIR/rustc/bin/rustfmt"
export RUST_BACKTRACE=1
export AUTOMATION=1

cargo build --verbose --frozen --features debugmozjs
cargo build --verbose --frozen
