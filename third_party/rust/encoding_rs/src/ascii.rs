// Copyright 2016 Mozilla Foundation. See the COPYRIGHT
// file at the top-level directory of this distribution.
//
// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// https://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or https://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

// It's assumed that in due course Rust will have explicit SIMD but will not
// be good at run-time selection of SIMD vs. no-SIMD. In such a future,
// x86_64 will always use SSE2 and 32-bit x86 will use SSE2 when compiled with
// a Mozilla-shipped rustc. SIMD support and especially detection on ARM is a
// mess. Under the circumstances, it seems to make sense to optimize the ALU
// case for ARMv7 rather than x86. Annoyingly, I was unable to get useful
// numbers of the actual ARMv7 CPU I have access to, because (thermal?)
// throttling kept interfering. Since Raspberry Pi 3 (ARMv8 core but running
// ARMv7 code) produced reproducible performance numbers, that's the ARM
// computer that this code ended up being optimized for in the ALU case.
// Less popular CPU architectures simply get the approach that was chosen based
// on Raspberry Pi 3 measurements. The UTF-16 and UTF-8 ALU cases take
// different approaches based on benchmarking on Raspberry Pi 3.

#[cfg(all(feature = "simd-accel", any(target_feature = "sse2", all(target_endian = "little", target_arch = "aarch64"))))]
use simd_funcs::*;

#[allow(unused_macros)]
macro_rules! ascii_naive {
    ($name:ident,
     $src_unit:ty,
     $dst_unit:ty) => (
    #[inline(always)]
    pub unsafe fn $name(src: *const $src_unit, dst: *mut $dst_unit, len: usize) -> Option<($src_unit, usize)> {
        // Yes, manually omitting the bound check here matters
        // a lot for perf.
        for i in 0..len {
            let code_unit = *(src.offset(i as isize));
            if code_unit > 127 {
                return Some((code_unit, i));
            }
            *(dst.offset(i as isize)) = code_unit as $dst_unit;
        }
        return None;
    });
}

#[allow(unused_macros)]
macro_rules! ascii_alu {
    ($name:ident,
     $src_unit:ty,
     $dst_unit:ty,
     $stride_fn:ident) => (
    #[cfg_attr(feature = "cargo-clippy", allow(never_loop))]
    #[inline(always)]
    pub unsafe fn $name(src: *const $src_unit, dst: *mut $dst_unit, len: usize) -> Option<($src_unit, usize)> {
        let mut offset = 0usize;
        // This loop is only broken out of as a `goto` forward
        loop {
            let mut until_alignment = {
                // Check if the other unit aligns if we move the narrower unit
                // to alignment.
                //               if ::std::mem::size_of::<$src_unit>() == ::std::mem::size_of::<$dst_unit>() {
                // ascii_to_ascii
                let src_alignment = (src as usize) & ALIGNMENT_MASK;
                let dst_alignment = (dst as usize) & ALIGNMENT_MASK;
                if src_alignment != dst_alignment {
                    break;
                }
                (ALIGNMENT - src_alignment) & ALIGNMENT_MASK
                //               } else if ::std::mem::size_of::<$src_unit>() < ::std::mem::size_of::<$dst_unit>() {
                // ascii_to_basic_latin
                //                   let src_until_alignment = (ALIGNMENT - ((src as usize) & ALIGNMENT_MASK)) & ALIGNMENT_MASK;
                //                   if (dst.offset(src_until_alignment as isize) as usize) & ALIGNMENT_MASK != 0 {
                //                       break;
                //                   }
                //                   src_until_alignment
                //               } else {
                // basic_latin_to_ascii
                //                   let dst_until_alignment = (ALIGNMENT - ((dst as usize) & ALIGNMENT_MASK)) & ALIGNMENT_MASK;
                //                   if (src.offset(dst_until_alignment as isize) as usize) & ALIGNMENT_MASK != 0 {
                //                       break;
                //                   }
                //                   dst_until_alignment
                //               }
                };
                if until_alignment + STRIDE_SIZE <= len {
                // Moving pointers to alignment seems to be a pessimization on
                // x86_64 for operations that have UTF-16 as the internal
                // Unicode representation. However, since it seems to be a win
                // on ARM (tested ARMv7 code running on ARMv8 [rpi3]), except
                // mixed results when encoding from UTF-16 and since x86 and
                // x86_64 should be using SSE2 in due course, keeping the move
                // to alignment here. It would be good to test on more ARM CPUs
                // and on real MIPS and POWER hardware.
                while until_alignment != 0 {
                    let code_unit = *(src.offset(offset as isize));
                    if code_unit > 127 {
                        return Some((code_unit, offset));
                    }
                    *(dst.offset(offset as isize)) = code_unit as $dst_unit;
                    offset += 1;
                    until_alignment -= 1;
                }
                let len_minus_stride = len - STRIDE_SIZE;
                loop {
                    if let Some(num_ascii) = $stride_fn(src.offset(offset as isize) as *const usize,
                                   dst.offset(offset as isize) as *mut usize) {
                        offset += num_ascii;
                        return Some((*(src.offset(offset as isize)), offset));
                    }
                    offset += STRIDE_SIZE;
                    if offset > len_minus_stride {
                        break;
                    }
                }
            }
            break;
        }
        while offset < len {
            let code_unit = *(src.offset(offset as isize));
            if code_unit > 127 {
                return Some((code_unit, offset));
            }
            *(dst.offset(offset as isize)) = code_unit as $dst_unit;
            offset += 1;
        }
        None
    });
}

#[allow(unused_macros)]
macro_rules! basic_latin_alu {
    ($name:ident,
     $src_unit:ty,
     $dst_unit:ty,
     $stride_fn:ident) => (
    #[cfg_attr(feature = "cargo-clippy", allow(never_loop))]
    #[inline(always)]
    pub unsafe fn $name(src: *const $src_unit, dst: *mut $dst_unit, len: usize) -> Option<($src_unit, usize)> {
        let mut offset = 0usize;
        // This loop is only broken out of as a `goto` forward
        loop {
            let mut until_alignment = {
                // Check if the other unit aligns if we move the narrower unit
                // to alignment.
                //               if ::std::mem::size_of::<$src_unit>() == ::std::mem::size_of::<$dst_unit>() {
                // ascii_to_ascii
                //                   let src_alignment = (src as usize) & ALIGNMENT_MASK;
                //                   let dst_alignment = (dst as usize) & ALIGNMENT_MASK;
                //                   if src_alignment != dst_alignment {
                //                       break;
                //                   }
                //                   (ALIGNMENT - src_alignment) & ALIGNMENT_MASK
                //               } else
                if ::std::mem::size_of::<$src_unit>() < ::std::mem::size_of::<$dst_unit>() {
                    // ascii_to_basic_latin
                    let src_until_alignment = (ALIGNMENT - ((src as usize) & ALIGNMENT_MASK)) & ALIGNMENT_MASK;
                    if (dst.offset(src_until_alignment as isize) as usize) & ALIGNMENT_MASK != 0 {
                        break;
                    }
                    src_until_alignment
                } else {
                    // basic_latin_to_ascii
                    let dst_until_alignment = (ALIGNMENT - ((dst as usize) & ALIGNMENT_MASK)) & ALIGNMENT_MASK;
                    if (src.offset(dst_until_alignment as isize) as usize) & ALIGNMENT_MASK != 0 {
                        break;
                    }
                    dst_until_alignment
                }
            };
            if until_alignment + STRIDE_SIZE <= len {
                // Moving pointers to alignment seems to be a pessimization on
                // x86_64 for operations that have UTF-16 as the internal
                // Unicode representation. However, since it seems to be a win
                // on ARM (tested ARMv7 code running on ARMv8 [rpi3]), except
                // mixed results when encoding from UTF-16 and since x86 and
                // x86_64 should be using SSE2 in due course, keeping the move
                // to alignment here. It would be good to test on more ARM CPUs
                // and on real MIPS and POWER hardware.
                while until_alignment != 0 {
                    let code_unit = *(src.offset(offset as isize));
                    if code_unit > 127 {
                        return Some((code_unit, offset));
                    }
                    *(dst.offset(offset as isize)) = code_unit as $dst_unit;
                    offset += 1;
                    until_alignment -= 1;
                }
                let len_minus_stride = len - STRIDE_SIZE;
                loop {
                    if !$stride_fn(src.offset(offset as isize) as *const usize,
                                   dst.offset(offset as isize) as *mut usize) {
                        break;
                    }
                    offset += STRIDE_SIZE;
                    if offset > len_minus_stride {
                        break;
                    }
                }
            }
            break;
        }
        while offset < len {
            let code_unit = *(src.offset(offset as isize));
            if code_unit > 127 {
                return Some((code_unit, offset));
            }
            *(dst.offset(offset as isize)) = code_unit as $dst_unit;
            offset += 1;
        }
        None
    });
}

#[allow(unused_macros)]
macro_rules! ascii_simd_check_align {
    ($name:ident,
     $src_unit:ty,
     $dst_unit:ty,
     $stride_both_aligned:ident,
     $stride_src_aligned:ident,
     $stride_dst_aligned:ident,
     $stride_neither_aligned:ident) => (
    #[inline(always)]
    pub unsafe fn $name(src: *const $src_unit, dst: *mut $dst_unit, len: usize) -> Option<($src_unit, usize)> {
        let mut offset = 0usize;
        if STRIDE_SIZE <= len {
            let len_minus_stride = len - STRIDE_SIZE;
            // XXX Should we first process one stride unconditinoally as unaligned to
            // avoid the cost of the branchiness below if the first stride fails anyway?
            // XXX Should we just use unaligned SSE2 access unconditionally? It seems that
            // on Haswell, it would make sense to just use unaligned and not bother
            // checking. Need to benchmark older architectures before deciding.
            let dst_masked = (dst as usize) & ALIGNMENT_MASK;
            if ((src as usize) & ALIGNMENT_MASK) == 0 {
                if dst_masked == 0 {
                    loop {
                        if !$stride_both_aligned(src.offset(offset as isize),
                                                 dst.offset(offset as isize)) {
                            break;
                        }
                        offset += STRIDE_SIZE;
                        if offset > len_minus_stride {
                            break;
                        }
                    }
                } else {
                    loop {
                        if !$stride_src_aligned(src.offset(offset as isize),
                                                dst.offset(offset as isize)) {
                            break;
                        }
                        offset += STRIDE_SIZE;
                        if offset > len_minus_stride {
                            break;
                        }
                    }
                }
            } else {
                if dst_masked == 0 {
                    loop {
                        if !$stride_dst_aligned(src.offset(offset as isize),
                                                dst.offset(offset as isize)) {
                            break;
                        }
                        offset += STRIDE_SIZE;
                        if offset > len_minus_stride {
                            break;
                        }
                    }
                } else {
                    loop {
                        if !$stride_neither_aligned(src.offset(offset as isize),
                                                    dst.offset(offset as isize)) {
                            break;
                        }
                        offset += STRIDE_SIZE;
                        if offset > len_minus_stride {
                            break;
                        }
                    }
                }
            }
        }
        while offset < len {
            let code_unit = *(src.offset(offset as isize));
            if code_unit > 127 {
                return Some((code_unit, offset));
            }
            *(dst.offset(offset as isize)) = code_unit as $dst_unit;
            offset += 1;
        }
        None
    });
}

#[allow(unused_macros)]
macro_rules! ascii_simd_unalign {
    ($name:ident,
     $src_unit:ty,
     $dst_unit:ty,
     $stride_neither_aligned:ident) => (
    #[inline(always)]
    pub unsafe fn $name(src: *const $src_unit, dst: *mut $dst_unit, len: usize) -> Option<($src_unit, usize)> {
        let mut offset = 0usize;
        if STRIDE_SIZE <= len {
            let len_minus_stride = len - STRIDE_SIZE;
            loop {
                if !$stride_neither_aligned(src.offset(offset as isize),
                                            dst.offset(offset as isize)) {
                    break;
                }
                offset += STRIDE_SIZE;
                if offset > len_minus_stride {
                    break;
                }
            }
        }
        while offset < len {
            let code_unit = *(src.offset(offset as isize));
            if code_unit > 127 {
                return Some((code_unit, offset));
            }
            *(dst.offset(offset as isize)) = code_unit as $dst_unit;
            offset += 1;
        }
        None
    });
}

#[allow(unused_macros)]
macro_rules! ascii_to_ascii_simd_stride {
    ($name:ident,
     $load:ident,
     $store:ident) => (
    #[inline(always)]
    pub unsafe fn $name(src: *const u8, dst: *mut u8) -> bool {
        let simd = $load(src);
        if !is_ascii(simd) {
            return false;
        }
        $store(dst, simd);
        true
    });
}

#[allow(unused_macros)]
macro_rules! ascii_to_basic_latin_simd_stride {
    ($name:ident,
     $load:ident,
     $store:ident) => (
    #[inline(always)]
    pub unsafe fn $name(src: *const u8, dst: *mut u16) -> bool {
        let simd = $load(src);
        if !is_ascii(simd) {
            return false;
        }
        let (first, second) = unpack(simd);
        $store(dst, first);
        $store(dst.offset(8), second);
        true
    });
}

#[allow(unused_macros)]
macro_rules! basic_latin_to_ascii_simd_stride {
    ($name:ident,
     $load:ident,
     $store:ident) => (
    #[inline(always)]
    pub unsafe fn $name(src: *const u16, dst: *mut u8) -> bool {
        let first = $load(src);
        let second = $load(src.offset(8));
        match pack_basic_latin(first, second) {
            Some(packed) => {
                $store(dst, packed);
                true
            },
            None => false,
        }
    });
}

cfg_if! {
    if #[cfg(all(feature = "simd-accel", target_endian = "little", target_arch = "aarch64"))] {
        // SIMD with the same instructions for aligned and unaligned loads and stores

        pub const STRIDE_SIZE: usize = 16;

        const ALIGNMENT: usize = 8;

        ascii_to_ascii_simd_stride!(ascii_to_ascii_stride_neither_aligned, load16_unaligned, store16_unaligned);

        ascii_to_basic_latin_simd_stride!(ascii_to_basic_latin_stride_neither_aligned, load16_unaligned, store8_unaligned);

        basic_latin_to_ascii_simd_stride!(basic_latin_to_ascii_stride_neither_aligned, load8_unaligned, store16_unaligned);

        ascii_simd_unalign!(ascii_to_ascii, u8, u8, ascii_to_ascii_stride_neither_aligned);
        ascii_simd_unalign!(ascii_to_basic_latin, u8, u16, ascii_to_basic_latin_stride_neither_aligned);
        ascii_simd_unalign!(basic_latin_to_ascii, u16, u8, basic_latin_to_ascii_stride_neither_aligned);
    } else if #[cfg(all(feature = "simd-accel", target_feature = "sse2"))] {
        // SIMD with different instructions for aligned and unaligned loads and stores.
        //
        // Newer microarchitectures are not supposed to have a performance difference between
        // aligned and unaligned SSE2 loads and stores when the address is actually aligned,
        // but the benchmark results I see don't agree.

        pub const STRIDE_SIZE: usize = 16;

        const ALIGNMENT_MASK: usize = 15;

        ascii_to_ascii_simd_stride!(ascii_to_ascii_stride_both_aligned, load16_aligned, store16_aligned);
        ascii_to_ascii_simd_stride!(ascii_to_ascii_stride_src_aligned, load16_aligned, store16_unaligned);
        ascii_to_ascii_simd_stride!(ascii_to_ascii_stride_dst_aligned, load16_unaligned, store16_aligned);
        ascii_to_ascii_simd_stride!(ascii_to_ascii_stride_neither_aligned, load16_unaligned, store16_unaligned);

        ascii_to_basic_latin_simd_stride!(ascii_to_basic_latin_stride_both_aligned, load16_aligned, store8_aligned);
        ascii_to_basic_latin_simd_stride!(ascii_to_basic_latin_stride_src_aligned, load16_aligned, store8_unaligned);
        ascii_to_basic_latin_simd_stride!(ascii_to_basic_latin_stride_dst_aligned, load16_unaligned, store8_aligned);
        ascii_to_basic_latin_simd_stride!(ascii_to_basic_latin_stride_neither_aligned, load16_unaligned, store8_unaligned);

        basic_latin_to_ascii_simd_stride!(basic_latin_to_ascii_stride_both_aligned, load8_aligned, store16_aligned);
        basic_latin_to_ascii_simd_stride!(basic_latin_to_ascii_stride_src_aligned, load8_aligned, store16_unaligned);
        basic_latin_to_ascii_simd_stride!(basic_latin_to_ascii_stride_dst_aligned, load8_unaligned, store16_aligned);
        basic_latin_to_ascii_simd_stride!(basic_latin_to_ascii_stride_neither_aligned, load8_unaligned, store16_unaligned);

        ascii_simd_check_align!(ascii_to_ascii, u8, u8, ascii_to_ascii_stride_both_aligned, ascii_to_ascii_stride_src_aligned, ascii_to_ascii_stride_dst_aligned, ascii_to_ascii_stride_neither_aligned);
        ascii_simd_check_align!(ascii_to_basic_latin, u8, u16, ascii_to_basic_latin_stride_both_aligned, ascii_to_basic_latin_stride_src_aligned, ascii_to_basic_latin_stride_dst_aligned, ascii_to_basic_latin_stride_neither_aligned);
        ascii_simd_check_align!(basic_latin_to_ascii, u16, u8, basic_latin_to_ascii_stride_both_aligned, basic_latin_to_ascii_stride_src_aligned, basic_latin_to_ascii_stride_dst_aligned, basic_latin_to_ascii_stride_neither_aligned);
    } else if #[cfg(all(target_endian = "little", target_pointer_width = "64"))] {
        // Aligned ALU word, little-endian, 64-bit

        pub const STRIDE_SIZE: usize = 16;

        const ALIGNMENT: usize = 8;

        const ALIGNMENT_MASK: usize = 7;

        #[inline(always)]
        unsafe fn ascii_to_basic_latin_stride_little_64(src: *const usize, dst: *mut usize) -> bool {
            let word = *src;
            let second_word = *(src.offset(1));
            // Check if the words contains non-ASCII
            if (word & ASCII_MASK) | (second_word & ASCII_MASK) != 0 {
                return false;
            }
            let first = ((0x00000000_FF000000usize & word) << 24) |
                        ((0x00000000_00FF0000usize & word) << 16) |
                        ((0x00000000_0000FF00usize & word) << 8) |
                        (0x00000000_000000FFusize & word);
            let second = ((0xFF000000_00000000usize & word) >> 8) |
                         ((0x00FF0000_00000000usize & word) >> 16) |
                         ((0x0000FF00_00000000usize & word) >> 24) |
                         ((0x000000FF_00000000usize & word) >> 32);
            let third = ((0x00000000_FF000000usize & second_word) << 24) |
                        ((0x00000000_00FF0000usize & second_word) << 16) |
                        ((0x00000000_0000FF00usize & second_word) << 8) |
                        (0x00000000_000000FFusize & second_word);
            let fourth = ((0xFF000000_00000000usize & second_word) >> 8) |
                         ((0x00FF0000_00000000usize & second_word) >> 16) |
                         ((0x0000FF00_00000000usize & second_word) >> 24) |
                         ((0x000000FF_00000000usize & second_word) >> 32);
            *dst = first;
            *(dst.offset(1)) = second;
            *(dst.offset(2)) = third;
            *(dst.offset(3)) = fourth;
            true
        }

        #[inline(always)]
        unsafe fn basic_latin_to_ascii_stride_little_64(src: *const usize, dst: *mut usize) -> bool {
            let first = *src;
            let second = *(src.offset(1));
            let third = *(src.offset(2));
            let fourth = *(src.offset(3));
            if (first & BASIC_LATIN_MASK) | (second & BASIC_LATIN_MASK) | (third & BASIC_LATIN_MASK) | (fourth & BASIC_LATIN_MASK) != 0 {
                return false;
            }
            let word = ((0x00FF0000_00000000usize & second) << 8) |
                       ((0x000000FF_00000000usize & second) << 16) |
                       ((0x00000000_00FF0000usize & second) << 24) |
                       ((0x00000000_000000FFusize & second) << 32) |
                       ((0x00FF0000_00000000usize & first) >> 24) |
                       ((0x000000FF_00000000usize & first) >> 16) |
                       ((0x00000000_00FF0000usize & first) >> 8) |
                       (0x00000000_000000FFusize & first);
            let second_word = ((0x00FF0000_00000000usize & fourth) << 8) |
                              ((0x000000FF_00000000usize & fourth) << 16) |
                              ((0x00000000_00FF0000usize & fourth) << 24) |
                              ((0x00000000_000000FFusize & fourth) << 32) |
                              ((0x00FF0000_00000000usize & third) >> 24) |
                              ((0x000000FF_00000000usize & third) >> 16) |
                              ((0x00000000_00FF0000usize & third) >> 8) |
                              (0x00000000_000000FFusize & third);
            *dst = word;
            *(dst.offset(1)) = second_word;
            true
        }

        basic_latin_alu!(ascii_to_basic_latin, u8, u16, ascii_to_basic_latin_stride_little_64);
        basic_latin_alu!(basic_latin_to_ascii, u16, u8, basic_latin_to_ascii_stride_little_64);
    } else if #[cfg(all(target_endian = "little", target_pointer_width = "32"))] {
        // Aligned ALU word, little-endian, 32-bit

        pub const STRIDE_SIZE: usize = 8;

        const ALIGNMENT: usize = 4;

        const ALIGNMENT_MASK: usize = 3;

        #[inline(always)]
        unsafe fn ascii_to_basic_latin_stride_little_32(src: *const usize, dst: *mut usize) -> bool {
            let word = *src;
            let second_word = *(src.offset(1));
            // Check if the words contains non-ASCII
            if (word & ASCII_MASK) | (second_word & ASCII_MASK) != 0 {
                return false;
            }
            let first = ((0x0000FF00usize & word) << 8) |
                        (0x000000FFusize & word);
            let second = ((0xFF000000usize & word) >> 8) |
                         ((0x00FF0000usize & word) >> 16);
            let third = ((0x0000FF00usize & second_word) << 8) |
                        (0x000000FFusize & second_word);
            let fourth = ((0xFF000000usize & second_word) >> 8) |
                         ((0x00FF0000usize & second_word) >> 16);
            *dst = first;
            *(dst.offset(1)) = second;
            *(dst.offset(2)) = third;
            *(dst.offset(3)) = fourth;
            return true;
        }

        #[inline(always)]
        unsafe fn basic_latin_to_ascii_stride_little_32(src: *const usize, dst: *mut usize) -> bool {
            let first = *src;
            let second = *(src.offset(1));
            let third = *(src.offset(2));
            let fourth = *(src.offset(3));
            if (first & BASIC_LATIN_MASK) | (second & BASIC_LATIN_MASK) | (third & BASIC_LATIN_MASK) | (fourth & BASIC_LATIN_MASK) != 0 {
                return false;
            }
            let word = ((0x00FF0000usize & second) << 8) |
                       ((0x000000FFusize & second) << 16) |
                       ((0x00FF0000usize & first) >> 8) |
                       (0x000000FFusize & first);
            let second_word = ((0x00FF0000usize & fourth) << 8) |
                              ((0x000000FFusize & fourth) << 16) |
                              ((0x00FF0000usize & third) >> 8) |
                              (0x000000FFusize & third);
            *dst = word;
            *(dst.offset(1)) = second_word;
            return true;
        }

        basic_latin_alu!(ascii_to_basic_latin, u8, u16, ascii_to_basic_latin_stride_little_32);
        basic_latin_alu!(basic_latin_to_ascii, u16, u8, basic_latin_to_ascii_stride_little_32);
    } else if #[cfg(all(target_endian = "big", target_pointer_width = "64"))] {
        // Aligned ALU word, big-endian, 64-bit

        pub const STRIDE_SIZE: usize = 16;

        const ALIGNMENT: usize = 8;

        const ALIGNMENT_MASK: usize = 7;

        #[inline(always)]
        unsafe fn ascii_to_basic_latin_stride_big_64(src: *const usize, dst: *mut usize) -> bool {
            let word = *src;
            let second_word = *(src.offset(1));
            // Check if the words contains non-ASCII
            if (word & ASCII_MASK) | (second_word & ASCII_MASK) != 0 {
                return false;
            }
            let first = ((0xFF000000_00000000usize & word) >> 8) |
                         ((0x00FF0000_00000000usize & word) >> 16) |
                         ((0x0000FF00_00000000usize & word) >> 24) |
                         ((0x000000FF_00000000usize & word) >> 32);
            let second = ((0x00000000_FF000000usize & word) << 24) |
                        ((0x00000000_00FF0000usize & word) << 16) |
                        ((0x00000000_0000FF00usize & word) << 8) |
                        (0x00000000_000000FFusize & word);
            let third = ((0xFF000000_00000000usize & second_word) >> 8) |
                         ((0x00FF0000_00000000usize & second_word) >> 16) |
                         ((0x0000FF00_00000000usize & second_word) >> 24) |
                         ((0x000000FF_00000000usize & second_word) >> 32);
            let fourth = ((0x00000000_FF000000usize & second_word) << 24) |
                        ((0x00000000_00FF0000usize & second_word) << 16) |
                        ((0x00000000_0000FF00usize & second_word) << 8) |
                        (0x00000000_000000FFusize & second_word);
            *dst = first;
            *(dst.offset(1)) = second;
            *(dst.offset(2)) = third;
            *(dst.offset(3)) = fourth;
            return true;
        }

        #[inline(always)]
        unsafe fn basic_latin_to_ascii_stride_big_64(src: *const usize, dst: *mut usize) -> bool {
            let first = *src;
            let second = *(src.offset(1));
            let third = *(src.offset(2));
            let fourth = *(src.offset(3));
            if (first & BASIC_LATIN_MASK) | (second & BASIC_LATIN_MASK) | (third & BASIC_LATIN_MASK) | (fourth & BASIC_LATIN_MASK) != 0 {
                return false;
            }
            let word = ((0x00FF0000_00000000usize & first) << 8) |
                       ((0x000000FF_00000000usize & first) << 16) |
                       ((0x00000000_00FF0000usize & first) << 24) |
                       ((0x00000000_000000FFusize & first) << 32) |
                       ((0x00FF0000_00000000usize & second) >> 24) |
                       ((0x000000FF_00000000usize & second) >> 16) |
                       ((0x00000000_00FF0000usize & second) >> 8) |
                       (0x00000000_000000FFusize & second);
            let second_word = ((0x00FF0000_00000000usize & third) << 8) |
                              ((0x000000FF_00000000usize & third) << 16) |
                              ((0x00000000_00FF0000usize & third) << 24) |
                              ((0x00000000_000000FFusize & third) << 32) |
                              ((0x00FF0000_00000000usize & fourth) >> 24) |
                              ((0x000000FF_00000000usize & fourth) >> 16) |
                              ((0x00000000_00FF0000usize & fourth) >> 8) |
                              (0x00000000_000000FFusize &  fourth);
            *dst = word;
            *(dst.offset(1)) = second_word;
            return true;
        }

        basic_latin_alu!(ascii_to_basic_latin, u8, u16, ascii_to_basic_latin_stride_big_64);
        basic_latin_alu!(basic_latin_to_ascii, u16, u8, basic_latin_to_ascii_stride_big_64);
    } else if #[cfg(all(target_endian = "big", target_pointer_width = "32"))] {
        // Aligned ALU word, big-endian, 32-bit

        pub const STRIDE_SIZE: usize = 8;

        const ALIGNMENT: usize = 4;

        const ALIGNMENT_MASK: usize = 3;

        #[inline(always)]
        unsafe fn ascii_to_basic_latin_stride_big_32(src: *const usize, dst: *mut usize) -> bool {
            let word = *src;
            let second_word = *(src.offset(1));
            // Check if the words contains non-ASCII
            if (word & ASCII_MASK) | (second_word & ASCII_MASK) != 0 {
                return false;
            }
            let first = ((0xFF000000usize & word) >> 8) |
                         ((0x00FF0000usize & word) >> 16);
            let second = ((0x0000FF00usize & word) << 8) |
                        (0x000000FFusize & word);
            let third = ((0xFF000000usize & second_word) >> 8) |
                         ((0x00FF0000usize & second_word) >> 16);
            let fourth = ((0x0000FF00usize & second_word) << 8) |
                        (0x000000FFusize & second_word);
            *dst = first;
            *(dst.offset(1)) = second;
            *(dst.offset(2)) = third;
            *(dst.offset(3)) = fourth;
            return true;
        }

        #[inline(always)]
        unsafe fn basic_latin_to_ascii_stride_big_32(src: *const usize, dst: *mut usize) -> bool {
            let first = *src;
            let second = *(src.offset(1));
            let third = *(src.offset(2));
            let fourth = *(src.offset(3));
            if (first & BASIC_LATIN_MASK) | (second & BASIC_LATIN_MASK) | (third & BASIC_LATIN_MASK) | (fourth & BASIC_LATIN_MASK) != 0 {
                return false;
            }
            let word = ((0x00FF0000usize & first) << 8) |
                       ((0x000000FFusize & first) << 16) |
                       ((0x00FF0000usize & second) >> 8) |
                       (0x000000FFusize & second);
            let second_word = ((0x00FF0000usize & third) << 8) |
                              ((0x000000FFusize & third) << 16) |
                              ((0x00FF0000usize & fourth) >> 8) |
                              (0x000000FFusize & fourth);
            *dst = word;
            *(dst.offset(1)) = second_word;
            return true;
        }

        basic_latin_alu!(ascii_to_basic_latin, u8, u16, ascii_to_basic_latin_stride_big_32);
        basic_latin_alu!(basic_latin_to_ascii, u16, u8, basic_latin_to_ascii_stride_big_32);
    } else {
        ascii_naive!(ascii_to_ascii, u8, u8);
        ascii_naive!(ascii_to_basic_latin, u8, u16);
        ascii_naive!(basic_latin_to_ascii, u16, u8);
    }
}

cfg_if! {
    if #[cfg(target_endian = "little")] {
        #[allow(dead_code)]
        #[inline(always)]
        fn count_zeros(word: usize) -> u32 {
            word.trailing_zeros()
        }
    } else {
        #[allow(dead_code)]
        #[inline(always)]
        fn count_zeros(word: usize) -> u32 {
            word.leading_zeros()
        }
    }
}

cfg_if! {
    if #[cfg(all(feature = "simd-accel", target_endian = "little", target_arch = "aarch64"))] {
        #[inline(always)]
        pub fn validate_ascii(slice: &[u8]) -> Option<(u8, usize)> {
            let src = slice.as_ptr();
            let len = slice.len();
            let mut offset = 0usize;
            if STRIDE_SIZE <= len {
                let len_minus_stride = len - STRIDE_SIZE;
                loop {
                    let simd = unsafe { load16_unaligned(src.offset(offset as isize)) };
                    if !is_ascii(simd) {
                        break;
                    }
                    offset += STRIDE_SIZE;
                    if offset > len_minus_stride {
                        break;
                    }
                }
            }
            while offset < len {
                let code_unit = slice[offset];
                if code_unit > 127 {
                    return Some((code_unit, offset));
                }
                offset += 1;
            }
            None
        }
    } else if #[cfg(all(feature = "simd-accel", target_feature = "sse2"))] {
        #[inline(always)]
        pub fn validate_ascii(slice: &[u8]) -> Option<(u8, usize)> {
            let src = slice.as_ptr();
            let len = slice.len();
            let mut offset = 0usize;
            if STRIDE_SIZE <= len {
                let len_minus_stride = len - STRIDE_SIZE;
                // XXX Should we first process one stride unconditionally as unaligned to
                // avoid the cost of the branchiness below if the first stride fails anyway?
                // XXX Should we just use unaligned SSE2 access unconditionally? It seems that
                // on Haswell, it would make sense to just use unaligned and not bother
                // checking. Need to benchmark older architectures before deciding.
                if ((src as usize) & ALIGNMENT_MASK) == 0 {
                    loop {
                        let simd = unsafe { load16_aligned(src.offset(offset as isize)) };
                        let mask = mask_ascii(simd);
                        if mask != 0 {
                            offset += mask.trailing_zeros() as usize;
                            let non_ascii = unsafe { *src.offset(offset as isize) };
                            return Some((non_ascii, offset));
                        }
                        offset += STRIDE_SIZE;
                        if offset > len_minus_stride {
                            break;
                        }
                    }
                } else {
                    loop {
                        let simd = unsafe { load16_unaligned(src.offset(offset as isize)) };
                        let mask = mask_ascii(simd);
                        if mask != 0 {
                            offset += mask.trailing_zeros() as usize;
                            let non_ascii = unsafe { *src.offset(offset as isize) };
                            return Some((non_ascii, offset));
                        }
                        offset += STRIDE_SIZE;
                        if offset > len_minus_stride {
                            break;
                        }
                    }
                }
            }
            while offset < len {
                let code_unit = slice[offset];
                if code_unit > 127 {
                    return Some((code_unit, offset));
                }
                offset += 1;
            }
            None
        }
    } else {
        // `as` truncates, so works on 32-bit, too.
        const ASCII_MASK: usize = 0x80808080_80808080u64 as usize;
        const BASIC_LATIN_MASK: usize = 0xFF80FF80_FF80FF80u64 as usize;

        #[inline(always)]
        unsafe fn ascii_to_ascii_stride(src: *const usize, dst: *mut usize) -> Option<usize> {
            let word = *src;
            let second_word = *(src.offset(1));
            *dst = word;
            *(dst.offset(1)) = second_word;
            find_non_ascii(word, second_word)
        }

        #[inline(always)]
        unsafe fn validate_ascii_stride(src: *const usize) -> Option<usize> {
            let word = *src;
            let second_word = *(src.offset(1));
            find_non_ascii(word, second_word)
        }

        #[inline(always)]
        fn find_non_ascii(word: usize, second_word: usize) -> Option<usize> {
            let word_masked = word & ASCII_MASK;
            let second_masked = second_word & ASCII_MASK;
            if (word_masked | second_masked) == 0 {
                return None;
            }
            if word_masked != 0 {
                let zeros = count_zeros(word_masked);
                // `zeros` now contains 7 (for the seven bits of non-ASCII)
                // plus 8 times the number of ASCII in text order before the
                // non-ASCII byte in the little-endian case or 8 times the number of ASCII in
                // text order before the non-ASCII byte in the big-endian case.
                let num_ascii = (zeros >> 3) as usize;
                return Some(num_ascii);
            }
            let zeros = count_zeros(second_masked);
            // `zeros` now contains 7 (for the seven bits of non-ASCII)
            // plus 8 times the number of ASCII in text order before the
            // non-ASCII byte in the little-endian case or 8 times the number of ASCII in
            // text order before the non-ASCII byte in the big-endian case.
            let num_ascii = (zeros >> 3) as usize;
            Some(ALIGNMENT + num_ascii)
        }

        #[cfg(not(all(feature = "simd-accel", target_endian = "little", target_arch = "aarch64")))]
        ascii_alu!(ascii_to_ascii, u8, u8, ascii_to_ascii_stride);

        #[inline(always)]
        pub fn validate_ascii(slice: &[u8]) -> Option<(u8, usize)> {
            let src = slice.as_ptr();
            let len = slice.len();
            let mut offset = 0usize;
            let mut until_alignment = (ALIGNMENT - ((src as usize) & ALIGNMENT_MASK)) & ALIGNMENT_MASK;
            if until_alignment + STRIDE_SIZE <= len {
                while until_alignment != 0 {
                    let code_unit = slice[offset];
                    if code_unit > 127 {
                        return Some((code_unit, offset));
                    }
                    offset += 1;
                    until_alignment -= 1;
                }
                let len_minus_stride = len - STRIDE_SIZE;
                loop {
                    let ptr = unsafe { src.offset(offset as isize) as *const usize };
                    if let Some(num_ascii) = unsafe { validate_ascii_stride(ptr) } {
                        offset += num_ascii;
                        return Some((unsafe { *(src.offset(offset as isize)) }, offset));
                    }
                    offset += STRIDE_SIZE;
                    if offset > len_minus_stride {
                        break;
                    }
                }
            }
            while offset < len {
                let code_unit = slice[offset];
                if code_unit > 127 {
                    return Some((code_unit, offset));
                }
                offset += 1;
           }
           None
        }

    }
}

pub fn ascii_valid_up_to(bytes: &[u8]) -> usize {
    match validate_ascii(bytes) {
        None => bytes.len(),
        Some((_, num_valid)) => num_valid,
    }
}

pub fn iso_2022_jp_ascii_valid_up_to(bytes: &[u8]) -> usize {
    for (i, b_ref) in bytes.iter().enumerate() {
        let b = *b_ref;
        if b >= 0x80 || b == 0x1B || b == 0x0E || b == 0x0F {
            return i;
        }
    }
    bytes.len()
}

// Any copyright to the test code below this comment is dedicated to the
// Public Domain. http://creativecommons.org/publicdomain/zero/1.0/

#[cfg(test)]
mod tests {
    use super::*;

    macro_rules! test_ascii {
        ($test_name:ident,
         $fn_tested:ident,
         $src_unit:ty,
         $dst_unit:ty) => (
        #[test]
        fn $test_name() {
            let mut src: Vec<$src_unit> = Vec::with_capacity(32);
            let mut dst: Vec<$dst_unit> = Vec::with_capacity(32);
            for i in 0..32 {
                src.clear();
                dst.clear();
                dst.resize(32, 0);
                for j in 0..32 {
                    let c = if i == j {
                        0xAA
                    } else {
                        j + 0x40
                    };
                    src.push(c as $src_unit);
                }
                match unsafe { $fn_tested(src.as_ptr(), dst.as_mut_ptr(), 32) } {
                    None => unreachable!("Should always find non-ASCII"),
                    Some((non_ascii, num_ascii)) => {
                        assert_eq!(non_ascii, 0xAA);
                        assert_eq!(num_ascii, i);
                        for j in 0..i {
                            assert_eq!(dst[j], (j + 0x40) as $dst_unit);
                        }
                    }
                }
            }
        });
    }

    test_ascii!(test_ascii_to_ascii, ascii_to_ascii, u8, u8);
    test_ascii!(test_ascii_to_basic_latin, ascii_to_basic_latin, u8, u16);
    test_ascii!(test_basic_latin_to_ascii, basic_latin_to_ascii, u16, u8);
}
