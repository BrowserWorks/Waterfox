use std::ops::Neg;
use std::{f32, f64};

use Num;

/// Useful functions for signed numbers (i.e. numbers that can be negative).
pub trait Signed: Sized + Num + Neg<Output = Self> {
    /// Computes the absolute value.
    ///
    /// For `f32` and `f64`, `NaN` will be returned if the number is `NaN`.
    ///
    /// For signed integers, `::MIN` will be returned if the number is `::MIN`.
    fn abs(&self) -> Self;

    /// The positive difference of two numbers.
    ///
    /// Returns `zero` if the number is less than or equal to `other`, otherwise the difference
    /// between `self` and `other` is returned.
    fn abs_sub(&self, other: &Self) -> Self;

    /// Returns the sign of the number.
    ///
    /// For `f32` and `f64`:
    ///
    /// * `1.0` if the number is positive, `+0.0` or `INFINITY`
    /// * `-1.0` if the number is negative, `-0.0` or `NEG_INFINITY`
    /// * `NaN` if the number is `NaN`
    ///
    /// For signed integers:
    ///
    /// * `0` if the number is zero
    /// * `1` if the number is positive
    /// * `-1` if the number is negative
    fn signum(&self) -> Self;

    /// Returns true if the number is positive and false if the number is zero or negative.
    fn is_positive(&self) -> bool;

    /// Returns true if the number is negative and false if the number is zero or positive.
    fn is_negative(&self) -> bool;
}

macro_rules! signed_impl {
    ($($t:ty)*) => ($(
        impl Signed for $t {
            #[inline]
            fn abs(&self) -> $t {
                if self.is_negative() { -*self } else { *self }
            }

            #[inline]
            fn abs_sub(&self, other: &$t) -> $t {
                if *self <= *other { 0 } else { *self - *other }
            }

            #[inline]
            fn signum(&self) -> $t {
                match *self {
                    n if n > 0 => 1,
                    0 => 0,
                    _ => -1,
                }
            }

            #[inline]
            fn is_positive(&self) -> bool { *self > 0 }

            #[inline]
            fn is_negative(&self) -> bool { *self < 0 }
        }
    )*)
}

signed_impl!(isize i8 i16 i32 i64);

macro_rules! signed_float_impl {
    ($t:ty, $nan:expr, $inf:expr, $neg_inf:expr) => {
        impl Signed for $t {
            /// Computes the absolute value. Returns `NAN` if the number is `NAN`.
            #[inline]
            fn abs(&self) -> $t {
                <$t>::abs(*self)
            }

            /// The positive difference of two numbers. Returns `0.0` if the number is
            /// less than or equal to `other`, otherwise the difference between`self`
            /// and `other` is returned.
            #[inline]
            #[allow(deprecated)]
            fn abs_sub(&self, other: &$t) -> $t {
                <$t>::abs_sub(*self, *other)
            }

            /// # Returns
            ///
            /// - `1.0` if the number is positive, `+0.0` or `INFINITY`
            /// - `-1.0` if the number is negative, `-0.0` or `NEG_INFINITY`
            /// - `NAN` if the number is NaN
            #[inline]
            fn signum(&self) -> $t {
                <$t>::signum(*self)
            }

            /// Returns `true` if the number is positive, including `+0.0` and `INFINITY`
            #[inline]
            fn is_positive(&self) -> bool { *self > 0.0 || (1.0 / *self) == $inf }

            /// Returns `true` if the number is negative, including `-0.0` and `NEG_INFINITY`
            #[inline]
            fn is_negative(&self) -> bool { *self < 0.0 || (1.0 / *self) == $neg_inf }
        }
    }
}

signed_float_impl!(f32, f32::NAN, f32::INFINITY, f32::NEG_INFINITY);
signed_float_impl!(f64, f64::NAN, f64::INFINITY, f64::NEG_INFINITY);

/// Computes the absolute value.
///
/// For `f32` and `f64`, `NaN` will be returned if the number is `NaN`
///
/// For signed integers, `::MIN` will be returned if the number is `::MIN`.
#[inline(always)]
pub fn abs<T: Signed>(value: T) -> T {
    value.abs()
}

/// The positive difference of two numbers.
///
/// Returns zero if `x` is less than or equal to `y`, otherwise the difference
/// between `x` and `y` is returned.
#[inline(always)]
pub fn abs_sub<T: Signed>(x: T, y: T) -> T {
    x.abs_sub(&y)
}

/// Returns the sign of the number.
///
/// For `f32` and `f64`:
///
/// * `1.0` if the number is positive, `+0.0` or `INFINITY`
/// * `-1.0` if the number is negative, `-0.0` or `NEG_INFINITY`
/// * `NaN` if the number is `NaN`
///
/// For signed integers:
///
/// * `0` if the number is zero
/// * `1` if the number is positive
/// * `-1` if the number is negative
#[inline(always)] pub fn signum<T: Signed>(value: T) -> T { value.signum() }

/// A trait for values which cannot be negative
pub trait Unsigned: Num {}

macro_rules! empty_trait_impl {
    ($name:ident for $($t:ty)*) => ($(
        impl $name for $t {}
    )*)
}

empty_trait_impl!(Unsigned for usize u8 u16 u32 u64);
