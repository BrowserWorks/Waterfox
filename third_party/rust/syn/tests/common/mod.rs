#![allow(dead_code)]

use std::env;

pub mod eq;
pub mod parse;

/// Read the `ABORT_AFTER_FAILURE` environment variable, and parse it.
pub fn abort_after() -> usize {
    match env::var("ABORT_AFTER_FAILURE") {
        Ok(s) => s.parse().expect("failed to parse ABORT_AFTER_FAILURE"),
        Err(_) => usize::max_value(),
    }
}

/// Are we running in travis-ci.org.
pub fn travis_ci() -> bool {
    env::var_os("TRAVIS").is_some()
}
