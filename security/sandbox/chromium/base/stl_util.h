// Copyright (c) 2011 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Derived from google3/util/gtl/stl_util.h

#ifndef BASE_STL_UTIL_H_
#define BASE_STL_UTIL_H_

#include <algorithm>
#include <deque>
#include <forward_list>
#include <functional>
#include <initializer_list>
#include <iterator>
#include <list>
#include <map>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "base/logging.h"
#include "base/optional.h"

namespace base {

namespace internal {

// Calls erase on iterators of matching elements.
template <typename Container, typename Predicate>
void IterateAndEraseIf(Container& container, Predicate pred) {
  for (auto it = container.begin(); it != container.end();) {
    if (pred(*it))
      it = container.erase(it);
    else
      ++it;
  }
}

}  // namespace internal

// C++14 implementation of C++17's std::size():
// http://en.cppreference.com/w/cpp/iterator/size
template <typename Container>
constexpr auto size(const Container& c) -> decltype(c.size()) {
  return c.size();
}

template <typename T, size_t N>
constexpr size_t size(const T (&array)[N]) noexcept {
  return N;
}

// C++14 implementation of C++17's std::empty():
// http://en.cppreference.com/w/cpp/iterator/empty
template <typename Container>
constexpr auto empty(const Container& c) -> decltype(c.empty()) {
  return c.empty();
}

template <typename T, size_t N>
constexpr bool empty(const T (&array)[N]) noexcept {
  return false;
}

template <typename T>
constexpr bool empty(std::initializer_list<T> il) noexcept {
  return il.size() == 0;
}

// C++14 implementation of C++17's std::data():
// http://en.cppreference.com/w/cpp/iterator/data
template <typename Container>
constexpr auto data(Container& c) -> decltype(c.data()) {
  return c.data();
}

// std::basic_string::data() had no mutable overload prior to C++17 [1].
// Hence this overload is provided.
// Note: str[0] is safe even for empty strings, as they are guaranteed to be
// null-terminated [2].
//
// [1] http://en.cppreference.com/w/cpp/string/basic_string/data
// [2] http://en.cppreference.com/w/cpp/string/basic_string/operator_at
template <typename CharT, typename Traits, typename Allocator>
CharT* data(std::basic_string<CharT, Traits, Allocator>& str) {
  return std::addressof(str[0]);
}

template <typename Container>
constexpr auto data(const Container& c) -> decltype(c.data()) {
  return c.data();
}

template <typename T, size_t N>
constexpr T* data(T (&array)[N]) noexcept {
  return array;
}

template <typename T>
constexpr const T* data(std::initializer_list<T> il) noexcept {
  return il.begin();
}

// Returns a const reference to the underlying container of a container adapter.
// Works for std::priority_queue, std::queue, and std::stack.
template <class A>
const typename A::container_type& GetUnderlyingContainer(const A& adapter) {
  struct ExposedAdapter : A {
    using A::c;
  };
  return adapter.*&ExposedAdapter::c;
}

// Clears internal memory of an STL object.
// STL clear()/reserve(0) does not always free internal memory allocated
// This function uses swap/destructor to ensure the internal memory is freed.
template<class T>
void STLClearObject(T* obj) {
  T tmp;
  tmp.swap(*obj);
  // Sometimes "T tmp" allocates objects with memory (arena implementation?).
  // Hence using additional reserve(0) even if it doesn't always work.
  obj->reserve(0);
}

// Counts the number of instances of val in a container.
template <typename Container, typename T>
typename std::iterator_traits<
    typename Container::const_iterator>::difference_type
STLCount(const Container& container, const T& val) {
  return std::count(container.begin(), container.end(), val);
}

// Test to see if a set or map contains a particular key.
// Returns true if the key is in the collection.
template <typename Collection, typename Key>
bool ContainsKey(const Collection& collection, const Key& key) {
  return collection.find(key) != collection.end();
}

namespace internal {

template <typename Collection>
class HasKeyType {
  template <typename C>
  static std::true_type test(typename C::key_type*);
  template <typename C>
  static std::false_type test(...);

 public:
  static constexpr bool value = decltype(test<Collection>(nullptr))::value;
};

}  // namespace internal

// Test to see if a collection like a vector contains a particular value.
// Returns true if the value is in the collection.
// Don't use this on collections such as sets or maps. This is enforced by
// disabling this method if the collection defines a key_type.
template <typename Collection,
          typename Value,
          typename std::enable_if<!internal::HasKeyType<Collection>::value,
                                  int>::type = 0>
bool ContainsValue(const Collection& collection, const Value& value) {
  return std::find(std::begin(collection), std::end(collection), value) !=
         std::end(collection);
}

// Returns true if the container is sorted.
template <typename Container>
bool STLIsSorted(const Container& cont) {
  return std::is_sorted(std::begin(cont), std::end(cont));
}

// Returns a new ResultType containing the difference of two sorted containers.
template <typename ResultType, typename Arg1, typename Arg2>
ResultType STLSetDifference(const Arg1& a1, const Arg2& a2) {
  DCHECK(STLIsSorted(a1));
  DCHECK(STLIsSorted(a2));
  ResultType difference;
  std::set_difference(a1.begin(), a1.end(),
                      a2.begin(), a2.end(),
                      std::inserter(difference, difference.end()));
  return difference;
}

// Returns a new ResultType containing the union of two sorted containers.
template <typename ResultType, typename Arg1, typename Arg2>
ResultType STLSetUnion(const Arg1& a1, const Arg2& a2) {
  DCHECK(STLIsSorted(a1));
  DCHECK(STLIsSorted(a2));
  ResultType result;
  std::set_union(a1.begin(), a1.end(),
                 a2.begin(), a2.end(),
                 std::inserter(result, result.end()));
  return result;
}

// Returns a new ResultType containing the intersection of two sorted
// containers.
template <typename ResultType, typename Arg1, typename Arg2>
ResultType STLSetIntersection(const Arg1& a1, const Arg2& a2) {
  DCHECK(STLIsSorted(a1));
  DCHECK(STLIsSorted(a2));
  ResultType result;
  std::set_intersection(a1.begin(), a1.end(),
                        a2.begin(), a2.end(),
                        std::inserter(result, result.end()));
  return result;
}

// Returns true if the sorted container |a1| contains all elements of the sorted
// container |a2|.
template <typename Arg1, typename Arg2>
bool STLIncludes(const Arg1& a1, const Arg2& a2) {
  DCHECK(STLIsSorted(a1));
  DCHECK(STLIsSorted(a2));
  return std::includes(a1.begin(), a1.end(),
                       a2.begin(), a2.end());
}

// Erase/EraseIf are based on library fundamentals ts v2 erase/erase_if
// http://en.cppreference.com/w/cpp/experimental/lib_extensions_2
// They provide a generic way to erase elements from a container.
// The functions here implement these for the standard containers until those
// functions are available in the C++ standard.
// For Chromium containers overloads should be defined in their own headers
// (like standard containers).
// Note: there is no std::erase for standard associative containers so we don't
// have it either.

template <typename CharT, typename Traits, typename Allocator, typename Value>
void Erase(std::basic_string<CharT, Traits, Allocator>& container,
           const Value& value) {
  container.erase(std::remove(container.begin(), container.end(), value),
                  container.end());
}

template <typename CharT, typename Traits, typename Allocator, class Predicate>
void EraseIf(std::basic_string<CharT, Traits, Allocator>& container,
             Predicate pred) {
  container.erase(std::remove_if(container.begin(), container.end(), pred),
                  container.end());
}

template <class T, class Allocator, class Value>
void Erase(std::deque<T, Allocator>& container, const Value& value) {
  container.erase(std::remove(container.begin(), container.end(), value),
                  container.end());
}

template <class T, class Allocator, class Predicate>
void EraseIf(std::deque<T, Allocator>& container, Predicate pred) {
  container.erase(std::remove_if(container.begin(), container.end(), pred),
                  container.end());
}

template <class T, class Allocator, class Value>
void Erase(std::vector<T, Allocator>& container, const Value& value) {
  container.erase(std::remove(container.begin(), container.end(), value),
                  container.end());
}

template <class T, class Allocator, class Predicate>
void EraseIf(std::vector<T, Allocator>& container, Predicate pred) {
  container.erase(std::remove_if(container.begin(), container.end(), pred),
                  container.end());
}

template <class T, class Allocator, class Value>
void Erase(std::forward_list<T, Allocator>& container, const Value& value) {
  // Unlike std::forward_list::remove, this function template accepts
  // heterogeneous types and does not force a conversion to the container's
  // value type before invoking the == operator.
  container.remove_if([&](const T& cur) { return cur == value; });
}

template <class T, class Allocator, class Predicate>
void EraseIf(std::forward_list<T, Allocator>& container, Predicate pred) {
  container.remove_if(pred);
}

template <class T, class Allocator, class Value>
void Erase(std::list<T, Allocator>& container, const Value& value) {
  // Unlike std::list::remove, this function template accepts heterogeneous
  // types and does not force a conversion to the container's value type before
  // invoking the == operator.
  container.remove_if([&](const T& cur) { return cur == value; });
}

template <class T, class Allocator, class Predicate>
void EraseIf(std::list<T, Allocator>& container, Predicate pred) {
  container.remove_if(pred);
}

template <class Key, class T, class Compare, class Allocator, class Predicate>
void EraseIf(std::map<Key, T, Compare, Allocator>& container, Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

template <class Key, class T, class Compare, class Allocator, class Predicate>
void EraseIf(std::multimap<Key, T, Compare, Allocator>& container,
             Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

template <class Key, class Compare, class Allocator, class Predicate>
void EraseIf(std::set<Key, Compare, Allocator>& container, Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

template <class Key, class Compare, class Allocator, class Predicate>
void EraseIf(std::multiset<Key, Compare, Allocator>& container,
             Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

template <class Key,
          class T,
          class Hash,
          class KeyEqual,
          class Allocator,
          class Predicate>
void EraseIf(std::unordered_map<Key, T, Hash, KeyEqual, Allocator>& container,
             Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

template <class Key,
          class T,
          class Hash,
          class KeyEqual,
          class Allocator,
          class Predicate>
void EraseIf(
    std::unordered_multimap<Key, T, Hash, KeyEqual, Allocator>& container,
    Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

template <class Key,
          class Hash,
          class KeyEqual,
          class Allocator,
          class Predicate>
void EraseIf(std::unordered_set<Key, Hash, KeyEqual, Allocator>& container,
             Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

template <class Key,
          class Hash,
          class KeyEqual,
          class Allocator,
          class Predicate>
void EraseIf(std::unordered_multiset<Key, Hash, KeyEqual, Allocator>& container,
             Predicate pred) {
  internal::IterateAndEraseIf(container, pred);
}

// A helper class to be used as the predicate with |EraseIf| to implement
// in-place set intersection. Helps implement the algorithm of going through
// each container an element at a time, erasing elements from the first
// container if they aren't in the second container. Requires each container be
// sorted. Note that the logic below appears inverted since it is returning
// whether an element should be erased.
template <class Collection>
class IsNotIn {
 public:
  explicit IsNotIn(const Collection& collection)
      : i_(collection.begin()), end_(collection.end()) {}

  bool operator()(const typename Collection::value_type& x) {
    while (i_ != end_ && *i_ < x)
      ++i_;
    if (i_ == end_)
      return true;
    if (*i_ == x) {
      ++i_;
      return false;
    }
    return true;
  }

 private:
  typename Collection::const_iterator i_;
  const typename Collection::const_iterator end_;
};

// Helper for returning the optional value's address, or nullptr.
template <class T>
T* OptionalOrNullptr(base::Optional<T>& optional) {
  return optional.has_value() ? &optional.value() : nullptr;
}

template <class T>
const T* OptionalOrNullptr(const base::Optional<T>& optional) {
  return optional.has_value() ? &optional.value() : nullptr;
}

}  // namespace base

#endif  // BASE_STL_UTIL_H_
