//! This crate provides the following three functions:
//!
//! ```rust
//! # trait Ignore {
//! fn stdin_isatty() -> bool
//! # ;
//! fn stdout_isatty() -> bool
//! # ;
//! fn stderr_isatty() -> bool
//! # ;
//! # }
//! ```
//!
//! On Linux and Mac they are implemented with [`libc::isatty`]. On Windows they
//! are implemented with [`consoleapi::GetConsoleMode`]. On Redox they are
//! implemented with [`termion::is_tty`].
//!
//! [`libc::isatty`]: http://man7.org/linux/man-pages/man3/isatty.3.html
//! [`consoleapi::GetConsoleMode`]: https://msdn.microsoft.com/en-us/library/windows/desktop/ms683167.aspx
//! [`termion::is_tty`]: https://docs.rs/termion/1.5.1/termion/fn.is_tty.html
//!
//! The `stdin_isatty` function is not yet implemented for Windows. If you need
//! it, please check [dtolnay/isatty#1] and contribute an implementation!
//!
//! [dtolnay/isatty#1]: https://github.com/dtolnay/isatty/issues/1
//!
//! ## Usage
//!
//! `Cargo.toml`
//!
//! > ```toml
//! > [dependencies]
//! > isatty = "0.1"
//! > ```
//!
//! `src/main.rs`
//!
//! > ```rust
//! > extern crate isatty;
//! > use isatty::{stdin_isatty, stdout_isatty, stderr_isatty};
//! >
//! > fn main() {
//! >     println!("stdin: {}", stdin_isatty());
//! >     println!("stdout: {}", stdout_isatty());
//! >     println!("stderr: {}", stderr_isatty());
//! > }
//! > ```

#![doc(html_root_url = "https://docs.rs/isatty/0.1.9")]

#[macro_use]
extern crate cfg_if;

// Based on:
//  - https://github.com/rust-lang/cargo/blob/099ad28104fe319f493dc42e0c694d468c65767d/src/cargo/lib.rs#L154-L178
//  - https://github.com/BurntSushi/ripgrep/issues/94#issuecomment-261761687

#[cfg(not(windows))]
pub fn stdin_isatty() -> bool {
    isatty(Stream::Stdin)
}

pub fn stdout_isatty() -> bool {
    isatty(Stream::Stdout)
}

pub fn stderr_isatty() -> bool {
    isatty(Stream::Stderr)
}

enum Stream {
    #[cfg(not(windows))]
    Stdin,
    Stdout,
    Stderr,
}

cfg_if! {
    if #[cfg(unix)] {
        fn isatty(stream: Stream) -> bool {
            extern crate libc;

            let fd = match stream {
                Stream::Stdin => libc::STDIN_FILENO,
                Stream::Stdout => libc::STDOUT_FILENO,
                Stream::Stderr => libc::STDERR_FILENO,
            };

            unsafe { libc::isatty(fd) != 0 }
        }
    } else if #[cfg(windows)] {
        extern crate winapi;

        fn isatty(stream: Stream) -> bool {
            let handle = match stream {
                Stream::Stdout => winapi::um::winbase::STD_OUTPUT_HANDLE,
                Stream::Stderr => winapi::um::winbase::STD_ERROR_HANDLE,
            };

            unsafe {
                let handle = winapi::um::processenv::GetStdHandle(handle);

                // check for msys/cygwin
                if is_cygwin_pty(handle) {
                    return true;
                }

                let mut out = 0;
                winapi::um::consoleapi::GetConsoleMode(handle, &mut out) != 0
            }
        }

        /// Returns true if there is an MSYS/cygwin tty on the given handle.
        fn is_cygwin_pty(handle: winapi::um::winnt::HANDLE) -> bool {
            use std::ffi::OsString;
            use std::mem;
            use std::os::windows::ffi::OsStringExt;
            use std::slice;

            use self::winapi::um::winbase::GetFileInformationByHandleEx;
            use self::winapi::um::fileapi::FILE_NAME_INFO;
            use self::winapi::um::minwinbase::FileNameInfo;
            use self::winapi::shared::minwindef::MAX_PATH;
            use self::winapi::shared::minwindef::LPVOID;

            unsafe {
                let size = mem::size_of::<FILE_NAME_INFO>();
                let mut name_info_bytes = vec![0u8; size + MAX_PATH];
                let res = GetFileInformationByHandleEx(handle,
                                                    FileNameInfo,
                                                    &mut *name_info_bytes as *mut _ as LPVOID,
                                                    name_info_bytes.len() as u32);
                if res == 0 {
                    return true;
                }
                let name_info: FILE_NAME_INFO = *(name_info_bytes[0..size]
                    .as_ptr() as *const FILE_NAME_INFO);
                let name_bytes = &name_info_bytes[size..size + name_info.FileNameLength as usize];
                let name_u16 = slice::from_raw_parts(name_bytes.as_ptr() as *const u16,
                                                    name_bytes.len() / 2);
                let name = OsString::from_wide(name_u16)
                    .as_os_str()
                    .to_string_lossy()
                    .into_owned();
                name.contains("msys-") || name.contains("-pty")
            }
        }
    } else if #[cfg(target_os = "redox")] {
        fn isatty(stream: Stream) -> bool {
            extern crate syscall;
            use std::io;
            use std::os::unix::io::AsRawFd;

            let raw_fd = match stream {
                Stream::Stdin => io::stdin().as_raw_fd(),
                Stream::Stdout => io::stdout().as_raw_fd(),
                Stream::Stderr => io::stderr().as_raw_fd(),
            };

            if let Ok(fd) = syscall::dup(raw_fd, b"termios") {
                let _ = syscall::close(fd);
                true
            } else {
                false
            }
        }
    } else {
        fn isatty(_: Stream) -> bool {
            false
        }
    }
}
