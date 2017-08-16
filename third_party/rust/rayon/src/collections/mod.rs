//! This module contains the parallel iterator types for standard
//! collections. You will rarely need to interact with it directly
//! unless you have need to name one of the iterator types.

/// Convert an iterable collection into a parallel iterator by first
/// collecting into a temporary `Vec`, then iterating that.
macro_rules! into_par_vec {
    ($t:ty => $iter:ident<$($i:tt),*>, impl $($args:tt)*) => {
        impl $($args)* IntoParallelIterator for $t {
            type Item = <$t as IntoIterator>::Item;
            type Iter = $iter<$($i),*>;

            fn into_par_iter(self) -> Self::Iter {
                use std::iter::FromIterator;
                $iter { inner: Vec::from_iter(self).into_par_iter() }
            }
        }
    };
}

pub mod binary_heap;
pub mod btree_map;
pub mod btree_set;
pub mod hash_map;
pub mod hash_set;
pub mod linked_list;
pub mod vec_deque;
