extern crate bindgen;
#[cfg(feature = "logging")]
extern crate env_logger;
#[macro_use]
#[cfg(feature = "logging")]
extern crate log;
extern crate clap;

use bindgen::clang_version;
use std::env;
use std::panic;

#[macro_use]
#[cfg(not(feature = "logging"))]
mod log_stubs;

mod options;
use options::builder_from_flags;

pub fn main() {
    #[cfg(feature = "logging")]
    env_logger::init();

    let bind_args: Vec<_> = env::args().collect();

    let version = clang_version();
    let expected_version = if cfg!(feature = "testing_only_libclang_4") {
        (4, 0)
    } else if cfg!(feature = "testing_only_libclang_3_8") {
        (3, 8)
    } else {
        // Default to 3.9.
        (3, 9)
    };

    info!("Clang Version: {}", version.full);

    match version.parsed {
        None => warn!("Couldn't parse libclang version"),
        Some(version) if version != expected_version => {
            warn!("Using clang {:?}, expected {:?}", version, expected_version);
        }
        _ => {}
    }

    match builder_from_flags(bind_args.into_iter()) {
        Ok((builder, output, verbose)) => {
            let builder_result = panic::catch_unwind(|| {
                builder.generate().expect("Unable to generate bindings")
            });

            if builder_result.is_err() {
                if verbose {
                    print_verbose_err();
                }
                std::process::exit(1);
            }

            let bindings = builder_result.unwrap();
            bindings.write(output).expect("Unable to write output");
        }
        Err(error) => {
            println!("{}", error);
            std::process::exit(1);
        }
    };
}

fn print_verbose_err() {
    println!("Bindgen unexpectedly panicked");
    println!(
        "This may be caused by one of the known-unsupported \
         things (https://rust-lang.github.io/rust-bindgen/cpp.html), \
         please modify the bindgen flags to work around it as \
         described in https://rust-lang.github.io/rust-bindgen/cpp.html"
    );
    println!(
        "Otherwise, please file an issue at \
         https://github.com/rust-lang/rust-bindgen/issues/new"
    );
}
