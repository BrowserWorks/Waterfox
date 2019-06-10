use std::ops::{Add, Mul};

/// Defines an additive identity element for `Self`.
pub trait Zero: Sized + Add<Self, Output = Self> {
    /// Returns the additive identity element of `Self`, `0`.
    ///
    /// # Laws
    ///
    /// ```{.text}
    /// a + 0 = a       ∀ a ∈ Self
    /// 0 + a = a       ∀ a ∈ Self
    /// ```
    ///
    /// # Purity
    ///
    /// This function should return the same result at all times regardless of
    /// external mutable state, for example values stored in TLS or in
    /// `static mut`s.
    // FIXME (#5527): This should be an associated constant
    fn zero() -> Self;

    /// Returns `true` if `self` is equal to the additive identity.
    #[inline]
    fn is_zero(&self) -> bool;
}

macro_rules! zero_impl {
    ($t:ty, $v:expr) => {
        impl Zero for $t {
            #[inline]
            fn zero() -> $t { $v }
            #[inline]
            fn is_zero(&self) -> bool { *self == $v }
        }
    }
}

zero_impl!(usize, 0usize);
zero_impl!(u8,    0u8);
zero_impl!(u16,   0u16);
zero_impl!(u32,   0u32);
zero_impl!(u64,   0u64);

zero_impl!(isize, 0isize);
zero_impl!(i8,    0i8);
zero_impl!(i16,   0i16);
zero_impl!(i32,   0i32);
zero_impl!(i64,   0i64);

zero_impl!(f32, 0.0f32);
zero_impl!(f64, 0.0f64);

/// Defines a multiplicative identity element for `Self`.
pub trait One: Sized + Mul<Self, Output = Self> {
    /// Returns the multiplicative identity element of `Self`, `1`.
    ///
    /// # Laws
    ///
    /// ```{.text}
    /// a * 1 = a       ∀ a ∈ Self
    /// 1 * a = a       ∀ a ∈ Self
    /// ```
    ///
    /// # Purity
    ///
    /// This function should return the same result at all times regardless of
    /// external mutable state, for example values stored in TLS or in
    /// `static mut`s.
    // FIXME (#5527): This should be an associated constant
    fn one() -> Self;
}

macro_rules! one_impl {
    ($t:ty, $v:expr) => {
        impl One for $t {
            #[inline]
            fn one() -> $t { $v }
        }
    }
}

one_impl!(usize, 1usize);
one_impl!(u8,    1u8);
one_impl!(u16,   1u16);
one_impl!(u32,   1u32);
one_impl!(u64,   1u64);

one_impl!(isize, 1isize);
one_impl!(i8,    1i8);
one_impl!(i16,   1i16);
one_impl!(i32,   1i32);
one_impl!(i64,   1i64);

one_impl!(f32, 1.0f32);
one_impl!(f64, 1.0f64);


// Some helper functions provided for backwards compatibility.

/// Returns the additive identity, `0`.
#[inline(always)] pub fn zero<T: Zero>() -> T { Zero::zero() }

/// Returns the multiplicative identity, `1`.
#[inline(always)] pub fn one<T: One>() -> T { One::one() }
