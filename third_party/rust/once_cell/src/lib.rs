/*!
# Overview

`once_cell` provides two new cell-like types, [`unsync::OnceCell`] and [`sync::OnceCell`]. A `OnceCell`
might store arbitrary non-`Copy` types, can be assigned to at most once and provides direct access
to the stored contents. In a nutshell, the API looks *roughly* like this:

```rust,ignore
impl<T> OnceCell<T> {
    fn new() -> OnceCell<T> { ... }
    fn set(&self, value: T) -> Result<(), T> { ... }
    fn get(&self) -> Option<&T> { ... }
}
```

Note that, like with [`RefCell`] and [`Mutex`], the `set` method requires only a shared reference.
Because of the single assignment restriction `get` can return a `&T` instead of `Ref<T>`
or `MutexGuard<T>`.

The `sync` flavor is thread-safe (that is, implements the [`Sync`] trait), while the `unsync` one is not.

[`unsync::OnceCell`]: unsync/struct.OnceCell.html
[`sync::OnceCell`]: sync/struct.ONceCell.html
[`RefCell`]: https://doc.rust-lang.org/std/cell/struct.RefCell.html
[`Mutex`]: https://doc.rust-lang.org/std/sync/struct.Mutex.html
[`Sync`]: https://doc.rust-lang.org/std/marker/trait.Sync.html

# Patterns

`OnceCell` might be useful for a variety of patterns.

## Safe Initialization of global data

```rust
use std::{env, io};

use once_cell::sync::OnceCell;

#[derive(Debug)]
pub struct Logger {
    // ...
}
static INSTANCE: OnceCell<Logger> = OnceCell::new();

impl Logger {
    pub fn global() -> &'static Logger {
        INSTANCE.get().expect("logger is not initialized")
    }

    fn from_cli(args: env::Args) -> Result<Logger, std::io::Error> {
       // ...
#      Ok(Logger {})
    }
}

fn main() {
    let logger = Logger::from_cli(env::args()).unwrap();
    INSTANCE.set(logger).unwrap();
    // use `Logger::global()` from now on
}
```

## Lazy initialized global data

This is essentially the `lazy_static!` macro, but without a macro.

```rust
use std::{sync::Mutex, collections::HashMap};

use once_cell::sync::OnceCell;

fn global_data() -> &'static Mutex<HashMap<i32, String>> {
    static INSTANCE: OnceCell<Mutex<HashMap<i32, String>>> = OnceCell::new();
    INSTANCE.get_or_init(|| {
        let mut m = HashMap::new();
        m.insert(13, "Spica".to_string());
        m.insert(74, "Hoyten".to_string());
        Mutex::new(m)
    })
}
```

There are also the [`sync::Lazy`] and [`unsync::Lazy`] convenience types to streamline this pattern:

```rust
use std::{sync::Mutex, collections::HashMap};
use once_cell::sync::Lazy;

static GLOBAL_DATA: Lazy<Mutex<HashMap<i32, String>>> = Lazy::new(|| {
    let mut m = HashMap::new();
    m.insert(13, "Spica".to_string());
    m.insert(74, "Hoyten".to_string());
    Mutex::new(m)
});

fn main() {
    println!("{:?}", GLOBAL_DATA.lock().unwrap());
}
```

[`sync::Lazy`]: sync/struct.Lazy.html
[`unsync::Lazy`]: unsync/struct.Lazy.html

## General purpose lazy evaluation

Unlike `lazy_static!`, `Lazy` works with local variables.

```rust
use once_cell::unsync::Lazy;

fn main() {
    let ctx = vec![1, 2, 3];
    let thunk = Lazy::new(|| {
        ctx.iter().sum::<i32>()
    });
    assert_eq!(*thunk, 6);
}
```

If you need a lazy field in a struct, you probably should use `OnceCell`
directly, because that will allow you to access `self` during initialization.

```rust
use std::{fs, path::PathBuf};

use once_cell::unsync::OnceCell;

struct Ctx {
    config_path: PathBuf,
    config: OnceCell<String>,
}

impl Ctx {
    pub fn get_config(&self) -> Result<&str, std::io::Error> {
        let cfg = self.config.get_or_try_init(|| {
            fs::read_to_string(&self.config_path)
        })?;
        Ok(cfg.as_str())
    }
}
```

## Building block

Naturally, it is  possible to build other abstractions on top of `OnceCell`.
For example, this is a `regex!` macro which takes a string literal and returns an
*expression* that evaluates to a `&'static Regex`:

```
macro_rules! regex {
    ($re:literal $(,)?) => {{
        static RE: once_cell::sync::OnceCell<regex::Regex> = once_cell::sync::OnceCell::new();
        RE.get_or_init(|| regex::Regex::new($re).unwrap())
    }};
}
```

This macro can be useful to avoid the "compile regex on every loop iteration" problem.

# Comparison with std

|`!Sync` types         | Access Mode            | Drawbacks                                     |
|----------------------|------------------------|-----------------------------------------------|
|`Cell<T>`             | `T`                    | requires `T: Copy` for `get`                  |
|`RefCell<T>`          | `RefMut<T>` / `Ref<T>` | may panic at runtime                          |
|`unsync::OnceCell<T>` | `&T`                   | assignable only once                          |

|`Sync` types          | Access Mode            | Drawbacks                                     |
|----------------------|------------------------|-----------------------------------------------|
|`AtomicT`             | `T`                    | works only with certain `Copy` types          |
|`Mutex<T>`            | `MutexGuard<T>`        | may deadlock at runtime, may block the thread |
|`sync::OnceCell<T>`   | `&T`                   | assignable only once, may block the thread    |

Technically, calling `get_or_init` will also cause a panic or a deadlock if it recursively calls
itself. However, because the assignment can happen only once, such cases should be more rare than
equivalents with `RefCell` and `Mutex`.

# Minimum Supported `rustc` Version

This crate's minimum supported `rustc` version is `1.31.1` (or `1.36.0` with the
`parking_lot` feature enabled).

If only the `std` feature is enabled, MSRV will be updated conservatively.
When using other features, like `parking_lot`, MSRV might be updated more frequently, up to the latest stable.
In both cases, increasing MSRV is *not* considered a semver-breaking change.

# Implementation details

The implementation is based on the [`lazy_static`](https://github.com/rust-lang-nursery/lazy-static.rs/)
and [`lazy_cell`](https://github.com/indiv0/lazycell/) crates and [`std::sync::Once`]. In some sense,
`once_cell` just streamlines and unifies those APIs.

To implement a sync flavor of `OnceCell`, this crates uses either a custom re-implementation of
`std::sync::Once` or `parking_lot::Mutex`. This is controlled by the `parking_lot` feature, which
is enabled by default. Performance is the same for both cases, but the `parking_lot` based `OnceCell<T>`
is smaller by up to 16 bytes.

This crate uses `unsafe`.

[`std::sync::Once`]: https://doc.rust-lang.org/std/sync/struct.Once.html

# F.A.Q.

**Should I use lazy_static or once_cell?**

To the first approximation, `once_cell` is both more flexible and more convenient than `lazy_static`
and should be preferred.

Unlike `once_cell`, `lazy_static` supports spinlock-based implementation of blocking which works with
`#![no_std]`.

`lazy_static` has received significantly more real world testing, but `once_cell` is also a widely
used crate.

**Should I use the sync or unsync flavor?**

Because Rust compiler checks thread safety for you, it's impossible to accidentally use `unsync` where
`sync` is required. So, use `unsync` in single-threaded code and `sync` in multi-threaded. It's easy
to switch between the two if code becomes multi-threaded later.

At the moment, `unsync` has an additional benefit that reentrant initialization causes a panic, which
might be easier to debug than a deadlock.

# Related crates

* [double-checked-cell](https://github.com/niklasf/double-checked-cell)
* [lazy-init](https://crates.io/crates/lazy-init)
* [lazycell](https://crates.io/crates/lazycell)
* [mitochondria](https://crates.io/crates/mitochondria)
* [lazy_static](https://crates.io/crates/lazy_static)

*/

#![cfg_attr(not(feature = "std"), no_std)]

#[cfg(feature = "std")]
#[cfg(feature = "parking_lot")]
#[path = "imp_pl.rs"]
mod imp;

#[cfg(feature = "std")]
#[cfg(not(feature = "parking_lot"))]
#[path = "imp_std.rs"]
mod imp;

pub mod unsync {
    use core::{
        cell::{Cell, UnsafeCell},
        fmt, mem,
        ops::{Deref, DerefMut},
    };

    #[cfg(feature = "std")]
    use std::panic::{RefUnwindSafe, UnwindSafe};

    /// A cell which can be written to only once. It is not thread safe.
    ///
    /// Unlike [`std::cell::RefCell`], a `OnceCell` provides simple `&`
    /// references to the contents.
    ///
    /// [`std::cell::RefCell`]: https://doc.rust-lang.org/std/cell/struct.RefCell.html
    ///
    /// # Example
    /// ```
    /// use once_cell::unsync::OnceCell;
    ///
    /// let cell = OnceCell::new();
    /// assert!(cell.get().is_none());
    ///
    /// let value: &String = cell.get_or_init(|| {
    ///     "Hello, World!".to_string()
    /// });
    /// assert_eq!(value, "Hello, World!");
    /// assert!(cell.get().is_some());
    /// ```
    pub struct OnceCell<T> {
        // Invariant: written to at most once.
        inner: UnsafeCell<Option<T>>,
    }

    // Similarly to a `Sync` bound on `sync::OnceCell`, we can use
    // `&unsync::OnceCell` to sneak a `T` through `catch_unwind`,
    // by initializing the cell in closure and extracting the value in the
    // `Drop`.
    #[cfg(feature = "std")]
    impl<T: RefUnwindSafe + UnwindSafe> RefUnwindSafe for OnceCell<T> {}
    #[cfg(feature = "std")]
    impl<T: UnwindSafe> UnwindSafe for OnceCell<T> {}

    impl<T> Default for OnceCell<T> {
        fn default() -> Self {
            Self::new()
        }
    }

    impl<T: fmt::Debug> fmt::Debug for OnceCell<T> {
        fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
            match self.get() {
                Some(v) => f.debug_tuple("OnceCell").field(v).finish(),
                None => f.write_str("OnceCell(Uninit)"),
            }
        }
    }

    impl<T: Clone> Clone for OnceCell<T> {
        fn clone(&self) -> OnceCell<T> {
            let res = OnceCell::new();
            if let Some(value) = self.get() {
                match res.set(value.clone()) {
                    Ok(()) => (),
                    Err(_) => unreachable!(),
                }
            }
            res
        }
    }

    impl<T: PartialEq> PartialEq for OnceCell<T> {
        fn eq(&self, other: &Self) -> bool {
            self.get() == other.get()
        }
    }

    impl<T: Eq> Eq for OnceCell<T> {}

    impl<T> From<T> for OnceCell<T> {
        fn from(value: T) -> Self {
            OnceCell { inner: UnsafeCell::new(Some(value)) }
        }
    }

    impl<T> OnceCell<T> {
        /// Creates a new empty cell.
        pub const fn new() -> OnceCell<T> {
            OnceCell { inner: UnsafeCell::new(None) }
        }

        /// Gets a reference to the underlying value.
        ///
        /// Returns `None` if the cell is empty.
        pub fn get(&self) -> Option<&T> {
            // Safe due to `inner`'s invariant
            unsafe { &*self.inner.get() }.as_ref()
        }

        /// Gets a mutable reference to the underlying value.
        ///
        /// Returns `None` if the cell is empty.
        pub fn get_mut(&mut self) -> Option<&mut T> {
            // Safe because we have unique access
            unsafe { &mut *self.inner.get() }.as_mut()
        }

        /// Sets the contents of this cell to `value`.
        ///
        /// Returns `Ok(())` if the cell was empty and `Err(value)` if it was
        /// full.
        ///
        /// # Example
        /// ```
        /// use once_cell::unsync::OnceCell;
        ///
        /// let cell = OnceCell::new();
        /// assert!(cell.get().is_none());
        ///
        /// assert_eq!(cell.set(92), Ok(()));
        /// assert_eq!(cell.set(62), Err(62));
        ///
        /// assert!(cell.get().is_some());
        /// ```
        pub fn set(&self, value: T) -> Result<(), T> {
            let slot = unsafe { &*self.inner.get() };
            if slot.is_some() {
                return Err(value);
            }
            let slot = unsafe { &mut *self.inner.get() };
            // This is the only place where we set the slot, no races
            // due to reentrancy/concurrency are possible, and we've
            // checked that slot is currently `None`, so this write
            // maintains the `inner`'s invariant.
            *slot = Some(value);
            Ok(())
        }

        /// Gets the contents of the cell, initializing it with `f`
        /// if the cell was empty.
        ///
        /// # Panics
        ///
        /// If `f` panics, the panic is propagated to the caller, and the cell
        /// remains uninitialized.
        ///
        /// It is an error to reentrantly initialize the cell from `f`. Doing
        /// so results in a panic.
        ///
        /// # Example
        /// ```
        /// use once_cell::unsync::OnceCell;
        ///
        /// let cell = OnceCell::new();
        /// let value = cell.get_or_init(|| 92);
        /// assert_eq!(value, &92);
        /// let value = cell.get_or_init(|| unreachable!());
        /// assert_eq!(value, &92);
        /// ```
        pub fn get_or_init<F>(&self, f: F) -> &T
        where
            F: FnOnce() -> T,
        {
            enum Void {}
            match self.get_or_try_init(|| Ok::<T, Void>(f())) {
                Ok(val) => val,
                Err(void) => match void {},
            }
        }

        /// Gets the contents of the cell, initializing it with `f` if
        /// the cell was empty. If the cell was empty and `f` failed, an
        /// error is returned.
        ///
        /// # Panics
        ///
        /// If `f` panics, the panic is propagated to the caller, and the cell
        /// remains uninitialized.
        ///
        /// It is an error to reentrantly initialize the cell from `f`. Doing
        /// so results in a panic.
        ///
        /// # Example
        /// ```
        /// use once_cell::unsync::OnceCell;
        ///
        /// let cell = OnceCell::new();
        /// assert_eq!(cell.get_or_try_init(|| Err(())), Err(()));
        /// assert!(cell.get().is_none());
        /// let value = cell.get_or_try_init(|| -> Result<i32, ()> {
        ///     Ok(92)
        /// });
        /// assert_eq!(value, Ok(&92));
        /// assert_eq!(cell.get(), Some(&92))
        /// ```
        pub fn get_or_try_init<F, E>(&self, f: F) -> Result<&T, E>
        where
            F: FnOnce() -> Result<T, E>,
        {
            if let Some(val) = self.get() {
                return Ok(val);
            }
            let val = f()?;
            // Note that *some* forms of reentrant initialization might lead to
            // UB (see `reentrant_init` test). I believe that just removing this
            // `assert`, while keeping `set/get` would be sound, but it seems
            // better to panic, rather than to silently use an old value.
            assert!(self.set(val).is_ok(), "reentrant init");
            Ok(self.get().unwrap())
        }

        /// Takes the value out of this `OnceCell`, moving it back to an uninitialized state.
        ///
        /// Has no effect and returns `None` if the `OnceCell` hasn't been initialized.
        ///
        /// # Examples
        ///
        /// ```
        /// use once_cell::unsync::OnceCell;
        ///
        /// let mut cell: OnceCell<String> = OnceCell::new();
        /// assert_eq!(cell.take(), None);
        ///
        /// let mut cell = OnceCell::new();
        /// cell.set("hello".to_string()).unwrap();
        /// assert_eq!(cell.take(), Some("hello".to_string()));
        /// assert_eq!(cell.get(), None);
        /// ```
        pub fn take(&mut self) -> Option<T> {
            mem::replace(self, Self::default()).into_inner()
        }

        /// Consumes the `OnceCell`, returning the wrapped value.
        ///
        /// Returns `None` if the cell was empty.
        ///
        /// # Examples
        ///
        /// ```
        /// use once_cell::unsync::OnceCell;
        ///
        /// let cell: OnceCell<String> = OnceCell::new();
        /// assert_eq!(cell.into_inner(), None);
        ///
        /// let cell = OnceCell::new();
        /// cell.set("hello".to_string()).unwrap();
        /// assert_eq!(cell.into_inner(), Some("hello".to_string()));
        /// ```
        pub fn into_inner(self) -> Option<T> {
            // Because `into_inner` takes `self` by value, the compiler statically verifies
            // that it is not currently borrowed. So it is safe to move out `Option<T>`.
            self.inner.into_inner()
        }
    }

    /// A value which is initialized on the first access.
    ///
    /// # Example
    /// ```
    /// use once_cell::unsync::Lazy;
    ///
    /// let lazy: Lazy<i32> = Lazy::new(|| {
    ///     println!("initializing");
    ///     92
    /// });
    /// println!("ready");
    /// println!("{}", *lazy);
    /// println!("{}", *lazy);
    ///
    /// // Prints:
    /// //   ready
    /// //   initializing
    /// //   92
    /// //   92
    /// ```
    pub struct Lazy<T, F = fn() -> T> {
        cell: OnceCell<T>,
        init: Cell<Option<F>>,
    }

    #[cfg(feature = "std")]
    impl<T, F: RefUnwindSafe> RefUnwindSafe for Lazy<T, F> where OnceCell<T>: RefUnwindSafe {}

    impl<T: fmt::Debug, F> fmt::Debug for Lazy<T, F> {
        fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
            f.debug_struct("Lazy").field("cell", &self.cell).field("init", &"..").finish()
        }
    }

    impl<T, F> Lazy<T, F> {
        /// Creates a new lazy value with the given initializing function.
        ///
        /// # Example
        /// ```
        /// # fn main() {
        /// use once_cell::unsync::Lazy;
        ///
        /// let hello = "Hello, World!".to_string();
        ///
        /// let lazy = Lazy::new(|| hello.to_uppercase());
        ///
        /// assert_eq!(&*lazy, "HELLO, WORLD!");
        /// # }
        /// ```
        pub const fn new(init: F) -> Lazy<T, F> {
            Lazy { cell: OnceCell::new(), init: Cell::new(Some(init)) }
        }
    }

    impl<T, F: FnOnce() -> T> Lazy<T, F> {
        /// Forces the evaluation of this lazy value and returns a reference to
        /// the result.
        ///
        /// This is equivalent to the `Deref` impl, but is explicit.
        ///
        /// # Example
        /// ```
        /// use once_cell::unsync::Lazy;
        ///
        /// let lazy = Lazy::new(|| 92);
        ///
        /// assert_eq!(Lazy::force(&lazy), &92);
        /// assert_eq!(&*lazy, &92);
        /// ```
        pub fn force(this: &Lazy<T, F>) -> &T {
            this.cell.get_or_init(|| match this.init.take() {
                Some(f) => f(),
                None => panic!("Lazy instance has previously been poisoned"),
            })
        }
    }

    impl<T, F: FnOnce() -> T> Deref for Lazy<T, F> {
        type Target = T;
        fn deref(&self) -> &T {
            Lazy::force(self)
        }
    }

    impl<T, F: FnOnce() -> T> DerefMut for Lazy<T, F> {
        fn deref_mut(&mut self) -> &mut T {
            Lazy::force(self);
            self.cell.get_mut().unwrap_or_else(|| unreachable!())
        }
    }

    impl<T: Default> Default for Lazy<T> {
        /// Creates a new lazy value using `Default` as the initializing function.
        fn default() -> Lazy<T> {
            Lazy::new(T::default)
        }
    }
}

#[cfg(feature = "std")]
pub mod sync {
    use std::{
        cell::Cell,
        fmt, mem,
        ops::{Deref, DerefMut},
        panic::RefUnwindSafe,
    };

    use crate::imp::OnceCell as Imp;

    /// A thread-safe cell which can be written to only once.
    ///
    /// `OnceCell` provides `&` references to the contents without RAII guards.
    ///
    /// Reading a non-`None` value out of `OnceCell` establishes a
    /// happens-before relationship with a corresponding write. For example, if
    /// thread A initializes the cell with `get_or_init(f)`, and thread B
    /// subsequently reads the result of this call, B also observes all the side
    /// effects of `f`.
    ///
    /// # Example
    /// ```
    /// use once_cell::sync::OnceCell;
    ///
    /// static CELL: OnceCell<String> = OnceCell::new();
    /// assert!(CELL.get().is_none());
    ///
    /// std::thread::spawn(|| {
    ///     let value: &String = CELL.get_or_init(|| {
    ///         "Hello, World!".to_string()
    ///     });
    ///     assert_eq!(value, "Hello, World!");
    /// }).join().unwrap();
    ///
    /// let value: Option<&String> = CELL.get();
    /// assert!(value.is_some());
    /// assert_eq!(value.unwrap().as_str(), "Hello, World!");
    /// ```
    pub struct OnceCell<T>(Imp<T>);

    impl<T> Default for OnceCell<T> {
        fn default() -> OnceCell<T> {
            OnceCell::new()
        }
    }

    impl<T: fmt::Debug> fmt::Debug for OnceCell<T> {
        fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
            match self.get() {
                Some(v) => f.debug_tuple("OnceCell").field(v).finish(),
                None => f.write_str("OnceCell(Uninit)"),
            }
        }
    }

    impl<T: Clone> Clone for OnceCell<T> {
        fn clone(&self) -> OnceCell<T> {
            let res = OnceCell::new();
            if let Some(value) = self.get() {
                match res.set(value.clone()) {
                    Ok(()) => (),
                    Err(_) => unreachable!(),
                }
            }
            res
        }
    }

    impl<T> From<T> for OnceCell<T> {
        fn from(value: T) -> Self {
            let cell = Self::new();
            cell.get_or_init(|| value);
            cell
        }
    }

    impl<T: PartialEq> PartialEq for OnceCell<T> {
        fn eq(&self, other: &OnceCell<T>) -> bool {
            self.get() == other.get()
        }
    }

    impl<T: Eq> Eq for OnceCell<T> {}

    impl<T> OnceCell<T> {
        /// Creates a new empty cell.
        pub const fn new() -> OnceCell<T> {
            OnceCell(Imp::new())
        }

        /// Gets the reference to the underlying value.
        ///
        /// Returns `None` if the cell is empty, or being initialized. This
        /// method never blocks.
        pub fn get(&self) -> Option<&T> {
            if self.0.is_initialized() {
                // Safe b/c value is initialized.
                Some(unsafe { self.get_unchecked() })
            } else {
                None
            }
        }

        /// Gets the mutable reference to the underlying value.
        ///
        /// Returns `None` if the cell is empty.
        pub fn get_mut(&mut self) -> Option<&mut T> {
            self.0.get_mut()
        }

        /// Get the reference to the underlying value, without checking if the
        /// cell is initialized.
        ///
        /// # Safety
        ///
        /// Caller must ensure that the cell is in initialized state, and that
        /// the contents are acquired by (synchronized to) this thread.
        pub unsafe fn get_unchecked(&self) -> &T {
            self.0.get_unchecked()
        }

        /// Sets the contents of this cell to `value`.
        ///
        /// Returns `Ok(())` if the cell was empty and `Err(value)` if it was
        /// full.
        ///
        /// # Example
        ///
        /// ```
        /// use once_cell::sync::OnceCell;
        ///
        /// static CELL: OnceCell<i32> = OnceCell::new();
        ///
        /// fn main() {
        ///     assert!(CELL.get().is_none());
        ///
        ///     std::thread::spawn(|| {
        ///         assert_eq!(CELL.set(92), Ok(()));
        ///     }).join().unwrap();
        ///
        ///     assert_eq!(CELL.set(62), Err(62));
        ///     assert_eq!(CELL.get(), Some(&92));
        /// }
        /// ```
        pub fn set(&self, value: T) -> Result<(), T> {
            let mut value = Some(value);
            self.get_or_init(|| value.take().unwrap());
            match value {
                None => Ok(()),
                Some(value) => Err(value),
            }
        }

        /// Gets the contents of the cell, initializing it with `f` if the cell
        /// was empty.
        ///
        /// Many threads may call `get_or_init` concurrently with different
        /// initializing functions, but it is guaranteed that only one function
        /// will be executed.
        ///
        /// # Panics
        ///
        /// If `f` panics, the panic is propagated to the caller, and the cell
        /// remains uninitialized.
        ///
        /// It is an error to reentrantly initialize the cell from `f`. The
        /// exact outcome is unspecified. Current implementation deadlocks, but
        /// this may be changed to a panic in the future.
        ///
        /// # Example
        /// ```
        /// use once_cell::sync::OnceCell;
        ///
        /// let cell = OnceCell::new();
        /// let value = cell.get_or_init(|| 92);
        /// assert_eq!(value, &92);
        /// let value = cell.get_or_init(|| unreachable!());
        /// assert_eq!(value, &92);
        /// ```
        pub fn get_or_init<F>(&self, f: F) -> &T
        where
            F: FnOnce() -> T,
        {
            enum Void {}
            match self.get_or_try_init(|| Ok::<T, Void>(f())) {
                Ok(val) => val,
                Err(void) => match void {},
            }
        }

        /// Gets the contents of the cell, initializing it with `f` if
        /// the cell was empty. If the cell was empty and `f` failed, an
        /// error is returned.
        ///
        /// # Panics
        ///
        /// If `f` panics, the panic is propagated to the caller, and
        /// the cell remains uninitialized.
        ///
        /// It is an error to reentrantly initialize the cell from `f`.
        /// The exact outcome is unspecified. Current implementation
        /// deadlocks, but this may be changed to a panic in the future.
        ///
        /// # Example
        /// ```
        /// use once_cell::sync::OnceCell;
        ///
        /// let cell = OnceCell::new();
        /// assert_eq!(cell.get_or_try_init(|| Err(())), Err(()));
        /// assert!(cell.get().is_none());
        /// let value = cell.get_or_try_init(|| -> Result<i32, ()> {
        ///     Ok(92)
        /// });
        /// assert_eq!(value, Ok(&92));
        /// assert_eq!(cell.get(), Some(&92))
        /// ```
        pub fn get_or_try_init<F, E>(&self, f: F) -> Result<&T, E>
        where
            F: FnOnce() -> Result<T, E>,
        {
            // Fast path check
            if let Some(value) = self.get() {
                return Ok(value);
            }
            self.0.initialize(f)?;

            // Safe b/c value is initialized.
            debug_assert!(self.0.is_initialized());
            Ok(unsafe { self.get_unchecked() })
        }

        /// Takes the value out of this `OnceCell`, moving it back to an uninitialized state.
        ///
        /// Has no effect and returns `None` if the `OnceCell` hasn't been initialized.
        ///
        /// # Examples
        ///
        /// ```
        /// use once_cell::sync::OnceCell;
        ///
        /// let mut cell: OnceCell<String> = OnceCell::new();
        /// assert_eq!(cell.take(), None);
        ///
        /// let mut cell = OnceCell::new();
        /// cell.set("hello".to_string()).unwrap();
        /// assert_eq!(cell.take(), Some("hello".to_string()));
        /// assert_eq!(cell.get(), None);
        /// ```
        pub fn take(&mut self) -> Option<T> {
            mem::replace(self, Self::default()).into_inner()
        }

        /// Consumes the `OnceCell`, returning the wrapped value. Returns
        /// `None` if the cell was empty.
        ///
        /// # Examples
        ///
        /// ```
        /// use once_cell::sync::OnceCell;
        ///
        /// let cell: OnceCell<String> = OnceCell::new();
        /// assert_eq!(cell.into_inner(), None);
        ///
        /// let cell = OnceCell::new();
        /// cell.set("hello".to_string()).unwrap();
        /// assert_eq!(cell.into_inner(), Some("hello".to_string()));
        /// ```
        pub fn into_inner(self) -> Option<T> {
            self.0.into_inner()
        }
    }

    /// A value which is initialized on the first access.
    ///
    /// This type is thread-safe and can be used in statics.
    ///
    /// # Example
    ///
    /// ```
    /// use std::collections::HashMap;
    ///
    /// use once_cell::sync::Lazy;
    ///
    /// static HASHMAP: Lazy<HashMap<i32, String>> = Lazy::new(|| {
    ///     println!("initializing");
    ///     let mut m = HashMap::new();
    ///     m.insert(13, "Spica".to_string());
    ///     m.insert(74, "Hoyten".to_string());
    ///     m
    /// });
    ///
    /// fn main() {
    ///     println!("ready");
    ///     std::thread::spawn(|| {
    ///         println!("{:?}", HASHMAP.get(&13));
    ///     }).join().unwrap();
    ///     println!("{:?}", HASHMAP.get(&74));
    ///
    ///     // Prints:
    ///     //   ready
    ///     //   initializing
    ///     //   Some("Spica")
    ///     //   Some("Hoyten")
    /// }
    /// ```
    pub struct Lazy<T, F = fn() -> T> {
        cell: OnceCell<T>,
        init: Cell<Option<F>>,
    }

    impl<T: fmt::Debug, F> fmt::Debug for Lazy<T, F> {
        fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
            f.debug_struct("Lazy").field("cell", &self.cell).field("init", &"..").finish()
        }
    }

    // We never create a `&F` from a `&Lazy<T, F>` so it is fine
    // to not impl `Sync` for `F`
    // we do create a `&mut Option<F>` in `force`, but this is
    // properly synchronized, so it only happens once
    // so it also does not contribute to this impl.
    unsafe impl<T, F: Send> Sync for Lazy<T, F> where OnceCell<T>: Sync {}
    // auto-derived `Send` impl is OK.

    #[cfg(feature = "std")]
    impl<T, F: RefUnwindSafe> RefUnwindSafe for Lazy<T, F> where OnceCell<T>: RefUnwindSafe {}

    impl<T, F> Lazy<T, F> {
        /// Creates a new lazy value with the given initializing
        /// function.
        pub const fn new(f: F) -> Lazy<T, F> {
            Lazy { cell: OnceCell::new(), init: Cell::new(Some(f)) }
        }
    }

    impl<T, F: FnOnce() -> T> Lazy<T, F> {
        /// Forces the evaluation of this lazy value and
        /// returns a reference to the result. This is equivalent
        /// to the `Deref` impl, but is explicit.
        ///
        /// # Example
        /// ```
        /// use once_cell::sync::Lazy;
        ///
        /// let lazy = Lazy::new(|| 92);
        ///
        /// assert_eq!(Lazy::force(&lazy), &92);
        /// assert_eq!(&*lazy, &92);
        /// ```
        pub fn force(this: &Lazy<T, F>) -> &T {
            this.cell.get_or_init(|| match this.init.take() {
                Some(f) => f(),
                None => panic!("Lazy instance has previously been poisoned"),
            })
        }
    }

    impl<T, F: FnOnce() -> T> Deref for Lazy<T, F> {
        type Target = T;
        fn deref(&self) -> &T {
            Lazy::force(self)
        }
    }

    impl<T, F: FnOnce() -> T> DerefMut for Lazy<T, F> {
        fn deref_mut(&mut self) -> &mut T {
            Lazy::force(self);
            self.cell.get_mut().unwrap_or_else(|| unreachable!())
        }
    }

    impl<T: Default> Default for Lazy<T> {
        /// Creates a new lazy value using `Default` as the initializing function.
        fn default() -> Lazy<T> {
            Lazy::new(T::default)
        }
    }

    /// ```compile_fail
    /// struct S(*mut ());
    /// unsafe impl Sync for S {}
    ///
    /// fn share<T: Sync>(_: &T) {}
    /// share(&once_cell::sync::OnceCell::<S>::new());
    /// ```
    ///
    /// ```compile_fail
    /// struct S(*mut ());
    /// unsafe impl Sync for S {}
    ///
    /// fn share<T: Sync>(_: &T) {}
    /// share(&once_cell::sync::Lazy::<S>::new(|| unimplemented!()));
    /// ```
    fn _dummy() {}
}
