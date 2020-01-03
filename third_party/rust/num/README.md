# num

[![crate](https://img.shields.io/crates/v/num.svg)](https://crates.io/crates/num)
[![documentation](https://docs.rs/num/badge.svg)](https://docs.rs/num)
![minimum rustc 1.8](https://img.shields.io/badge/rustc-1.8+-red.svg)
[![Travis status](https://travis-ci.org/rust-num/num.svg?branch=master)](https://travis-ci.org/rust-num/num)

A collection of numeric types and traits for Rust.

This includes new types for big integers, rationals, and complex numbers,
new traits for generic programming on numeric properties like `Integer`,
and generic range iterators.

`num` is a meta-crate, re-exporting items from these sub-crates:

- [`num-bigint`](https://github.com/rust-num/num-bigint)
  [![crate](https://img.shields.io/crates/v/num-bigint.svg)](https://crates.io/crates/num-bigint)

- [`num-complex`](https://github.com/rust-num/num-complex)
  [![crate](https://img.shields.io/crates/v/num-complex.svg)](https://crates.io/crates/num-complex)

- [`num-integer`](https://github.com/rust-num/num-integer)
  [![crate](https://img.shields.io/crates/v/num-integer.svg)](https://crates.io/crates/num-integer)

- [`num-iter`](https://github.com/rust-num/num-iter)
  [![crate](https://img.shields.io/crates/v/num-iter.svg)](https://crates.io/crates/num-iter)

- [`num-rational`](https://github.com/rust-num/num-rational)
  [![crate](https://img.shields.io/crates/v/num-rational.svg)](https://crates.io/crates/num-rational)

- [`num-traits`](https://github.com/rust-num/num-traits)
  [![crate](https://img.shields.io/crates/v/num-traits.svg)](https://crates.io/crates/num-traits)

There is also a `proc-macro` crate for deriving some numeric traits:

- [`num-derive`](https://github.com/rust-num/num-derive)
  [![crate](https://img.shields.io/crates/v/num-derive.svg)](https://crates.io/crates/num-derive)

## Usage

Add this to your `Cargo.toml`:

```toml
[dependencies]
num = "0.1"
```

and this to your crate root:

```rust
extern crate num;
```

## Releases

Release notes are available in [RELEASES.md](RELEASES.md).

## Compatibility

Most of the `num` crates are tested for rustc 1.8 and greater.
The exception is `num-derive` which requires at least rustc 1.15.
