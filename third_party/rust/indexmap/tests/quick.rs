
extern crate indexmap;
extern crate itertools;
#[macro_use]
extern crate quickcheck;
extern crate rand;

extern crate fnv;

use indexmap::IndexMap;
use itertools::Itertools;

use quickcheck::Arbitrary;
use quickcheck::Gen;

use rand::Rng;

use fnv::FnvHasher;
use std::hash::{BuildHasher, BuildHasherDefault};
type FnvBuilder = BuildHasherDefault<FnvHasher>;
type OrderMapFnv<K, V> = IndexMap<K, V, FnvBuilder>;

use std::collections::HashSet;
use std::collections::HashMap;
use std::iter::FromIterator;
use std::hash::Hash;
use std::fmt::Debug;
use std::ops::Deref;
use std::cmp::min;


use indexmap::map::Entry as OEntry;
use std::collections::hash_map::Entry as HEntry;


fn set<'a, T: 'a, I>(iter: I) -> HashSet<T>
    where I: IntoIterator<Item=&'a T>,
    T: Copy + Hash + Eq
{
    iter.into_iter().cloned().collect()
}

fn indexmap<'a, T: 'a, I>(iter: I) -> IndexMap<T, ()>
    where I: IntoIterator<Item=&'a T>,
          T: Copy + Hash + Eq,
{
    IndexMap::from_iter(iter.into_iter().cloned().map(|k| (k, ())))
}

quickcheck! {
    fn contains(insert: Vec<u32>) -> bool {
        let mut map = IndexMap::new();
        for &key in &insert {
            map.insert(key, ());
        }
        insert.iter().all(|&key| map.get(&key).is_some())
    }

    fn contains_not(insert: Vec<u8>, not: Vec<u8>) -> bool {
        let mut map = IndexMap::new();
        for &key in &insert {
            map.insert(key, ());
        }
        let nots = &set(&not) - &set(&insert);
        nots.iter().all(|&key| map.get(&key).is_none())
    }

    fn insert_remove(insert: Vec<u8>, remove: Vec<u8>) -> bool {
        let mut map = IndexMap::new();
        for &key in &insert {
            map.insert(key, ());
        }
        for &key in &remove {
            map.swap_remove(&key);
        }
        let elements = &set(&insert) - &set(&remove);
        map.len() == elements.len() && map.iter().count() == elements.len() &&
            elements.iter().all(|k| map.get(k).is_some())
    }

    fn insertion_order(insert: Vec<u32>) -> bool {
        let mut map = IndexMap::new();
        for &key in &insert {
            map.insert(key, ());
        }
        itertools::assert_equal(insert.iter().unique(), map.keys());
        true
    }

    fn pop(insert: Vec<u8>) -> bool {
        let mut map = IndexMap::new();
        for &key in &insert {
            map.insert(key, ());
        }
        let mut pops = Vec::new();
        while let Some((key, _v)) = map.pop() {
            pops.push(key);
        }
        pops.reverse();

        itertools::assert_equal(insert.iter().unique(), &pops);
        true
    }

    fn with_cap(cap: usize) -> bool {
        let map: IndexMap<u8, u8> = IndexMap::with_capacity(cap);
        println!("wish: {}, got: {} (diff: {})", cap, map.capacity(), map.capacity() as isize - cap as isize);
        map.capacity() >= cap
    }

    fn drain(insert: Vec<u8>) -> bool {
        let mut map = IndexMap::new();
        for &key in &insert {
            map.insert(key, ());
        }
        let mut clone = map.clone();
        let drained = clone.drain(..);
        for (key, _) in drained {
            map.remove(&key);
        }
        map.is_empty()
    }
}

use Op::*;
#[derive(Copy, Clone, Debug)]
enum Op<K, V> {
    Add(K, V),
    Remove(K),
    AddEntry(K, V),
    RemoveEntry(K),
}

impl<K, V> Arbitrary for Op<K, V>
    where K: Arbitrary,
          V: Arbitrary,
{
    fn arbitrary<G: Gen>(g: &mut G) -> Self {
        match g.gen::<u32>() % 4 {
            0 => Add(K::arbitrary(g), V::arbitrary(g)),
            1 => AddEntry(K::arbitrary(g), V::arbitrary(g)),
            2 => Remove(K::arbitrary(g)),
            _ => RemoveEntry(K::arbitrary(g)),
        }
    }
}

fn do_ops<K, V, S>(ops: &[Op<K, V>], a: &mut IndexMap<K, V, S>, b: &mut HashMap<K, V>)
    where K: Hash + Eq + Clone,
          V: Clone,
          S: BuildHasher,
{
    for op in ops {
        match *op {
            Add(ref k, ref v) => {
                a.insert(k.clone(), v.clone());
                b.insert(k.clone(), v.clone());
            }
            AddEntry(ref k, ref v) => {
                a.entry(k.clone()).or_insert(v.clone());
                b.entry(k.clone()).or_insert(v.clone());
            }
            Remove(ref k) => {
                a.swap_remove(k);
                b.remove(k);
            }
            RemoveEntry(ref k) => {
                match a.entry(k.clone()) {
                    OEntry::Occupied(ent) => { ent.remove_entry(); },
                    _ => { }
                }
                match b.entry(k.clone()) {
                    HEntry::Occupied(ent) => { ent.remove_entry(); },
                    _ => { }
                }
            }
        }
        //println!("{:?}", a);
    }
}

fn assert_maps_equivalent<K, V>(a: &IndexMap<K, V>, b: &HashMap<K, V>) -> bool
    where K: Hash + Eq + Debug,
          V: Eq + Debug,
{
    assert_eq!(a.len(), b.len());
    assert_eq!(a.iter().next().is_some(), b.iter().next().is_some());
    for key in a.keys() {
        assert!(b.contains_key(key), "b does not contain {:?}", key);
    }
    for key in b.keys() {
        assert!(a.get(key).is_some(), "a does not contain {:?}", key);
    }
    for key in a.keys() {
        assert_eq!(a[key], b[key]);
    }
    true
}

quickcheck! {
    fn operations_i8(ops: Large<Vec<Op<i8, i8>>>) -> bool {
        let mut map = IndexMap::new();
        let mut reference = HashMap::new();
        do_ops(&ops, &mut map, &mut reference);
        assert_maps_equivalent(&map, &reference)
    }

    fn operations_string(ops: Vec<Op<Alpha, i8>>) -> bool {
        let mut map = IndexMap::new();
        let mut reference = HashMap::new();
        do_ops(&ops, &mut map, &mut reference);
        assert_maps_equivalent(&map, &reference)
    }

    fn keys_values(ops: Large<Vec<Op<i8, i8>>>) -> bool {
        let mut map = IndexMap::new();
        let mut reference = HashMap::new();
        do_ops(&ops, &mut map, &mut reference);
        let mut visit = IndexMap::new();
        for (k, v) in map.keys().zip(map.values()) {
            assert_eq!(&map[k], v);
            assert!(!visit.contains_key(k));
            visit.insert(*k, *v);
        }
        assert_eq!(visit.len(), reference.len());
        true
    }

    fn keys_values_mut(ops: Large<Vec<Op<i8, i8>>>) -> bool {
        let mut map = IndexMap::new();
        let mut reference = HashMap::new();
        do_ops(&ops, &mut map, &mut reference);
        let mut visit = IndexMap::new();
        let keys = Vec::from_iter(map.keys().cloned());
        for (k, v) in keys.iter().zip(map.values_mut()) {
            assert_eq!(&reference[k], v);
            assert!(!visit.contains_key(k));
            visit.insert(*k, *v);
        }
        assert_eq!(visit.len(), reference.len());
        true
    }

    fn equality(ops1: Vec<Op<i8, i8>>, removes: Vec<usize>) -> bool {
        let mut map = IndexMap::new();
        let mut reference = HashMap::new();
        do_ops(&ops1, &mut map, &mut reference);
        let mut ops2 = ops1.clone();
        for &r in &removes {
            if !ops2.is_empty() {
                let i = r % ops2.len();
                ops2.remove(i);
            }
        }
        let mut map2 = OrderMapFnv::default();
        let mut reference2 = HashMap::new();
        do_ops(&ops2, &mut map2, &mut reference2);
        assert_eq!(map == map2, reference == reference2);
        true
    }

    fn retain_ordered(keys: Large<Vec<i8>>, remove: Large<Vec<i8>>) -> () {
        let mut map = indexmap(keys.iter());
        let initial_map = map.clone(); // deduplicated in-order input
        let remove_map = indexmap(remove.iter());
        let keys_s = set(keys.iter());
        let remove_s = set(remove.iter());
        let answer = &keys_s - &remove_s;
        map.retain(|k, _| !remove_map.contains_key(k));

        // check the values
        assert_eq!(map.len(), answer.len());
        for key in &answer {
            assert!(map.contains_key(key));
        }
        // check the order
        itertools::assert_equal(map.keys(), initial_map.keys().filter(|&k| !remove_map.contains_key(k)));
    }

    fn sort_1(keyvals: Large<Vec<(i8, i8)>>) -> () {
        let mut map: IndexMap<_, _> = IndexMap::from_iter(keyvals.to_vec());
        let mut answer = keyvals.0;
        answer.sort_by_key(|t| t.0);

        // reverse dedup: Because IndexMap::from_iter keeps the last value for
        // identical keys
        answer.reverse();
        answer.dedup_by_key(|t| t.0);
        answer.reverse();

        map.sort_by(|k1, _, k2, _| Ord::cmp(k1, k2));

        // check it contains all the values it should
        for &(key, val) in &answer {
            assert_eq!(map[&key], val);
        }

        // check the order

        let mapv = Vec::from_iter(map);
        assert_eq!(answer, mapv);

    }

    fn sort_2(keyvals: Large<Vec<(i8, i8)>>) -> () {
        let mut map: IndexMap<_, _> = IndexMap::from_iter(keyvals.to_vec());
        map.sort_by(|_, v1, _, v2| Ord::cmp(v1, v2));
        assert_sorted_by_key(map, |t| t.1);
    }
}

fn assert_sorted_by_key<I, Key, X>(iterable: I, key: Key)
    where I: IntoIterator,
          I::Item: Ord + Clone + Debug,
          Key: Fn(&I::Item) -> X,
          X: Ord,
{
    let input = Vec::from_iter(iterable);
    let mut sorted = input.clone();
    sorted.sort_by_key(key);
    assert_eq!(input, sorted);
}

#[derive(Clone, Debug, Hash, PartialEq, Eq)]
struct Alpha(String);

impl Deref for Alpha {
    type Target = String;
    fn deref(&self) -> &String { &self.0 }
}

const ALPHABET: &'static [u8] = b"abcdefghijklmnopqrstuvwxyz";

impl Arbitrary for Alpha {
    fn arbitrary<G: Gen>(g: &mut G) -> Self {
        let len = g.next_u32() % g.size() as u32;
        let len = min(len, 16);
        Alpha((0..len).map(|_| {
            ALPHABET[g.next_u32() as usize % ALPHABET.len()] as char
        }).collect())
    }

    fn shrink(&self) -> Box<Iterator<Item=Self>> {
        Box::new((**self).shrink().map(Alpha))
    }
}

/// quickcheck Arbitrary adaptor -- make a larger vec
#[derive(Clone, Debug)]
struct Large<T>(T);

impl<T> Deref for Large<T> {
    type Target = T;
    fn deref(&self) -> &T { &self.0 }
}

impl<T> Arbitrary for Large<Vec<T>>
    where T: Arbitrary
{
    fn arbitrary<G: Gen>(g: &mut G) -> Self {
        let len = g.next_u32() % (g.size() * 10) as u32;
        Large((0..len).map(|_| T::arbitrary(g)).collect())
    }

    fn shrink(&self) -> Box<Iterator<Item=Self>> {
        Box::new((**self).shrink().map(Large))
    }
}
