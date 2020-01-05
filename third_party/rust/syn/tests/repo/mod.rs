mod progress;

use self::progress::Progress;
use crate::common;
use anyhow::Result;
use flate2::read::GzDecoder;
use std::fs;
use std::path::Path;
use tar::Archive;
use walkdir::DirEntry;

const REVISION: &str = "7979016aff545f7b41cc517031026020b340989d";

pub fn base_dir_filter(entry: &DirEntry) -> bool {
    let path = entry.path();
    if path.is_dir() {
        return true; // otherwise walkdir does not visit the files
    }
    if path.extension().map(|e| e != "rs").unwrap_or(true) {
        return false;
    }
    let path_string = path.to_string_lossy();
    let path_string = if cfg!(windows) {
        path_string.replace('\\', "/").into()
    } else {
        path_string
    };
    // TODO assert that parsing fails on the parse-fail cases
    if path_string.starts_with("tests/rust/src/test/parse-fail")
        || path_string.starts_with("tests/rust/src/test/compile-fail")
        || path_string.starts_with("tests/rust/src/test/rustfix")
    {
        return false;
    }

    if path_string.starts_with("tests/rust/src/test/ui") {
        let stderr_path = path.with_extension("stderr");
        if stderr_path.exists() {
            // Expected to fail in some way
            return false;
        }
    }

    match path_string.as_ref() {
        // Deprecated placement syntax
        "tests/rust/src/test/ui/obsolete-in-place/bad.rs" |
        // Deprecated anonymous parameter syntax in traits
        "tests/rust/src/test/ui/error-codes/e0119/auxiliary/issue-23563-a.rs" |
        "tests/rust/src/test/ui/issues/issue-13105.rs" |
        "tests/rust/src/test/ui/issues/issue-13775.rs" |
        "tests/rust/src/test/ui/issues/issue-34074.rs" |
        // Deprecated await macro syntax
        "tests/rust/src/test/ui/async-await/await-macro.rs" |
        // 2015-style dyn that libsyntax rejects
        "tests/rust/src/test/ui/dyn-keyword/dyn-2015-no-warnings-without-lints.rs" |
        // not actually test cases
        "tests/rust/src/test/ui/include-single-expr-helper.rs" |
        "tests/rust/src/test/ui/include-single-expr-helper-1.rs" |
        "tests/rust/src/test/ui/issues/auxiliary/issue-21146-inc.rs" |
        "tests/rust/src/test/ui/macros/auxiliary/macro-comma-support.rs" |
        "tests/rust/src/test/ui/macros/auxiliary/macro-include-items-expr.rs" => false,
        _ => true,
    }
}

pub fn clone_rust() {
    let needs_clone = match fs::read_to_string("tests/rust/COMMIT") {
        Err(_) => true,
        Ok(contents) => contents.trim() != REVISION,
    };
    if needs_clone {
        download_and_unpack().unwrap();
    }
}

fn download_and_unpack() -> Result<()> {
    let url = format!(
        "https://github.com/rust-lang/rust/archive/{}.tar.gz",
        REVISION
    );
    let response = reqwest::blocking::get(&url)?.error_for_status()?;
    let progress = Progress::new(response);
    let decoder = GzDecoder::new(progress);
    let mut archive = Archive::new(decoder);
    let prefix = format!("rust-{}", REVISION);

    let tests_rust = Path::new("tests/rust");
    if tests_rust.exists() {
        fs::remove_dir_all(tests_rust)?;
    }

    for entry in archive.entries()? {
        let mut entry = entry?;
        let path = entry.path()?;
        if path == Path::new("pax_global_header") {
            continue;
        }
        let relative = path.strip_prefix(&prefix)?;
        let out = tests_rust.join(relative);
        entry.unpack(&out)?;
        if common::travis_ci() {
            // Something about this makes the travis build not deadlock...
            errorf!(".");
        }
    }

    fs::write("tests/rust/COMMIT", REVISION)?;
    Ok(())
}
