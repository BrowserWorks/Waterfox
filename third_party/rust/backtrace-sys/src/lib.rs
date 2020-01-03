#![allow(bad_style)]
#![no_std]

extern crate libc;

#[cfg(not(empty))]
pub use self::bindings::*;
#[cfg(not(empty))]
mod bindings {
    use libc::{c_char, c_int, c_void, uintptr_t};

    pub type backtrace_syminfo_callback = extern "C" fn(
        data: *mut c_void,
        pc: uintptr_t,
        symname: *const c_char,
        symval: uintptr_t,
        symsize: uintptr_t,
    );
    pub type backtrace_full_callback = extern "C" fn(
        data: *mut c_void,
        pc: uintptr_t,
        filename: *const c_char,
        lineno: c_int,
        function: *const c_char,
    ) -> c_int;
    pub type backtrace_error_callback =
        extern "C" fn(data: *mut c_void, msg: *const c_char, errnum: c_int);
    pub enum backtrace_state {}

    extern "C" {
        #[cfg_attr(rdos, link_name = "__rdos_backtrace_create_state")]
        #[cfg_attr(rbt, link_name = "__rbt_backtrace_create_state")]
        pub fn backtrace_create_state(
            filename: *const c_char,
            threaded: c_int,
            error: backtrace_error_callback,
            data: *mut c_void,
        ) -> *mut backtrace_state;
        #[cfg_attr(rdos, link_name = "__rdos_backtrace_syminfo")]
        #[cfg_attr(rbt, link_name = "__rbt_backtrace_syminfo")]
        pub fn backtrace_syminfo(
            state: *mut backtrace_state,
            addr: uintptr_t,
            cb: backtrace_syminfo_callback,
            error: backtrace_error_callback,
            data: *mut c_void,
        ) -> c_int;
        #[cfg_attr(rdos, link_name = "__rdos_backtrace_pcinfo")]
        #[cfg_attr(rbt, link_name = "__rbt_backtrace_pcinfo")]
        pub fn backtrace_pcinfo(
            state: *mut backtrace_state,
            addr: uintptr_t,
            cb: backtrace_full_callback,
            error: backtrace_error_callback,
            data: *mut c_void,
        ) -> c_int;
    }
}
