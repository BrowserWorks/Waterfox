mod progress;

use self::progress::Progress;
use anyhow::Result;
use flate2::read::GzDecoder;
use std::fs;
use std::path::Path;
use tar::Archive;
use walkdir::DirEntry;

const REVISION: &str = "792c645ca7d11a8d254df307d019c5bf01445c37";

#[rustfmt::skip]
static EXCLUDE: &[&str] = &[
    // Compile-fail expr parameter in const generic position: f::<1 + 2>()
    "test/ui/const-generics/const-expression-parameter.rs",

    // Deprecated anonymous parameter syntax in traits
    "test/ui/issues/issue-13105.rs",
    "test/ui/issues/issue-13775.rs",
    "test/ui/issues/issue-34074.rs",
    "test/ui/proc-macro/trait-fn-args-2015.rs",

    // Not actually test cases
    "test/rustdoc-ui/test-compile-fail2.rs",
    "test/rustdoc-ui/test-compile-fail3.rs",
    "test/ui/include-single-expr-helper.rs",
    "test/ui/include-single-expr-helper-1.rs",
    "test/ui/issues/auxiliary/issue-21146-inc.rs",
    "test/ui/json-bom-plus-crlf-multifile-aux.rs",
    "test/ui/lint/expansion-time-include.rs",
    "test/ui/macros/auxiliary/macro-comma-support.rs",
    "test/ui/macros/auxiliary/macro-include-items-expr.rs",
];

pub fn base_dir_filter(entry: &DirEntry) -> bool {
    let path = entry.path();
    if path.is_dir() {
        return true; // otherwise walkdir does not visit the files
    }
    if path.extension().map(|e| e != "rs").unwrap_or(true) {
        return false;
    }

    let mut path_string = path.to_string_lossy();
    if cfg!(windows) {
        path_string = path_string.replace('\\', "/").into();
    }
    let path = if let Some(path) = path_string.strip_prefix("tests/rust/src/") {
        path
    } else if let Some(path) = path_string.strip_prefix("tests/rust/library/") {
        path
    } else {
        panic!("unexpected path in Rust dist: {}", path_string);
    };

    // TODO assert that parsing fails on the parse-fail cases
    if path.starts_with("test/parse-fail")
        || path.starts_with("test/compile-fail")
        || path.starts_with("test/rustfix")
    {
        return false;
    }

    if path.starts_with("test/ui") {
        let stderr_path = entry.path().with_extension("stderr");
        if stderr_path.exists() {
            // Expected to fail in some way
            return false;
        }
    }

    !EXCLUDE.contains(&path)
}

#[allow(dead_code)]
pub fn edition(path: &Path) -> &'static str {
    if path.ends_with("dyn-2015-no-warnings-without-lints.rs") {
        "2015"
    } else {
        "2018"
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
    let mut missing = String::new();
    let test_src = Path::new("tests/rust/src");
    for exclude in EXCLUDE {
        if !test_src.join(exclude).exists() {
            missing += "\ntests/rust/src/";
            missing += exclude;
        }
    }
    if !missing.is_empty() {
        panic!("excluded test file does not exist:{}\n", missing);
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
    }

    fs::write("tests/rust/COMMIT", REVISION)?;
    Ok(())
}
