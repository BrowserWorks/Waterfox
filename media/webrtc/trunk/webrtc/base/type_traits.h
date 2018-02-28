/*
 *  Copyright 2016 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_BASE_TYPE_TRAITS_H_
#define WEBRTC_BASE_TYPE_TRAITS_H_

#include <cstddef>
#include <type_traits>

namespace rtc {

// Determines if the given class has zero-argument .data() and .size() methods
// whose return values are convertible to T* and size_t, respectively.
template <typename DS, typename T>
class HasDataAndSize {
 private:
  template <
      typename C,
      typename std::enable_if<
          std::is_convertible<decltype(std::declval<C>().data()), T*>::value &&
          std::is_convertible<decltype(std::declval<C>().size()),
                              std::size_t>::value>::type* = nullptr>
  static int Test(int);

  template <typename>
  static char Test(...);

 public:
  static constexpr bool value = std::is_same<decltype(Test<DS>(0)), int>::value;
};

namespace test_has_data_and_size {

template <typename DR, typename SR>
struct Test1 {
  DR data();
  SR size();
};
static_assert(HasDataAndSize<Test1<int*, int>, int>::value, "");
static_assert(HasDataAndSize<Test1<int*, int>, const int>::value, "");
static_assert(HasDataAndSize<Test1<const int*, int>, const int>::value, "");
static_assert(!HasDataAndSize<Test1<const int*, int>, int>::value,
              "implicit cast of const int* to int*");
static_assert(!HasDataAndSize<Test1<char*, size_t>, int>::value,
              "implicit cast of char* to int*");

struct Test2 {
  int* data;
  size_t size;
};
static_assert(!HasDataAndSize<Test2, int>::value,
              ".data and .size aren't functions");

struct Test3 {
  int* data();
};
static_assert(!HasDataAndSize<Test3, int>::value, ".size() is missing");

class Test4 {
  int* data();
  size_t size();
};
static_assert(!HasDataAndSize<Test4, int>::value,
              ".data() and .size() are private");

}  // namespace test_has_data_and_size

}  // namespace rtc

#endif  // WEBRTC_BASE_TYPE_TRAITS_H_
