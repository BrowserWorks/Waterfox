#![feature(const_raw_ptr_to_usize_cast)]
#![cfg_attr(feature = "rustc-dep-of-std", no_std)]
extern crate libc;

use libc::c_void;

extern "C" {
	fn _start();
	fn sys_get_processor_count() -> usize;
	fn sys_malloc(size: usize, align: usize) -> *mut u8;
	fn sys_realloc(ptr: *mut u8, size: usize, align: usize, new_size: usize) -> *mut u8;
	fn sys_free(ptr: *mut u8, size: usize, align: usize);
	fn sys_notify(id: usize, count: i32) -> i32;
	fn sys_add_queue(id: usize, timeout_ns: i64) -> i32;
	fn sys_wait(id: usize) -> i32;
	fn sys_destroy_queue(id: usize) -> i32;
	fn sys_read(fd: i32, buf: *mut u8, len: usize) -> isize;
	fn sys_write(fd: i32, buf: *const u8, len: usize) -> isize;
	fn sys_close(fd: i32) -> i32;
	fn sys_sem_init(sem: *mut *const c_void, value: u32) -> i32;
	fn sys_sem_destroy(sem: *const c_void) -> i32;
	fn sys_sem_post(sem: *const c_void) -> i32;
	fn sys_sem_trywait(sem: *const c_void) -> i32;
	fn sys_sem_timedwait(sem: *const c_void, ms: u32) -> i32;
	fn sys_recmutex_init(recmutex: *mut *const c_void) -> i32;
	fn sys_recmutex_destroy(recmutex: *const c_void) -> i32;
	fn sys_recmutex_lock(recmutex: *const c_void) -> i32;
	fn sys_recmutex_unlock(recmutex: *const c_void) -> i32;
	fn sys_getpid() -> u32;
	fn sys_exit(arg: i32) -> !;
	fn sys_abort() -> !;
	fn sys_usleep(usecs: u64);
	fn sys_spawn(
		id: *mut Tid,
		func: extern "C" fn(usize),
		arg: usize,
		prio: u8,
		core_id: isize,
	) -> i32;
	fn sys_join(id: Tid) -> i32;
	fn sys_yield();
	fn sys_clock_gettime(clock_id: u64, tp: *mut timespec) -> i32;
	fn sys_open(name: *const i8, flags: i32, mode: i32) -> i32;
	fn sys_unlink(name: *const i8) -> i32;
}

pub type Tid = u32;

pub const NSEC_PER_SEC: u64 = 1_000_000_000;
pub const CLOCK_REALTIME: u64 = 1;
pub const CLOCK_MONOTONIC: u64 = 4;

#[derive(Copy, Clone, Debug)]
#[repr(C)]
pub struct timespec {
	pub tv_sec: i64,
	pub tv_nsec: i64,
}

pub unsafe fn call_start() {
	_start();
}

#[inline(always)]
pub unsafe fn get_processor_count() -> usize {
	sys_get_processor_count()
}

#[inline(always)]
pub unsafe fn malloc(size: usize, align: usize) -> *mut u8 {
	sys_malloc(size, align)
}

#[inline(always)]
pub unsafe fn realloc(ptr: *mut u8, size: usize, align: usize, new_size: usize) -> *mut u8 {
	sys_realloc(ptr, size, align, new_size)
}

#[inline(always)]
pub unsafe fn free(ptr: *mut u8, size: usize, align: usize) {
	sys_free(ptr, size, align)
}

#[inline(always)]
pub unsafe fn notify(id: usize, count: i32) -> i32 {
	sys_notify(id, count)
}

#[inline(always)]
pub unsafe fn add_queue(id: usize, timeout_ns: i64) -> i32 {
	sys_add_queue(id, timeout_ns)
}

#[inline(always)]
pub unsafe fn wait(id: usize) -> i32 {
	sys_wait(id)
}

#[inline(always)]
pub unsafe fn destroy_queue(id: usize) -> i32 {
	sys_destroy_queue(id)
}

#[inline(always)]
pub unsafe fn read(fd: i32, buf: *mut u8, len: usize) -> isize {
	sys_read(fd, buf, len)
}

#[inline(always)]
pub unsafe fn write(fd: i32, buf: *const u8, len: usize) -> isize {
	sys_write(fd, buf, len)
}

#[inline(always)]
pub unsafe fn close(fd: i32) -> i32 {
	sys_close(fd)
}

#[inline(always)]
pub unsafe fn sem_init(sem: *mut *const c_void, value: u32) -> i32 {
	sys_sem_init(sem, value)
}

#[inline(always)]
pub unsafe fn sem_destroy(sem: *const c_void) -> i32 {
	sys_sem_destroy(sem)
}

#[inline(always)]
pub unsafe fn sem_post(sem: *const c_void) -> i32 {
	sys_sem_post(sem)
}

#[inline(always)]
pub unsafe fn sem_trywait(sem: *const c_void) -> i32 {
	sys_sem_trywait(sem)
}

#[inline(always)]
pub unsafe fn sem_timedwait(sem: *const c_void, ms: u32) -> i32 {
	sys_sem_timedwait(sem, ms)
}

#[inline(always)]
pub unsafe fn recmutex_init(recmutex: *mut *const c_void) -> i32 {
	sys_recmutex_init(recmutex)
}

#[inline(always)]
pub unsafe fn recmutex_destroy(recmutex: *const c_void) -> i32 {
	sys_recmutex_destroy(recmutex)
}

#[inline(always)]
pub unsafe fn recmutex_lock(recmutex: *const c_void) -> i32 {
	sys_recmutex_lock(recmutex)
}

#[inline(always)]
pub unsafe fn recmutex_unlock(recmutex: *const c_void) -> i32 {
	sys_recmutex_unlock(recmutex)
}

#[inline(always)]
pub unsafe fn getpid() -> u32 {
	sys_getpid()
}

#[inline(always)]
pub unsafe fn exit(arg: i32) -> ! {
	sys_exit(arg)
}

#[inline(always)]
pub unsafe fn abort() -> ! {
	sys_abort()
}

#[inline(always)]
pub unsafe fn usleep(usecs: u64) {
	sys_usleep(usecs)
}

#[inline(always)]
pub unsafe fn spawn(
	id: *mut Tid,
	func: extern "C" fn(usize),
	arg: usize,
	prio: u8,
	core_id: isize,
) -> i32 {
	sys_spawn(id, func, arg, prio, core_id)
}

#[inline(always)]
pub unsafe fn join(id: Tid) -> i32 {
	sys_join(id)
}

#[inline(always)]
pub unsafe fn yield_now() {
	sys_yield()
}

#[inline(always)]
pub unsafe fn clock_gettime(clock_id: u64, tp: *mut timespec) -> i32 {
	sys_clock_gettime(clock_id, tp)
}

#[inline(always)]
pub unsafe fn open(name: *const i8, flags: i32, mode: i32) -> i32 {
	sys_open(name, flags, mode)
}

#[inline(always)]
pub unsafe fn unlink(name: *const i8) -> i32 {
	sys_unlink(name)
}
