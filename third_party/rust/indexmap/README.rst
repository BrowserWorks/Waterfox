indexmap
========

|build_status|_ |crates|_ |docs|_ |rustc|_

.. |crates| image:: https://img.shields.io/crates/v/indexmap.svg
.. _crates: https://crates.io/crates/indexmap

.. |build_status| image:: https://travis-ci.org/bluss/indexmap.svg
.. _build_status: https://travis-ci.org/bluss/indexmap

.. |docs| image:: https://docs.rs/indexmap/badge.svg
.. _docs: https://docs.rs/indexmap

.. |rustc| image:: https://img.shields.io/badge/rust-1.18%2B-orange.svg
.. _rustc: https://img.shields.io/badge/rust-1.18%2B-orange.svg

A safe, pure-Rust hash table which preserves insertion order.

This crate implements compact map and set data-structures,
where the iteration order of the keys is independent from their hash or
value. It preserves insertion order (except after removals), and it
allows lookup of entries by either hash table key or numerical index.

Note: this crate was originally released under the name ``ordermap``,
but it was renamed to ``indexmap`` to better reflect its features.

Background
==========

This was inspired by Python 3.6's new dict implementation (which remembers
the insertion order and is fast to iterate, and is compact in memory).

Some of those features were translated to Rust, and some were not. The result
was indexmap, a hash table that has following properties:

- Order is **independent of hash function** and hash values of keys.
- Fast to iterate.
- Indexed in compact space.
- Preserves insertion order **as long** as you don't call ``.remove()``.
- Uses robin hood hashing just like Rust's libstd ``HashMap`` used to do
  (before std switched to hashbrown).

  - It's the usual backwards shift deletion, but only on the index vector, so
    it's cheaper because it's moving less memory around.

Does not implement (Yet)
------------------------

- ``.reserve()`` exists but does not have a complete implementation

Performance
-----------

``IndexMap`` derives a couple of performance facts directly from how it is constructed,
which is roughly:

  Two vectors, the first, sparse, with hashes and key-value indices, and the
  second, dense, the key-value pairs.

- Iteration is very fast since it is on the dense key-values.
- Removal is fast since it moves memory areas only in the first vector,
  and uses a single swap in the second vector.
- Lookup is fast-ish because the hashes and indices are densely stored.
  Lookup also is slow-ish since hashes and key-value pairs are stored in
  separate places. (Visible when cpu caches size is limiting.)

- In practice, ``IndexMap`` has been tested out as the hashmap in rustc in PR45282_ and
  the performance was roughly on par across the whole workload. 
- If you want the properties of ``IndexMap``, or its strongest performance points
  fits your workload, it might be the best hash table implementation.

.. _PR45282: https://github.com/rust-lang/rust/pull/45282

Interesting Features
--------------------

- Insertion order is preserved (``.swap_remove()`` perturbs the order, like the method name says).
- Implements ``.pop() -> Option<(K, V)>`` in O(1) time.
- ``IndexMap::new()`` is empty and uses no allocation until you insert something.
- Lookup key-value pairs by index and vice versa.
- No ``unsafe``.
- Supports ``IndexMut``.


Where to go from here?
----------------------

- Ideas and PRs for how to implement insertion-order preserving remove (for example tombstones)
  are welcome. The plan is to split the crate into two hash table implementations
  a) the current compact index space version and b) the full insertion order version.


Ideas that we already did
-------------------------

- It can be an *indexable* ordered map in the current fashion
  (This was implemented in 0.2.0, for potential use as a graph datastructure).

- Idea for more cache efficient lookup (This was implemented in 0.1.2).

  Current ``indices: Vec<Pos>``. ``Pos`` is interpreted as ``(u32, u32)`` more
  or less when ``.raw_capacity()`` fits in 32 bits. ``Pos`` then stores both the lower
  half of the hash and the entry index.
  This means that the hash values in ``Bucket`` don't need to be accessed
  while scanning for an entry.


Recent Changes
==============

- 1.1.0

  - Added optional feature `"rayon"` that adds parallel iterator support
    to `IndexMap` and `IndexSet` using Rayon. This includes all the regular
    iterators in parallel versions, and parallel sort.

  - Implemented ``Clone`` for ``map::{Iter, Keys, Values}`` and
    ``set::{Difference, Intersection, Iter, SymmetricDifference, Union}``

  - Implemented ``Debug`` for ``map::{Entry, IntoIter, Iter, Keys, Values}`` and
    ``set::{Difference, Intersection, IntoIter, Iter, SymmetricDifference, Union}``

  - Serde trait ``IntoDeserializer`` are implemented for ``IndexMap`` and ``IndexSet``.

  - Minimum Rust version requirement increased to Rust 1.30 for development builds.

- 1.0.2

  - The new methods ``IndexMap::insert_full`` and ``IndexSet::insert_full`` are
    both like ``insert`` with the index included in the return value.

  - The new method ``Entry::and_modify`` can be used to modify occupied
    entries, matching the new methods of ``std`` maps in Rust 1.26.

  - The new method ``Entry::or_default`` inserts a default value in unoccupied
    entries, matching the new methods of ``std`` maps in Rust 1.28.

- 1.0.1

  - Document Rust version policy for the crate (see rustdoc)

- 1.0.0

  - This is the 1.0 release for ``indexmap``! (the crate and datastructure
    formerly known as “ordermap”)
  - ``OccupiedEntry::insert`` changed its signature, to use ``&mut self`` for
    the method receiver, matching the equivalent method for a standard
    ``HashMap``.  Thanks to @dtolnay for finding this bug.
  - The deprecated old names from ordermap were removed: ``OrderMap``,
    ``OrderSet``, ``ordermap!{}``, ``orderset!{}``. Use the new ``IndexMap``
    etc names instead.

- 0.4.1

  - Renamed crate to ``indexmap``; the ``ordermap`` crate is now deprecated
    and the types ``OrderMap/Set`` now have a deprecation notice.

- 0.4.0

  - This is the last release series for this ``ordermap`` under that name,
    because the crate is **going to be renamed** to ``indexmap`` (with types
    ``IndexMap``, ``IndexSet``) and no change in functionality!
  - The map and its associated structs moved into the ``map`` submodule of the
    crate, so that the map and set are symmetric

    + The iterators, ``Entry`` and other structs are now under ``ordermap::map::``

  - Internally refactored ``OrderMap<K, V, S>`` so that all the main algorithms
    (insertion, lookup, removal etc) that don't use the ``S`` parameter (the
    hasher) are compiled without depending on ``S``, which reduces generics bloat.

  - ``Entry<K, V>`` no longer has a type parameter ``S``, which is just like
    the standard ``HashMap``'s entry.

  - Minimum Rust version requirement increased to Rust 1.18

- 0.3.5

  - Documentation improvements

- 0.3.4

  - The ``.retain()`` methods for ``OrderMap`` and ``OrderSet`` now
    traverse the elements in order, and the retained elements **keep their order**
  - Added new methods ``.sort_by()``, ``.sort_keys()`` to ``OrderMap`` and
    ``.sort_by()``, ``.sort()`` to ``OrderSet``. These methods allow you to
    sort the maps in place efficiently.

- 0.3.3

  - Document insertion behaviour better by @lucab
  - Updated dependences (no feature changes) by @ignatenkobrain

- 0.3.2

  - Add ``OrderSet`` by @cuviper!
  - ``OrderMap::drain`` is now (too) a double ended iterator.

- 0.3.1

  - In all ordermap iterators, forward the ``collect`` method to the underlying
    iterator as well.
  - Add crates.io categories.

- 0.3.0

  - The methods ``get_pair``, ``get_pair_index`` were both replaced by
    ``get_full`` (and the same for the mutable case).
  - Method ``swap_remove_pair`` replaced by ``swap_remove_full``.
  - Add trait ``MutableKeys`` for opt-in mutable key access. Mutable key access
    is only possible through the methods of this extension trait.
  - Add new trait ``Equivalent`` for key equivalence. This extends the
    ``Borrow`` trait mechanism for ``OrderMap::get`` in a backwards compatible
    way, just some minor type inference related issues may become apparent.
    See `#10`__ for more information.
  - Implement ``Extend<(&K, &V)>`` by @xfix.

__ https://github.com/bluss/ordermap/pull/10

- 0.2.13

  - Fix deserialization to support custom hashers by @Techcable.
  - Add methods ``.index()`` on the entry types by @garro95.

- 0.2.12

  - Add methods ``.with_hasher()``, ``.hasher()``.

- 0.2.11

  - Support ``ExactSizeIterator`` for the iterators. By @Binero.
  - Use ``Box<[Pos]>`` internally, saving a word in the ``OrderMap`` struct.
  - Serde support, with crate feature ``"serde-1"``. By @xfix.

- 0.2.10

  - Add iterator ``.drain(..)`` by @stevej.

- 0.2.9

  - Add method ``.is_empty()`` by @overvenus.
  - Implement ``PartialEq, Eq`` by @overvenus.
  - Add method ``.sorted_by()``.

- 0.2.8

  - Add iterators ``.values()`` and ``.values_mut()``.
  - Fix compatibility with 32-bit platforms.

- 0.2.7

  - Add ``.retain()``.

- 0.2.6

  - Add ``OccupiedEntry::remove_entry`` and other minor entry methods,
    so that it now has all the features of ``HashMap``'s entries.

- 0.2.5

  - Improved ``.pop()`` slightly.

- 0.2.4

  - Improved performance of ``.insert()`` (`#3`__) by @pczarn.

__ https://github.com/bluss/ordermap/pull/3

- 0.2.3

  - Generalize ``Entry`` for now, so that it works on hashmaps with non-default
    hasher. However, there's a lingering compat issue since libstd ``HashMap``
    does not parameterize its entries by the hasher (``S`` typarm).
  - Special case some iterator methods like ``.nth()``.

- 0.2.2

  - Disable the verbose ``Debug`` impl by default.

- 0.2.1

  - Fix doc links and clarify docs.

- 0.2.0

  - Add more ``HashMap`` methods & compat with its API.
  - Experimental support for ``.entry()`` (the simplest parts of the API).
  - Add ``.reserve()`` (placeholder impl).
  - Add ``.remove()`` as synonym for ``.swap_remove()``.
  - Changed ``.insert()`` to swap value if the entry already exists, and
    return ``Option``.
  - Experimental support as an *indexed* hash map! Added methods
    ``.get_index()``, ``.get_index_mut()``, ``.swap_remove_index()``,
    ``.get_pair_index()``, ``.get_pair_index_mut()``.

- 0.1.2

  - Implement the 32/32 split idea for ``Pos`` which improves cache utilization
    and lookup performance.

- 0.1.1

  - Initial release.
