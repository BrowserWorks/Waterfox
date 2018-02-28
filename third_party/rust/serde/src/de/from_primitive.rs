// Copyright 2017 Serde Developers
//
// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

use lib::*;

macro_rules! int_to_int {
    ($dst:ident, $n:ident) => (
        if $dst::MIN as i64 <= $n as i64 && $n as i64 <= $dst::MAX as i64 {
            Some($n as $dst)
        } else {
            None
        }
    )
}

macro_rules! int_to_uint {
    ($dst:ident, $n:ident) => (
        if 0 <= $n && $n as u64 <= $dst::MAX as u64 {
            Some($n as $dst)
        } else {
            None
        }
    )
}

macro_rules! uint_to {
    ($dst:ident, $n:ident) => (
        if $n as u64 <= $dst::MAX as u64 {
            Some($n as $dst)
        } else {
            None
        }
    )
}

pub trait FromPrimitive: Sized {
    fn from_isize(n: isize) -> Option<Self>;
    fn from_i8(n: i8) -> Option<Self>;
    fn from_i16(n: i16) -> Option<Self>;
    fn from_i32(n: i32) -> Option<Self>;
    fn from_i64(n: i64) -> Option<Self>;
    fn from_usize(n: usize) -> Option<Self>;
    fn from_u8(n: u8) -> Option<Self>;
    fn from_u16(n: u16) -> Option<Self>;
    fn from_u32(n: u32) -> Option<Self>;
    fn from_u64(n: u64) -> Option<Self>;
}

macro_rules! impl_from_primitive_for_int {
    ($t:ident) => (
        impl FromPrimitive for $t {
            #[inline] fn from_isize(n: isize) -> Option<Self> { int_to_int!($t, n) }
            #[inline] fn from_i8(n: i8) -> Option<Self> { int_to_int!($t, n) }
            #[inline] fn from_i16(n: i16) -> Option<Self> { int_to_int!($t, n) }
            #[inline] fn from_i32(n: i32) -> Option<Self> { int_to_int!($t, n) }
            #[inline] fn from_i64(n: i64) -> Option<Self> { int_to_int!($t, n) }
            #[inline] fn from_usize(n: usize) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u8(n: u8) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u16(n: u16) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u32(n: u32) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u64(n: u64) -> Option<Self> { uint_to!($t, n) }
        }
    )
}

macro_rules! impl_from_primitive_for_uint {
    ($t:ident) => (
        impl FromPrimitive for $t {
            #[inline] fn from_isize(n: isize) -> Option<Self> { int_to_uint!($t, n) }
            #[inline] fn from_i8(n: i8) -> Option<Self> { int_to_uint!($t, n) }
            #[inline] fn from_i16(n: i16) -> Option<Self> { int_to_uint!($t, n) }
            #[inline] fn from_i32(n: i32) -> Option<Self> { int_to_uint!($t, n) }
            #[inline] fn from_i64(n: i64) -> Option<Self> { int_to_uint!($t, n) }
            #[inline] fn from_usize(n: usize) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u8(n: u8) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u16(n: u16) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u32(n: u32) -> Option<Self> { uint_to!($t, n) }
            #[inline] fn from_u64(n: u64) -> Option<Self> { uint_to!($t, n) }
        }
    )
}

macro_rules! impl_from_primitive_for_float {
    ($t:ident) => (
        impl FromPrimitive for $t {
            #[inline] fn from_isize(n: isize) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_i8(n: i8) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_i16(n: i16) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_i32(n: i32) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_i64(n: i64) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_usize(n: usize) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_u8(n: u8) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_u16(n: u16) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_u32(n: u32) -> Option<Self> { Some(n as Self) }
            #[inline] fn from_u64(n: u64) -> Option<Self> { Some(n as Self) }
        }
    )
}

impl_from_primitive_for_int!(isize);
impl_from_primitive_for_int!(i8);
impl_from_primitive_for_int!(i16);
impl_from_primitive_for_int!(i32);
impl_from_primitive_for_int!(i64);
impl_from_primitive_for_uint!(usize);
impl_from_primitive_for_uint!(u8);
impl_from_primitive_for_uint!(u16);
impl_from_primitive_for_uint!(u32);
impl_from_primitive_for_uint!(u64);
impl_from_primitive_for_float!(f32);
impl_from_primitive_for_float!(f64);
