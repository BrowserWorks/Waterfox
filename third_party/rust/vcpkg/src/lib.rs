//! A build dependency for Cargo libraries to find libraries in a
//! [Vcpkg](https://github.com/Microsoft/vcpkg) tree. From a Vcpkg package name
//! this build helper will emit cargo metadata to link it and it's dependencies
//! (excluding system libraries, which it cannot derive).
//!
//! **Note:** You must set one of `RUSTFLAGS=-Ctarget-feature=+crt-static` or
//! `VCPKGRS_DYNAMIC=1` in your environment or the vcpkg-rs helper
//! will not find any libraries. If `VCPKGRS_DYNAMIC` is set, `cargo install` will
//! generate dynamically linked binaries, in which case you will have to arrange for
//! dlls from your Vcpkg installation to be available in your path.
//!
//! The simplest possible usage looks like this :-
//!
//! ```rust,no_run
//! vcpkg::find_package("libssh2").unwrap();
//! ```
//!
//! The cargo metadata that is emitted can be changed like this :-
//!
//! ```rust,no_run
//! vcpkg::Config::new()
//!     .emit_includes(true)
//!     .find_package("zlib").unwrap();
//! ```
//!
//! If the search was successful all appropriate Cargo metadata will be printed
//! to stdout.
//!
//! The decision to choose static variants of libraries is driven by adding
//! `RUSTFLAGS=-Ctarget-feature=+crt-static` to the environment. This requires
//! at least Rust 1.19.
//!
//! A number of environment variables are available to globally configure which
//! libraries are selected.
//!
//! * `VCPKG_ROOT` - Set the directory to look in for a vcpkg installation. If
//! it is not set, vcpkg will use the user-wide installation if one has been
//! set up with `vcpkg integrate install`
//!
//! * `VCPKGRS_NO_FOO` - if set, vcpkg-rs will not attempt to find the
//! library named `foo`.
//!
//! * `VCPKGRS_DISABLE` - if set, vcpkg-rs will not attempt to find any libraries.
//!
//! * `VCPKGRS_DYNAMIC` - if set, vcpkg-rs will link to DLL builds of ports.
//!
//! There is a companion crate `vcpkg_cli` that allows testing of environment
//! and flag combinations.
//!
//! ```Batchfile
//! C:\src> vcpkg_cli probe -l static mysqlclient
//! Found library mysqlclient
//! Include paths:
//!         C:\src\[..]\vcpkg\installed\x64-windows-static\include
//! Library paths:
//!         C:\src\[..]\vcpkg\installed\x64-windows-static\lib
//! Cargo metadata:
//!         cargo:rustc-link-search=native=C:\src\[..]\vcpkg\installed\x64-windows-static\lib
//!         cargo:rustc-link-lib=static=mysqlclient
//! ```

// The CI will test vcpkg-rs on 1.10 because at this point rust-openssl's
// openssl-sys is backward compatible that far. (Actually, the oldest release
// crate openssl version 0.10 seems to build against is now Rust 1.24.1?)
#![allow(deprecated)]

#[cfg(test)]
#[macro_use]
extern crate lazy_static;

#[allow(unused_imports)]
use std::ascii::AsciiExt;

use std::collections::BTreeMap;
use std::env;
use std::error;
use std::ffi::OsStr;
use std::fmt;
use std::fs::{self, File};
use std::io::{BufRead, BufReader};
use std::path::{Path, PathBuf};

#[derive(Default)]
pub struct Config {
    /// should the cargo metadata actually be emitted
    cargo_metadata: bool,

    /// should cargo:include= metadata be emitted (defaults to false)
    emit_includes: bool,

    /// .lib/.a files that must be be found for probing to be considered successful
    required_libs: Vec<String>,

    /// .dlls that must be be found for probing to be considered successful
    required_dlls: Vec<String>,

    /// should DLLs be copies to OUT_DIR?
    copy_dlls: bool,

    /// override VCPKG_ROOT environment variable
    vcpkg_root: Option<PathBuf>,
}

/// Details of a package that was found
#[derive(Debug)]
pub struct Library {
    /// Paths for the linker to search for static or import libraries
    pub link_paths: Vec<PathBuf>,

    /// Paths to search at runtme to find DLLs
    pub dll_paths: Vec<PathBuf>,

    /// Paths to search for
    pub include_paths: Vec<PathBuf>,

    /// cargo: metadata lines
    pub cargo_metadata: Vec<String>,

    /// libraries found are static
    pub is_static: bool,

    /// DLLs found
    pub found_dlls: Vec<PathBuf>,

    /// static libs or import libs found
    pub found_libs: Vec<PathBuf>,

    /// link name of libraries found, this is useful to emit linker commands
    pub found_names: Vec<String>,

    /// ports that are providing the libraries to link to, in port link order
    pub ports: Vec<String>,
}

enum MSVCTarget {
    X86Windows,
    X64Windows,
    X64Linux,
    X64MacOS,
}

impl fmt::Display for MSVCTarget {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            MSVCTarget::X86Windows => write!(f, "x86-windows"),
            MSVCTarget::X64Windows => write!(f, "x64-windows"),
            MSVCTarget::X64Linux => write!(f, "x64-linux"),
            MSVCTarget::X64MacOS => write!(f, "x64-osx"),
        }
    }
}

#[derive(Debug)] // need Display?
pub enum Error {
    /// Aborted because of a `VCPKGRS_NO_*` environment variable.
    ///
    /// Contains the name of the responsible environment variable.
    DisabledByEnv(String),

    /// Aborted because a required environment variable was not set.
    RequiredEnvMissing(String),

    /// On Windows, only MSVC ABI is supported
    NotMSVC,

    /// Can't find a vcpkg tree
    VcpkgNotFound(String),

    /// Library not found in vcpkg tree
    LibNotFound(String),

    /// Could not understand vcpkg installation
    VcpkgInstallation(String),

    #[doc(hidden)]
    __Nonexhaustive,
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match *self {
            Error::DisabledByEnv(_) => "vcpkg-rs requested to be aborted",
            Error::RequiredEnvMissing(_) => "a required env setting is missing",
            Error::NotMSVC => "vcpkg-rs only can only find libraries for MSVC ABI 64 bit builds",
            Error::VcpkgNotFound(_) => "could not find Vcpkg tree",
            Error::LibNotFound(_) => "could not find library in Vcpkg tree",
            Error::VcpkgInstallation(_) => "could not look up details of packages in vcpkg tree",
            Error::__Nonexhaustive => panic!(),
        }
    }

    fn cause(&self) -> Option<&error::Error> {
        match *self {
            // Error::Command { ref cause, .. } => Some(cause),
            _ => None,
        }
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        match *self {
            Error::DisabledByEnv(ref name) => write!(f, "Aborted because {} is set", name),
            Error::RequiredEnvMissing(ref name) => write!(f, "Aborted because {} is not set", name),
            Error::NotMSVC => write!(
                f,
                "the vcpkg-rs Vcpkg build helper can only find libraries built for the MSVC ABI."
            ),
            Error::VcpkgNotFound(ref detail) => write!(f, "Could not find Vcpkg tree: {}", detail),
            Error::LibNotFound(ref detail) => {
                write!(f, "Could not find library in Vcpkg tree {}", detail)
            }
            Error::VcpkgInstallation(ref detail) => write!(
                f,
                "Could not look up details of packages in vcpkg tree {}",
                detail
            ),
            Error::__Nonexhaustive => panic!(),
        }
    }
}

/// Deprecated in favor of the find_package function
#[doc(hidden)]
pub fn probe_package(name: &str) -> Result<Library, Error> {
    Config::new().probe(name)
}

/// Find the package `package` in a Vcpkg tree.
///
/// Emits cargo metadata to link to libraries provided by the Vcpkg package/port
/// named, and any (non-system) libraries that they depend on.
///
/// This will select the architecture and linkage based on environment
/// variables and build flags as described in the module docs.
pub fn find_package(package: &str) -> Result<Library, Error> {
    Config::new().find_package(package)
}

fn find_vcpkg_root(cfg: &Config) -> Result<PathBuf, Error> {
    // prefer the setting from the use if there is one
    if let &Some(ref path) = &cfg.vcpkg_root {
        return Ok(path.clone());
    }

    // otherwise, use the setting from the environment
    if let Some(path) = env::var_os("VCPKG_ROOT") {
        return Ok(PathBuf::from(path));
    }

    // see if there is a per-user vcpkg tree that has been integrated into msbuild
    // using `vcpkg integrate install`
    let local_app_data = try!(env::var("LOCALAPPDATA").map_err(|_| Error::VcpkgNotFound(
        "Failed to read either VCPKG_ROOT or LOCALAPPDATA environment variables".to_string()
    ))); // not present or can't utf8
    let vcpkg_user_targets_path = Path::new(local_app_data.as_str())
        .join("vcpkg")
        .join("vcpkg.user.targets");

    let file = try!(File::open(vcpkg_user_targets_path.clone()).map_err(|_| {
        Error::VcpkgNotFound(
            "No vcpkg.user.targets found. Set the VCPKG_ROOT environment \
             variable or run 'vcpkg integrate install'"
                .to_string(),
        )
    }));
    let file = BufReader::new(&file);

    for line in file.lines() {
        let line = try!(line.map_err(|_| Error::VcpkgNotFound(format!(
            "Parsing of {} failed.",
            vcpkg_user_targets_path.to_string_lossy().to_owned()
        ))));
        let mut split = line.split("Project=\"");
        split.next(); // eat anything before Project="
        if let Some(found) = split.next() {
            // " is illegal in a Windows pathname
            if let Some(found) = found.split_terminator('"').next() {
                let mut vcpkg_root = PathBuf::from(found);
                if !(vcpkg_root.pop() && vcpkg_root.pop() && vcpkg_root.pop() && vcpkg_root.pop()) {
                    return Err(Error::VcpkgNotFound(format!(
                        "Could not find vcpkg root above {}",
                        found
                    )));
                }
                return Ok(vcpkg_root);
            }
        }
    }

    Err(Error::VcpkgNotFound(format!(
        "Project location not found parsing {}.",
        vcpkg_user_targets_path.to_string_lossy().to_owned()
    )))
}

fn validate_vcpkg_root(path: &PathBuf) -> Result<(), Error> {
    let mut vcpkg_root_path = path.clone();
    vcpkg_root_path.push(".vcpkg-root");

    if vcpkg_root_path.exists() {
        Ok(())
    } else {
        Err(Error::VcpkgNotFound(format!(
            "Could not find Vcpkg root at {}",
            vcpkg_root_path.to_string_lossy()
        )))
    }
}

fn find_vcpkg_target(cfg: &Config, msvc_target: &MSVCTarget) -> Result<VcpkgTarget, Error> {
    let vcpkg_root = try!(find_vcpkg_root(&cfg));
    try!(validate_vcpkg_root(&vcpkg_root));

    let (static_lib, static_appendage, lib_suffix, strip_lib_prefix) = match msvc_target {
        &MSVCTarget::X64Windows | &MSVCTarget::X86Windows => {
            let static_lib = env::var("CARGO_CFG_TARGET_FEATURE")
                .unwrap_or(String::new()) // rustc 1.10
                .contains("crt-static");
            let static_appendage = if static_lib { "-static" } else { "" };
            (static_lib, static_appendage, "lib", false)
        }
        _ => (true, "", "a", true),
    };

    let mut base = vcpkg_root;
    base.push("installed");
    let status_path = base.join("vcpkg");

    let vcpkg_triple = format!("{}{}", msvc_target.to_string(), static_appendage);
    base.push(&vcpkg_triple);

    let lib_path = base.join("lib");
    let bin_path = base.join("bin");
    let include_path = base.join("include");

    Ok(VcpkgTarget {
        vcpkg_triple: vcpkg_triple,
        lib_path: lib_path,
        bin_path: bin_path,
        include_path: include_path,
        is_static: static_lib,
        status_path: status_path,
        lib_suffix: lib_suffix.to_owned(),
        strip_lib_prefix: strip_lib_prefix,
    })
}

#[derive(Clone, Debug)]
struct Port {
    // dlls if any
    dlls: Vec<String>,

    // libs (static or import)
    libs: Vec<String>,

    // ports that this port depends on
    deps: Vec<String>,
}

fn load_port_manifest(
    path: &PathBuf,
    port: &str,
    version: &str,
    vcpkg_target: &VcpkgTarget,
) -> Result<(Vec<String>, Vec<String>), Error> {
    let manifest_file = path.join("info").join(format!(
        "{}_{}_{}.list",
        port, version, vcpkg_target.vcpkg_triple
    ));

    let mut dlls = Vec::new();
    let mut libs = Vec::new();

    let f = try!(
        File::open(&manifest_file).map_err(|_| Error::VcpkgInstallation(format!(
            "Could not open port manifest file {}",
            manifest_file.display()
        )))
    );

    let file = BufReader::new(&f);

    let dll_prefix = Path::new(&vcpkg_target.vcpkg_triple).join("bin");
    let lib_prefix = Path::new(&vcpkg_target.vcpkg_triple).join("lib");

    for line in file.lines() {
        let line = line.unwrap();

        let file_path = Path::new(&line);

        if let Ok(dll) = file_path.strip_prefix(&dll_prefix) {
            if dll.extension() == Some(OsStr::new("dll"))
                && dll.components().collect::<Vec<_>>().len() == 1
            {
                // match "mylib.dll" but not "debug/mylib.dll" or "manual_link/mylib.dll"

                dll.to_str().map(|s| dlls.push(s.to_owned()));
            }
        } else if let Ok(lib) = file_path.strip_prefix(&lib_prefix) {
            if lib.extension() == Some(OsStr::new(&vcpkg_target.lib_suffix))
                && lib.components().collect::<Vec<_>>().len() == 1
            {
                if let Some(lib) = vcpkg_target.link_name_for_lib(lib) {
                    libs.push(lib);
                }
            }
        }
    }

    Ok((dlls, libs))
}

// load ports from the status file or one of the incremental updates
fn load_port_file(
    filename: &PathBuf,
    port_info: &mut Vec<BTreeMap<String, String>>,
) -> Result<(), Error> {
    let f = try!(
        File::open(&filename).map_err(|e| Error::VcpkgInstallation(format!(
            "Could not open status file at {}: {}",
            filename.display(),
            e
        )))
    );
    let file = BufReader::new(&f);
    let mut current: BTreeMap<String, String> = BTreeMap::new();
    for line in file.lines() {
        let line = line.unwrap();
        let parts = line.splitn(2, ": ").clone().collect::<Vec<_>>();
        if parts.len() == 2 {
            // a key: value line
            current.insert(parts[0].trim().into(), parts[1].trim().into());
        } else if line.len() == 0 {
            // end of section
            port_info.push(current.clone());
            current.clear();
        } else {
            // ignore all extension lines of the form
            //
            // Description: a package with a
            //   very long description
            //
            // the description key is not used so this is harmless but
            // this will eat extension lines for any multiline key which
            // could become an issue in future
        }
    }

    if !current.is_empty() {
        port_info.push(current);
    }

    Ok(())
}

fn load_ports(target: &VcpkgTarget) -> Result<BTreeMap<String, Port>, Error> {
    let mut ports: BTreeMap<String, Port> = BTreeMap::new();

    let mut port_info: Vec<BTreeMap<String, String>> = Vec::new();

    // load the main status file. It is not an error if this file does not
    // exist. If the only command that has been run in a Vcpkg installation
    // is a single `vcpkg install package` then there will likely be no
    // status file, only incremental updates. This is the typical case when
    // running in a CI environment.
    let status_filename = target.status_path.join("status");
    load_port_file(&status_filename, &mut port_info).ok();

    // load updates to the status file that have yet to be normalized
    let status_update_dir = target.status_path.join("updates");

    let paths = try!(
        fs::read_dir(status_update_dir).map_err(|e| Error::VcpkgInstallation(format!(
            "could not read status file updates dir: {}",
            e
        )))
    );

    // get all of the paths of the update files into a Vec<PathBuf>
    let mut paths = try!(paths
        .map(|rde| rde.map(|de| de.path())) // Result<DirEntry, io::Error> -> Result<PathBuf, io::Error>
        .collect::<Result<Vec<_>, _>>() // collect into Result<Vec<PathBuf>, io::Error>
        .map_err(|e| {
            Error::VcpkgInstallation(format!(
                "could not read status file update filenames: {}",
                e
            ))
        }));

    // Sort the paths and read them. This could be done directly from the iterator if
    // read_dir() guarantees that the files will be read in alpha order but that appears
    // to be unspecified as the underlying operating system calls used are unspecified
    // https://doc.rust-lang.org/nightly/std/fs/fn.read_dir.html#platform-specific-behavior
    paths.sort();
    for path in paths {
        //       println!("Name: {}", path.display());
        try!(load_port_file(&path, &mut port_info));
    }
    //println!("{:#?}", port_info);

    let mut seen_names = BTreeMap::new();
    for current in &port_info {
        // store them by name and arch, clobbering older details
        match (
            current.get("Package"),
            current.get("Architecture"),
            current.get("Feature"),
        ) {
            (Some(pkg), Some(arch), feature) => {
                seen_names.insert((pkg, arch, feature), current);
            }
            _ => {}
        }
    }

    for (&(name, arch, feature), current) in &seen_names {
        if **arch == target.vcpkg_triple {
            let mut deps = if let Some(deps) = current.get("Depends") {
                deps.split(", ").map(|x| x.to_owned()).collect()
            } else {
                Vec::new()
            };

            if current
                .get("Status")
                .unwrap_or(&String::new())
                .ends_with(" installed")
            {
                match (current.get("Version"), feature) {
                    (Some(version), _) => {
                        // this failing here and bailing out causes everything to fail
                        let lib_info = try!(load_port_manifest(
                            &target.status_path,
                            &name,
                            version,
                            &target
                        ));
                        let port = Port {
                            dlls: lib_info.0,
                            libs: lib_info.1,
                            deps: deps,
                        };

                        ports.insert(name.to_string(), port);
                    }
                    (_, Some(_feature)) => match ports.get_mut(name) {
                        Some(ref mut port) => {
                            port.deps.append(&mut deps);
                        }
                        _ => {
                            println!("found a feature that had no corresponding port :-");
                            println!("current {:+?}", current);
                            continue;
                        }
                    },
                    (_, _) => {
                        println!("didn't know how to deal with status file entry :-");
                        println!("{:+?}", current);
                        continue;
                    }
                }
            }
        }
    }

    Ok(ports)
}

/// paths and triple for the chosen target
struct VcpkgTarget {
    vcpkg_triple: String,
    lib_path: PathBuf,
    bin_path: PathBuf,
    include_path: PathBuf,

    // directory containing the status file
    status_path: PathBuf,

    is_static: bool,
    lib_suffix: String,

    /// strip 'lib' from library names in linker args?
    strip_lib_prefix: bool,
}

impl VcpkgTarget {
    fn link_name_for_lib(&self, filename: &std::path::Path) -> Option<String> {
        if self.strip_lib_prefix {
            filename.to_str().map(|s| s.to_owned())
        // filename
        //     .to_str()
        //     .map(|s| s.trim_left_matches("lib").to_owned())
        } else {
            filename.to_str().map(|s| s.to_owned())
        }
    }
}

impl Config {
    pub fn new() -> Config {
        Config {
            cargo_metadata: true,
            copy_dlls: true,
            ..Default::default()
            // emit_includes: false,
            // required_libs: Vec::new(),
        }
    }

    /// Override the name of the library to look for if it differs from the package name.
    ///
    /// This may be called more than once if multiple libs are required.
    /// All libs must be found for the probe to succeed. `.probe()` must
    /// be run with a different configuration to look for libraries under one of several names.
    /// `.libname("ssleay32")` will look for ssleay32.lib and also ssleay32.dll if
    /// dynamic linking is selected.
    pub fn lib_name(&mut self, lib_stem: &str) -> &mut Config {
        self.required_libs.push(lib_stem.to_owned());
        self.required_dlls.push(lib_stem.to_owned());
        self
    }

    /// Override the name of the library to look for if it differs from the package name.
    ///
    /// This may be called more than once if multiple libs are required.
    /// All libs must be found for the probe to succeed. `.probe()` must
    /// be run with a different configuration to look for libraries under one of several names.
    /// `.lib_names("libcurl_imp","curl")` will look for libcurl_imp.lib and also curl.dll if
    /// dynamic linking is selected.
    pub fn lib_names(&mut self, lib_stem: &str, dll_stem: &str) -> &mut Config {
        self.required_libs.push(lib_stem.to_owned());
        self.required_dlls.push(dll_stem.to_owned());
        self
    }

    /// Define whether metadata should be emitted for cargo allowing it to
    /// automatically link the binary. Defaults to `true`.
    pub fn cargo_metadata(&mut self, cargo_metadata: bool) -> &mut Config {
        self.cargo_metadata = cargo_metadata;
        self
    }

    /// Define cargo:include= metadata should be emitted. Defaults to `false`.
    pub fn emit_includes(&mut self, emit_includes: bool) -> &mut Config {
        self.emit_includes = emit_includes;
        self
    }

    /// Should DLLs be copied to OUT_DIR?
    /// Defaults to `true`.
    pub fn copy_dlls(&mut self, copy_dlls: bool) -> &mut Config {
        self.copy_dlls = copy_dlls;
        self
    }

    /// Define which path to use as vcpkg root overriding the VCPKG_ROOT environment variable
    /// Default to `None`, which means use VCPKG_ROOT or try to find out automatically
    pub fn vcpkg_root(&mut self, vcpkg_root: PathBuf) -> &mut Config {
        self.vcpkg_root = Some(vcpkg_root);
        self
    }

    /// Find the library `port_name` in a Vcpkg tree.
    ///
    /// This will use all configuration previously set to select the
    /// architecture and linkage.
    /// Deprecated in favor of the find_package function
    #[doc(hidden)]
    pub fn probe(&mut self, port_name: &str) -> Result<Library, Error> {
        // determine the target type, bailing out if it is not some
        // kind of msvc
        let msvc_target = try!(msvc_target());

        // bail out if requested to not try at all
        if env::var_os("VCPKGRS_DISABLE").is_some() {
            return Err(Error::DisabledByEnv("VCPKGRS_DISABLE".to_owned()));
        }

        // bail out if requested to not try at all (old)
        if env::var_os("NO_VCPKG").is_some() {
            return Err(Error::DisabledByEnv("NO_VCPKG".to_owned()));
        }

        // bail out if requested to skip this package
        let abort_var_name = format!("VCPKGRS_NO_{}", envify(port_name));
        if env::var_os(&abort_var_name).is_some() {
            return Err(Error::DisabledByEnv(abort_var_name));
        }

        // bail out if requested to skip this package (old)
        let abort_var_name = format!("{}_NO_VCPKG", envify(port_name));
        if env::var_os(&abort_var_name).is_some() {
            return Err(Error::DisabledByEnv(abort_var_name));
        }

        // if no overrides have been selected, then the Vcpkg port name
        // is the the .lib name and the .dll name
        if self.required_libs.is_empty() {
            self.required_libs.push(port_name.to_owned());
            self.required_dlls.push(port_name.to_owned());
        }

        let vcpkg_target = try!(find_vcpkg_target(&self, &msvc_target));

        // require explicit opt-in before using dynamically linked
        // variants, otherwise cargo install of various things will
        // stop working if Vcpkg is installed.
        if !vcpkg_target.is_static && !env::var_os("VCPKGRS_DYNAMIC").is_some() {
            return Err(Error::RequiredEnvMissing("VCPKGRS_DYNAMIC".to_owned()));
        }

        let mut lib = Library::new(vcpkg_target.is_static);

        if self.emit_includes {
            lib.cargo_metadata.push(format!(
                "cargo:include={}",
                vcpkg_target.include_path.display()
            ));
        }
        lib.include_paths.push(vcpkg_target.include_path.clone());

        lib.cargo_metadata.push(format!(
            "cargo:rustc-link-search=native={}",
            vcpkg_target
                .lib_path
                .to_str()
                .expect("failed to convert string type")
        ));
        lib.link_paths.push(vcpkg_target.lib_path.clone());
        if !vcpkg_target.is_static {
            lib.cargo_metadata.push(format!(
                "cargo:rustc-link-search=native={}",
                vcpkg_target
                    .bin_path
                    .to_str()
                    .expect("failed to convert string type")
            ));
            // this path is dropped by recent versions of cargo hence the copies to OUT_DIR below
            lib.dll_paths.push(vcpkg_target.bin_path.clone());
        }

        try!(self.emit_libs(&mut lib, &vcpkg_target));

        if self.copy_dlls {
            try!(self.do_dll_copy(&mut lib));
        }

        if self.cargo_metadata {
            for line in &lib.cargo_metadata {
                println!("{}", line);
            }
        }
        Ok(lib)
    }

    fn emit_libs(&mut self, lib: &mut Library, vcpkg_target: &VcpkgTarget) -> Result<(), Error> {
        for required_lib in &self.required_libs {
            // this could use static-nobundle= for static libraries but it is apparently
            // not necessary to make the distinction for windows-msvc.

            let link_name = match vcpkg_target.strip_lib_prefix {
                true => required_lib.trim_left_matches("lib"),
                false => required_lib,
            };

            lib.cargo_metadata
                .push(format!("cargo:rustc-link-lib={}", link_name));

            lib.found_names.push(String::from(link_name));

            // verify that the library exists
            let mut lib_location = vcpkg_target.lib_path.clone();
            lib_location.push(required_lib.clone() + "." + &vcpkg_target.lib_suffix);

            if !lib_location.exists() {
                return Err(Error::LibNotFound(lib_location.display().to_string()));
            }
            lib.found_libs.push(lib_location);
        }

        if !vcpkg_target.is_static {
            for required_dll in &self.required_dlls {
                let mut dll_location = vcpkg_target.bin_path.clone();
                dll_location.push(required_dll.clone() + ".dll");

                // verify that the DLL exists
                if !dll_location.exists() {
                    return Err(Error::LibNotFound(dll_location.display().to_string()));
                }
                lib.found_dlls.push(dll_location);
            }
        }

        Ok(())
    }

    fn do_dll_copy(&mut self, lib: &mut Library) -> Result<(), Error> {
        if let Some(target_dir) = env::var_os("OUT_DIR") {
            if !lib.found_dlls.is_empty() {
                for file in &lib.found_dlls {
                    let mut dest_path = Path::new(target_dir.as_os_str()).to_path_buf();
                    dest_path.push(Path::new(file.file_name().unwrap()));
                    try!(
                        fs::copy(file, &dest_path).map_err(|_| Error::LibNotFound(format!(
                            "Can't copy file {} to {}",
                            file.to_string_lossy(),
                            dest_path.to_string_lossy()
                        )))
                    );
                    println!(
                        "vcpkg build helper copied {} to {}",
                        file.to_string_lossy(),
                        dest_path.to_string_lossy()
                    );
                }
                lib.cargo_metadata.push(format!(
                    "cargo:rustc-link-search=native={}",
                    env::var("OUT_DIR").unwrap()
                ));
                // work around https://github.com/rust-lang/cargo/issues/3957
                lib.cargo_metadata.push(format!(
                    "cargo:rustc-link-search={}",
                    env::var("OUT_DIR").unwrap()
                ));
            }
        } else {
            return Err(Error::LibNotFound("Unable to get OUT_DIR".to_owned()));
        }
        Ok(())
    }

    /// Find the package `port_name` in a Vcpkg tree.
    ///
    /// Emits cargo metadata to link to libraries provided by the Vcpkg package/port
    /// named, and any (non-system) libraries that they depend on.
    ///
    /// This will select the architecture and linkage based on environment
    /// variables and build flags as described in the module docs, and any configuration
    /// set on the builder.
    pub fn find_package(&mut self, port_name: &str) -> Result<Library, Error> {
        // determine the target type, bailing out if it is not some
        // kind of msvc
        let msvc_target = try!(msvc_target());

        // bail out if requested to not try at all
        if env::var_os("VCPKGRS_DISABLE").is_some() {
            return Err(Error::DisabledByEnv("VCPKGRS_DISABLE".to_owned()));
        }

        // bail out if requested to not try at all (old)
        if env::var_os("NO_VCPKG").is_some() {
            return Err(Error::DisabledByEnv("NO_VCPKG".to_owned()));
        }

        // bail out if requested to skip this package
        let abort_var_name = format!("VCPKGRS_NO_{}", envify(port_name));
        if env::var_os(&abort_var_name).is_some() {
            return Err(Error::DisabledByEnv(abort_var_name));
        }

        // bail out if requested to skip this package (old)
        let abort_var_name = format!("{}_NO_VCPKG", envify(port_name));
        if env::var_os(&abort_var_name).is_some() {
            return Err(Error::DisabledByEnv(abort_var_name));
        }

        let vcpkg_target = try!(find_vcpkg_target(&self, &msvc_target));
        let mut required_port_order = Vec::new();

        // if no overrides have been selected, then the Vcpkg port name
        // is the the .lib name and the .dll name
        if self.required_libs.is_empty() {
            let ports = try!(load_ports(&vcpkg_target));

            if ports.get(&port_name.to_owned()).is_none() {
                return Err(Error::LibNotFound(port_name.to_owned()));
            }

            // the complete set of ports required
            let mut required_ports: BTreeMap<String, Port> = BTreeMap::new();
            // working of ports that we need to include
            //        let mut ports_to_scan: BTreeSet<String> = BTreeSet::new();
            //        ports_to_scan.insert(port_name.to_owned());
            let mut ports_to_scan = vec![port_name.to_owned()]; //: Vec<String> = BTreeSet::new();

            while !ports_to_scan.is_empty() {
                let port_name = ports_to_scan.pop().unwrap();

                if required_ports.contains_key(&port_name) {
                    continue;
                }

                if let Some(port) = ports.get(&port_name) {
                    for dep in &port.deps {
                        ports_to_scan.push(dep.clone());
                    }
                    required_ports.insert(port_name.clone(), (*port).clone());
                    remove_item(&mut required_port_order, &port_name);
                    required_port_order.push(port_name);
                } else {
                    // what?
                }
            }

            // for port in ports {
            //     println!("port {:?}", port);
            // }
            // println!("== Looking for port {}", port_name);
            // for port in &required_port_order {
            //     println!("ordered required port {:?}", port);
            // }
            // println!("=============================");
            // for port in &required_ports {
            //     println!("required port {:?}", port);
            // }

            // if no overrides have been selected, then the Vcpkg port name
            // is the the .lib name and the .dll name
            if self.required_libs.is_empty() {
                for port_name in &required_port_order {
                    let port = required_ports.get(port_name).unwrap();
                    self.required_libs.extend(port.libs.iter().map(|s| {
                        Path::new(&s)
                            .file_stem()
                            .unwrap()
                            .to_string_lossy()
                            .into_owned()
                    }));
                    self.required_dlls
                        .extend(port.dlls.iter().cloned().map(|s| {
                            Path::new(&s)
                                .file_stem()
                                .unwrap()
                                .to_string_lossy()
                                .into_owned()
                        }));
                }
            }
        }
        // require explicit opt-in before using dynamically linked
        // variants, otherwise cargo install of various things will
        // stop working if Vcpkg is installed.
        if !vcpkg_target.is_static && !env::var_os("VCPKGRS_DYNAMIC").is_some() {
            return Err(Error::RequiredEnvMissing("VCPKGRS_DYNAMIC".to_owned()));
        }

        let mut lib = Library::new(vcpkg_target.is_static);

        if self.emit_includes {
            lib.cargo_metadata.push(format!(
                "cargo:include={}",
                vcpkg_target.include_path.display()
            ));
        }
        lib.include_paths.push(vcpkg_target.include_path.clone());

        lib.cargo_metadata.push(format!(
            "cargo:rustc-link-search=native={}",
            vcpkg_target
                .lib_path
                .to_str()
                .expect("failed to convert string type")
        ));
        lib.link_paths.push(vcpkg_target.lib_path.clone());
        if !vcpkg_target.is_static {
            lib.cargo_metadata.push(format!(
                "cargo:rustc-link-search=native={}",
                vcpkg_target
                    .bin_path
                    .to_str()
                    .expect("failed to convert string type")
            ));
            // this path is dropped by recent versions of cargo hence the copies to OUT_DIR below
            lib.dll_paths.push(vcpkg_target.bin_path.clone());
        }

        lib.ports = required_port_order;

        try!(self.emit_libs(&mut lib, &vcpkg_target));

        if self.copy_dlls {
            try!(self.do_dll_copy(&mut lib));
        }

        if self.cargo_metadata {
            for line in &lib.cargo_metadata {
                println!("{}", line);
            }
        }
        Ok(lib)
    }
}

fn remove_item(cont: &mut Vec<String>, item: &String) -> Option<String> {
    match cont.iter().position(|x| *x == *item) {
        Some(pos) => Some(cont.remove(pos)),
        None => None,
    }
}

impl Library {
    fn new(is_static: bool) -> Library {
        Library {
            link_paths: Vec::new(),
            dll_paths: Vec::new(),
            include_paths: Vec::new(),
            cargo_metadata: Vec::new(),
            is_static: is_static,
            found_dlls: Vec::new(),
            found_libs: Vec::new(),
            found_names: Vec::new(),
            ports: Vec::new(),
        }
    }
}

fn envify(name: &str) -> String {
    name.chars()
        .map(|c| c.to_ascii_uppercase())
        .map(|c| if c == '-' { '_' } else { c })
        .collect()
}

fn msvc_target() -> Result<MSVCTarget, Error> {
    let target = env::var("TARGET").unwrap_or(String::new());
    if target == "x86_64-apple-darwin" {
        Ok(MSVCTarget::X64MacOS)
    } else if target == "x86_64-unknown-linux-gnu" {
        Ok(MSVCTarget::X64Linux)
    } else if !target.contains("-pc-windows-msvc") {
        Err(Error::NotMSVC)
    } else if target.starts_with("x86_64-") {
        Ok(MSVCTarget::X64Windows)
    } else {
        // everything else is x86
        Ok(MSVCTarget::X86Windows)
    }
}

#[cfg(test)]
mod tests {

    extern crate tempdir;

    use super::*;
    use std::env;
    use std::sync::Mutex;

    lazy_static! {
        static ref LOCK: Mutex<()> = Mutex::new(());
    }

    #[test]
    fn do_nothing_for_unsupported_target() {
        let _g = LOCK.lock();
        env::set_var("VCPKG_ROOT", "/");
        env::set_var("TARGET", "x86_64-pc-windows-gnu");
        assert!(match ::probe_package("foo") {
            Err(Error::NotMSVC) => true,
            _ => false,
        });

        env::set_var("TARGET", "x86_64-pc-windows-gnu");
        assert_eq!(env::var("TARGET"), Ok("x86_64-pc-windows-gnu".to_string()));
        assert!(match ::probe_package("foo") {
            Err(Error::NotMSVC) => true,
            _ => false,
        });
        env::remove_var("TARGET");
        env::remove_var("VCPKG_ROOT");
    }

    #[test]
    fn do_nothing_for_bailout_variables_set() {
        let _g = LOCK.lock();
        env::set_var("VCPKG_ROOT", "/");
        env::set_var("TARGET", "x86_64-pc-windows-msvc");

        for &var in &[
            "VCPKGRS_DISABLE",
            "VCPKGRS_NO_FOO",
            "FOO_NO_VCPKG",
            "NO_VCPKG",
        ] {
            env::set_var(var, "1");
            assert!(match ::probe_package("foo") {
                Err(Error::DisabledByEnv(ref v)) if v == var => true,
                _ => false,
            });
            env::remove_var(var);
        }
        env::remove_var("TARGET");
        env::remove_var("VCPKG_ROOT");
    }

    // these tests are good but are leaning on a real vcpkg installation

    #[test]
    fn default_build_refuses_dynamic() {
        let _g = LOCK.lock();
        clean_env();
        env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("no-status"));
        env::set_var("TARGET", "x86_64-pc-windows-msvc");
        println!("Result is {:?}", ::find_package("libmysql"));
        assert!(match ::find_package("libmysql") {
            Err(Error::RequiredEnvMissing(ref v)) if v == "VCPKGRS_DYNAMIC" => true,
            _ => false,
        });
        clean_env();
    }

    #[test]
    fn static_build_finds_lib() {
        let _g = LOCK.lock();
        clean_env();
        env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("normalized"));
        env::set_var("TARGET", "x86_64-pc-windows-msvc");
        let tmp_dir = tempdir::TempDir::new("vcpkg_tests").unwrap();
        env::set_var("OUT_DIR", tmp_dir.path());

        // CARGO_CFG_TARGET_FEATURE is set in response to
        // RUSTFLAGS=-Ctarget-feature=+crt-static. It would
        //  be nice to test that also.
        env::set_var("CARGO_CFG_TARGET_FEATURE", "crt-static");
        println!("Result is {:?}", ::find_package("libmysql"));
        assert!(match ::find_package("libmysql") {
            Ok(_) => true,
            _ => false,
        });
        clean_env();
    }

    #[test]
    fn dynamic_build_finds_lib() {
        let _g = LOCK.lock();
        clean_env();
        env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("no-status"));
        env::set_var("TARGET", "x86_64-pc-windows-msvc");
        env::set_var("VCPKGRS_DYNAMIC", "1");
        let tmp_dir = tempdir::TempDir::new("vcpkg_tests").unwrap();
        env::set_var("OUT_DIR", tmp_dir.path());

        println!("Result is {:?}", ::find_package("libmysql"));
        assert!(match ::find_package("libmysql") {
            Ok(_) => true,
            _ => false,
        });
        clean_env();
    }

    #[test]
    fn handle_multiline_description() {
        let _g = LOCK.lock();
        clean_env();
        env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("multiline-description"));
        env::set_var("TARGET", "i686-pc-windows-msvc");
        env::set_var("VCPKGRS_DYNAMIC", "1");
        let tmp_dir = tempdir::TempDir::new("vcpkg_tests").unwrap();
        env::set_var("OUT_DIR", tmp_dir.path());

        println!("Result is {:?}", ::find_package("graphite2"));
        assert!(match ::find_package("graphite2") {
            Ok(_) => true,
            _ => false,
        });
        clean_env();
    }

    #[test]
    fn link_libs_required_by_optional_features() {
        let _g = LOCK.lock();
        clean_env();
        env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("normalized"));
        env::set_var("TARGET", "i686-pc-windows-msvc");
        env::set_var("VCPKGRS_DYNAMIC", "1");
        let tmp_dir = tempdir::TempDir::new("vcpkg_tests").unwrap();
        env::set_var("OUT_DIR", tmp_dir.path());

        println!("Result is {:?}", ::find_package("harfbuzz"));
        assert!(match ::find_package("harfbuzz") {
            Ok(lib) => lib
                .cargo_metadata
                .iter()
                .find(|&x| x == "cargo:rustc-link-lib=icuuc")
                .is_some(),
            _ => false,
        });
        clean_env();
    }

    #[test]
    fn link_lib_name_is_correct() {
        let _g = LOCK.lock();

        for target in &[
            "x86_64-apple-darwin",
            "i686-pc-windows-msvc",
            //      "x86_64-pc-windows-msvc",
            //    "x86_64-unknown-linux-gnu",
        ] {
            clean_env();
            env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("normalized"));
            env::set_var("TARGET", target);
            env::set_var("VCPKGRS_DYNAMIC", "1");
            let tmp_dir = tempdir::TempDir::new("vcpkg_tests").unwrap();
            env::set_var("OUT_DIR", tmp_dir.path());

            println!("Result is {:?}", ::find_package("harfbuzz"));
            assert!(match ::find_package("harfbuzz") {
                Ok(lib) => lib
                    .cargo_metadata
                    .iter()
                    .find(|&x| x == "cargo:rustc-link-lib=harfbuzz")
                    .is_some(),
                _ => false,
            });
            clean_env();
        }
    }

    #[test]
    fn link_dependencies_after_port() {
        let _g = LOCK.lock();
        clean_env();
        env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("normalized"));
        env::set_var("TARGET", "i686-pc-windows-msvc");
        env::set_var("VCPKGRS_DYNAMIC", "1");
        let tmp_dir = tempdir::TempDir::new("vcpkg_tests").unwrap();
        env::set_var("OUT_DIR", tmp_dir.path());

        let lib = ::find_package("harfbuzz").unwrap();

        check_before(&lib, "freetype", "zlib");
        check_before(&lib, "freetype", "bzip2");
        check_before(&lib, "freetype", "libpng");
        check_before(&lib, "harfbuzz", "freetype");
        check_before(&lib, "harfbuzz", "ragel");
        check_before(&lib, "libpng", "zlib");

        clean_env();

        fn check_before(lib: &Library, earlier: &str, later: &str) {
            match (
                lib.ports.iter().position(|x| *x == *earlier),
                lib.ports.iter().position(|x| *x == *later),
            ) {
                (Some(earlier_pos), Some(later_pos)) if earlier_pos < later_pos => {
                    // ok
                }
                _ => {
                    println!(
                        "earlier: {}, later: {}\nLibrary found: {:#?}",
                        earlier, later, lib
                    );
                    panic!();
                }
            }
        }
    }
    // #[test]
    // fn dynamic_build_package_specific_bailout() {
    //     clean_env();
    //     env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("no-status"));
    //     env::set_var("TARGET", "x86_64-pc-windows-msvc");
    //     env::set_var("VCPKGRS_DYNAMIC", "1");
    //     env::set_var("VCPKGRS_NO_LIBMYSQL", "1");

    //     println!("Result is {:?}", ::find_package("libmysql"));
    //     assert!(match ::find_package("libmysql") {
    //         Err(Error::DisabledByEnv(ref v)) if v == "VCPKGRS_NO_LIBMYSQL" => true,
    //         _ => false,
    //     });
    //     clean_env();
    // }

    // #[test]
    // fn dynamic_build_global_bailout() {
    //     clean_env();
    //     env::set_var("VCPKG_ROOT", vcpkg_test_tree_loc("no-status"));
    //     env::set_var("TARGET", "x86_64-pc-windows-msvc");
    //     env::set_var("VCPKGRS_DYNAMIC", "1");
    //     env::set_var("VCPKGRS_DISABLE", "1");

    //     println!("Result is {:?}", ::find_package("libmysql"));
    //     assert!(match ::find_package("libmysql") {
    //         Err(Error::DisabledByEnv(ref v)) if v == "VCPKGRS_DISABLE" => true,
    //         _ => false,
    //     });
    //     clean_env();
    // }

    fn clean_env() {
        env::remove_var("TARGET");
        env::remove_var("VCPKG_ROOT");
        env::remove_var("VCPKGRS_DYNAMIC");
        env::remove_var("RUSTFLAGS");
        env::remove_var("CARGO_CFG_TARGET_FEATURE");
        env::remove_var("VCPKGRS_DISABLE");
        env::remove_var("VCPKGRS_NO_LIBMYSQL");
    }

    // path to a to vcpkg installation to test against
    fn vcpkg_test_tree_loc(name: &str) -> PathBuf {
        let mut path = PathBuf::new();
        path.push(env::var("CARGO_MANIFEST_DIR").unwrap());
        path.pop();
        path.push("test-data");
        path.push(name);
        path
    }
}
