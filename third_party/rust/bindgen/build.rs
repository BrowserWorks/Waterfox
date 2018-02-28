mod codegen {
    extern crate quasi_codegen;
    use std::env;
    use std::fs::File;
    use std::io::Write;
    use std::path::{Path, PathBuf};

    pub fn main() {
        let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
        let src = Path::new("src/codegen/mod.rs");
        let dst = Path::new(&out_dir).join("codegen.rs");

        quasi_codegen::expand(&src, &dst).unwrap();
        println!("cargo:rerun-if-changed=src/codegen/mod.rs");
        println!("cargo:rerun-if-changed=src/codegen/error.rs");
        println!("cargo:rerun-if-changed=src/codegen/helpers.rs");
        println!("cargo:rerun-if-changed=src/codegen/struct_layout.rs");

        let mut dst =
            File::create(Path::new(&out_dir).join("host-target.txt")).unwrap();
        dst.write_all(env::var("TARGET").unwrap().as_bytes()).unwrap();
    }
}

mod testgen {
    use std::char;
    use std::env;
    use std::ffi::OsStr;
    use std::fs::{self, File};
    use std::io::Write;
    use std::path::{Path, PathBuf};

    pub fn main() {
        let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
        let mut dst = File::create(Path::new(&out_dir).join("tests.rs")).unwrap();

        let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
        let headers_dir = manifest_dir.join("tests").join("headers");

        let headers = match fs::read_dir(headers_dir) {
            Ok(dir) => dir,
            // We may not have headers directory after packaging.
            Err(..) => return,
        };

        let entries =
            headers.map(|result| result.expect("Couldn't read header file"));

        println!("cargo:rerun-if-changed=tests/headers");

        for entry in entries {
            match entry.path().extension().and_then(OsStr::to_str) {
                Some("h") | Some("hpp") => {
                    let func = entry.file_name().to_str().unwrap()
                        .replace(|c| !char::is_alphanumeric(c), "_")
                        .replace("__", "_")
                        .to_lowercase();
                    writeln!(dst, "test_header!(header_{}, {:?});",
                             func, entry.path()).unwrap();
                }
                _ => {}
            }
        }

        dst.flush().unwrap();
    }
}

fn main() {
    codegen::main();
    testgen::main();
}
