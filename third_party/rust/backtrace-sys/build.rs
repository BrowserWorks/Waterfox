extern crate cc;

use std::env;
use std::fs::File;
use std::path::PathBuf;

fn main() {
    let target = env::var("TARGET").unwrap();

    if target.contains("msvc") || // libbacktrace isn't used on MSVC windows
        target.contains("emscripten") || // no way this will ever compile for emscripten
        target.contains("cloudabi") ||
        target.contains("wasm32") ||
        target.contains("fuchsia")
    // fuchsia uses external out-of-process symbolization
    {
        println!("cargo:rustc-cfg=empty");
        return;
    }

    let out_dir = PathBuf::from(env::var_os("OUT_DIR").unwrap());

    let mut build = cc::Build::new();
    build
        .include("src/libbacktrace")
        .include(&out_dir)
        .warnings(false)
        .file("src/libbacktrace/alloc.c")
        .file("src/libbacktrace/dwarf.c")
        .file("src/libbacktrace/fileline.c")
        .file("src/libbacktrace/posix.c")
        .file("src/libbacktrace/read.c")
        .file("src/libbacktrace/sort.c")
        .file("src/libbacktrace/state.c");

    // No need to have any symbols reexported form shared objects
    build.flag("-fvisibility=hidden");

    if target.contains("darwin") {
        build.file("src/libbacktrace/macho.c");
    } else if target.contains("windows") {
        build.file("src/libbacktrace/pecoff.c");
    } else {
        build.file("src/libbacktrace/elf.c");

        let pointer_width = env::var("CARGO_CFG_TARGET_POINTER_WIDTH").unwrap();
        if pointer_width == "64" {
            build.define("BACKTRACE_ELF_SIZE", "64");
        } else {
            build.define("BACKTRACE_ELF_SIZE", "32");
        }
    }

    File::create(out_dir.join("backtrace-supported.h")).unwrap();
    build.define("BACKTRACE_SUPPORTED", "1");
    build.define("BACKTRACE_USES_MALLOC", "1");
    build.define("BACKTRACE_SUPPORTS_THREADS", "0");
    build.define("BACKTRACE_SUPPORTS_DATA", "0");

    File::create(out_dir.join("config.h")).unwrap();
    if target.contains("android") {
        maybe_enable_dl_iterate_phdr_android(&mut build);
    } else if !target.contains("apple-ios")
        && !target.contains("solaris")
        && !target.contains("redox")
        && !target.contains("haiku")
        && !target.contains("vxworks")
    {
        build.define("HAVE_DL_ITERATE_PHDR", "1");
    }
    build.define("_GNU_SOURCE", "1");
    build.define("_LARGE_FILES", "1");

    // When we're built as part of the Rust compiler, this is used to enable
    // debug information in libbacktrace itself.
    let any_debug = env::var("RUSTC_DEBUGINFO").unwrap_or_default() == "true"
        || env::var("RUSTC_DEBUGINFO_LINES").unwrap_or_default() == "true";
    build.debug(any_debug);

    let syms = [
        "backtrace_full",
        "backtrace_dwarf_add",
        "backtrace_initialize",
        "backtrace_pcinfo",
        "backtrace_syminfo",
        "backtrace_get_view",
        "backtrace_release_view",
        "backtrace_alloc",
        "backtrace_free",
        "backtrace_vector_finish",
        "backtrace_vector_grow",
        "backtrace_vector_release",
        "backtrace_close",
        "backtrace_open",
        "backtrace_print",
        "backtrace_simple",
        "backtrace_qsort",
        "backtrace_create_state",
        "backtrace_uncompress_zdebug",
        // These should be `static` in C, but they aren't...
        "macho_get_view",
        "macho_symbol_type_relevant",
        "macho_get_commands",
        "macho_try_dsym",
        "macho_try_dwarf",
        "macho_get_addr_range",
        "macho_get_uuid",
        "macho_add",
        "macho_add_symtab",
        "macho_file_to_host_u64",
        "macho_file_to_host_u32",
        "macho_file_to_host_u16",
    ];
    let prefix = if cfg!(feature = "rustc-dep-of-std") {
        println!("cargo:rustc-cfg=rdos");
        "__rdos_"
    } else {
        println!("cargo:rustc-cfg=rbt");
        "__rbt_"
    };
    for sym in syms.iter() {
        build.define(sym, &format!("{}{}", prefix, sym)[..]);
    }

    build.compile("backtrace");
}

// The `dl_iterate_phdr` API was added in Android API 21+ (according to #227),
// so if we can dynamically detect an appropriately configured C compiler for
// that then let's enable the `dl_iterate_phdr` API, otherwise Android just
// won't have any information.
fn maybe_enable_dl_iterate_phdr_android(build: &mut cc::Build) {
    let expansion = cc::Build::new().file("src/android-api.c").expand();
    let expansion = match std::str::from_utf8(&expansion) {
        Ok(s) => s,
        Err(_) => return,
    };
    println!("expanded android version detection:\n{}", expansion);
    let marker = "APIVERSION";
    let i = match expansion.find(marker) {
        Some(i) => i,
        None => return,
    };
    let version = match expansion[i + marker.len() + 1..].split_whitespace().next() {
        Some(s) => s,
        None => return,
    };
    let version = match version.parse::<u32>() {
        Ok(n) => n,
        Err(_) => return,
    };
    if version >= 21 {
        build.define("HAVE_DL_ITERATE_PHDR", "1");
    }
}
