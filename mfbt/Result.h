/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* A type suitable for returning either a value or an error from a function. */

#ifndef mozilla_Result_h
#define mozilla_Result_h

#include <type_traits>
#include "mozilla/Alignment.h"
#include "mozilla/Assertions.h"
#include "mozilla/Attributes.h"
#include "mozilla/Types.h"
#include "mozilla/Variant.h"

namespace mozilla {

/**
 * Empty struct, indicating success for operations that have no return value.
 * For example, if you declare another empty struct `struct OutOfMemory {};`,
 * then `Result<Ok, OutOfMemory>` represents either success or OOM.
 */
struct Ok {};

template <typename E>
class GenericErrorResult;
template <typename V, typename E>
class Result;

namespace detail {

enum class PackingStrategy {
  Variant,
  NullIsOk,
  LowBitTagIsError,
  PackedVariant,
};

template <typename V, typename E, PackingStrategy Strategy>
class ResultImplementation;

template <typename V, typename E>
class ResultImplementation<V, E, PackingStrategy::Variant> {
  mozilla::Variant<V, E> mStorage;

 public:
  ResultImplementation(ResultImplementation&&) = default;
  ResultImplementation(const ResultImplementation&) = default;
  ResultImplementation& operator=(const ResultImplementation&) = default;
  ResultImplementation& operator=(ResultImplementation&&) = default;

  explicit ResultImplementation(V&& aValue)
      : mStorage(std::forward<V>(aValue)) {}
  explicit ResultImplementation(const V& aValue) : mStorage(aValue) {}
  explicit ResultImplementation(const E& aErrorValue) : mStorage(aErrorValue) {}
  explicit ResultImplementation(E&& aErrorValue)
      : mStorage(std::forward<E>(aErrorValue)) {}

  bool isOk() const { return mStorage.template is<V>(); }

  // The callers of these functions will assert isOk() has the proper value, so
  // these functions (in all ResultImplementation specializations) don't need
  // to do so.
  V unwrap() { return std::move(mStorage.template as<V>()); }
  const V& inspect() const { return mStorage.template as<V>(); }

  E unwrapErr() { return std::move(mStorage.template as<E>()); }
  const E& inspectErr() const { return mStorage.template as<E>(); }
};

/**
 * mozilla::Variant doesn't like storing a reference. This is a specialization
 * to store E as pointer if it's a reference.
 */
template <typename V, typename E>
class ResultImplementation<V, E&, PackingStrategy::Variant> {
  mozilla::Variant<V, E*> mStorage;

 public:
  explicit ResultImplementation(V&& aValue)
      : mStorage(std::forward<V>(aValue)) {}
  explicit ResultImplementation(const V& aValue) : mStorage(aValue) {}
  explicit ResultImplementation(E& aErrorValue) : mStorage(&aErrorValue) {}

  bool isOk() const { return mStorage.template is<V>(); }

  const V& inspect() const { return mStorage.template as<V>(); }
  V unwrap() { return std::move(mStorage.template as<V>()); }

  E& unwrapErr() { return *mStorage.template as<E*>(); }
  const E& inspectErr() const { return *mStorage.template as<E*>(); }
};

/**
 * Specialization for when the success type is Ok (or another empty class) and
 * the error type is a reference.
 */
template <typename V, typename E>
class ResultImplementation<V, E&, PackingStrategy::NullIsOk> {
  E* mErrorValue;

 public:
  explicit ResultImplementation(V) : mErrorValue(nullptr) {}
  explicit ResultImplementation(E& aErrorValue) : mErrorValue(&aErrorValue) {}

  bool isOk() const { return mErrorValue == nullptr; }

  const V& inspect() const = delete;
  V unwrap() { return V(); }

  const E& inspectErr() const { return *mErrorValue; }
  E& unwrapErr() { return *mErrorValue; }
};

/**
 * Specialization for when the success type is Ok (or another empty class) and
 * the error type is a value type which can never have the value 0 (as
 * determined by UnusedZero<>).
 */
template <typename V, typename E>
class ResultImplementation<V, E, PackingStrategy::NullIsOk> {
  static constexpr E NullValue = E(0);

  E mErrorValue;

 public:
  explicit ResultImplementation(V) : mErrorValue(NullValue) {}
  explicit ResultImplementation(E aErrorValue) : mErrorValue(aErrorValue) {
    MOZ_ASSERT(aErrorValue != NullValue);
  }

  bool isOk() const { return mErrorValue == NullValue; }

  const V& inspect() const = delete;
  V unwrap() { return V(); }

  const E& inspectErr() const { return mErrorValue; }
  E unwrapErr() { return std::move(mErrorValue); }
};

/**
 * Specialization for when alignment permits using the least significant bit as
 * a tag bit.
 */
template <typename V, typename E>
class ResultImplementation<V*, E&, PackingStrategy::LowBitTagIsError> {
  uintptr_t mBits;

 public:
  explicit ResultImplementation(V* aValue)
      : mBits(reinterpret_cast<uintptr_t>(aValue)) {
    MOZ_ASSERT((uintptr_t(aValue) % MOZ_ALIGNOF(V)) == 0,
               "Result value pointers must not be misaligned");
  }
  explicit ResultImplementation(E& aErrorValue)
      : mBits(reinterpret_cast<uintptr_t>(&aErrorValue) | 1) {
    MOZ_ASSERT((uintptr_t(&aErrorValue) % MOZ_ALIGNOF(E)) == 0,
               "Result errors must not be misaligned");
  }

  bool isOk() const { return (mBits & 1) == 0; }

  V* inspect() const { return reinterpret_cast<V*>(mBits); }
  V* unwrap() { return inspect(); }

  E& inspectErr() const { return *reinterpret_cast<E*>(mBits ^ 1); }
  E& unwrapErr() { return inspectErr(); }
};

// Return true if any of the struct can fit in a word.
template <typename V, typename E>
struct IsPackableVariant {
  struct VEbool {
    V v;
    E e;
    bool ok;
  };
  struct EVbool {
    E e;
    V v;
    bool ok;
  };

  using Impl =
      std::conditional_t<sizeof(VEbool) <= sizeof(EVbool), VEbool, EVbool>;

  static const bool value = sizeof(Impl) <= sizeof(uintptr_t);
};

/**
 * Specialization for when both type are not using all the bytes, in order to
 * use one byte as a tag.
 */
template <typename V, typename E>
class ResultImplementation<V, E, PackingStrategy::PackedVariant> {
  using Impl = typename IsPackableVariant<V, E>::Impl;
  Impl data;

 public:
  explicit ResultImplementation(V aValue) {
    data.v = std::move(aValue);
    data.ok = true;
  }
  explicit ResultImplementation(E aErrorValue) {
    data.e = std::move(aErrorValue);
    data.ok = false;
  }

  bool isOk() const { return data.ok; }

  const V& inspect() const { return data.v; }
  V unwrap() { return std::move(data.v); }

  const E& inspectErr() const { return data.e; }
  E unwrapErr() { return std::move(data.e); }
};

// To use nullptr as a special value, we need the counter part to exclude zero
// from its range of valid representations.
//
// By default assume that zero can be represented.
template <typename T>
struct UnusedZero {
  static const bool value = false;
};

// References can't be null.
template <typename T>
struct UnusedZero<T&> {
  static const bool value = true;
};

// A bit of help figuring out which of the above specializations to use.
//
// We begin by safely assuming types don't have a spare bit.
template <typename T>
struct HasFreeLSB {
  static const bool value = false;
};

// As an incomplete type, void* does not have a spare bit.
template <>
struct HasFreeLSB<void*> {
  static const bool value = false;
};

// The lowest bit of a properly-aligned pointer is always zero if the pointee
// type is greater than byte-aligned. That bit is free to use if it's masked
// out of such pointers before they're dereferenced.
template <typename T>
struct HasFreeLSB<T*> {
  static const bool value = (alignof(T) & 1) == 0;
};

// We store references as pointers, so they have a free bit if a pointer would
// have one.
template <typename T>
struct HasFreeLSB<T&> {
  static const bool value = HasFreeLSB<T*>::value;
};

// Select one of the previous result implementation based on the properties of
// the V and E types.
template <typename V, typename E>
struct SelectResultImpl {
  static const PackingStrategy value =
      (std::is_empty_v<V> && UnusedZero<E>::value)
          ? PackingStrategy::NullIsOk
          : (detail::HasFreeLSB<V>::value && detail::HasFreeLSB<E>::value)
                ? PackingStrategy::LowBitTagIsError
                : (std::is_default_constructible_v<V> &&
                   std::is_default_constructible_v<E> &&
                   IsPackableVariant<V, E>::value)
                      ? PackingStrategy::PackedVariant
                      : PackingStrategy::Variant;

  using Type = detail::ResultImplementation<V, E, value>;
};

template <typename T>
struct IsResult : std::false_type {};

template <typename V, typename E>
struct IsResult<Result<V, E>> : std::true_type {};

}  // namespace detail

template <typename V, typename E>
auto ToResult(Result<V, E>&& aValue)
    -> decltype(std::forward<Result<V, E>>(aValue)) {
  return std::forward<Result<V, E>>(aValue);
}

/**
 * Result<V, E> represents the outcome of an operation that can either succeed
 * or fail. It contains either a success value of type V or an error value of
 * type E.
 *
 * All Result methods are const, so results are basically immutable.
 * This is just like Variant<V, E> but with a slightly different API, and the
 * following cases are optimized so Result can be stored more efficiently:
 *
 * - If the success type is Ok (or another empty class) and the error type is a
 *   reference, Result<V, E&> is guaranteed to be pointer-sized and all zero
 *   bits on success. Do not change this representation! There is JIT code that
 *   depends on it.
 *
 * - If the success type is a pointer type and the error type is a reference
 *   type, and the least significant bit is unused for both types when stored
 *   as a pointer (due to alignment rules), Result<V*, E&> is guaranteed to be
 *   pointer-sized. In this case, we use the lowest bit as tag bit: 0 to
 *   indicate the Result's bits are a V, 1 to indicate the Result's bits (with
 *   the 1 masked out) encode an E*.
 *
 * The purpose of Result is to reduce the screwups caused by using `false` or
 * `nullptr` to indicate errors.
 * What screwups? See <https://bugzilla.mozilla.org/show_bug.cgi?id=912928> for
 * a partial list.
 */
template <typename V, typename E>
class MOZ_MUST_USE_TYPE Result final {
  using Impl = typename detail::SelectResultImpl<V, E>::Type;

  Impl mImpl;

 public:
  using ok_type = V;
  using err_type = E;

  /** Create a success result. */
  MOZ_IMPLICIT Result(V&& aValue) : mImpl(std::forward<V>(aValue)) {
    MOZ_ASSERT(isOk());
  }

  /** Create a success result. */
  MOZ_IMPLICIT Result(const V& aValue) : mImpl(aValue) { MOZ_ASSERT(isOk()); }

  /** Create an error result. */
  explicit Result(E aErrorValue) : mImpl(std::forward<E>(aErrorValue)) {
    MOZ_ASSERT(isErr());
  }

  /**
   * Implementation detail of MOZ_TRY().
   * Create an error result from another error result.
   */
  template <typename E2>
  MOZ_IMPLICIT Result(GenericErrorResult<E2>&& aErrorResult)
      : mImpl(std::forward<E2>(aErrorResult.mErrorValue)) {
    static_assert(std::is_convertible_v<E2, E>, "E2 must be convertible to E");
    MOZ_ASSERT(isErr());
  }

  /**
   * Implementation detail of MOZ_TRY().
   * Create an error result from another error result.
   */
  template <typename E2>
  MOZ_IMPLICIT Result(const GenericErrorResult<E2>& aErrorResult)
      : mImpl(aErrorResult.mErrorValue) {
    static_assert(std::is_convertible_v<E2, E>, "E2 must be convertible to E");
    MOZ_ASSERT(isErr());
  }

  Result(const Result&) = default;
  Result(Result&&) = default;
  Result& operator=(const Result&) = default;
  Result& operator=(Result&&) = default;

  /** True if this Result is a success result. */
  bool isOk() const { return mImpl.isOk(); }

  /** True if this Result is an error result. */
  bool isErr() const { return !mImpl.isOk(); }

  /** Take the success value from this Result, which must be a success result.
   */
  V unwrap() {
    MOZ_ASSERT(isOk());
    return mImpl.unwrap();
  }

  /**
   * Take the success value from this Result, which must be a success result.
   * If it is an error result, then return the aValue.
   */
  V unwrapOr(V aValue) {
    return MOZ_LIKELY(isOk()) ? mImpl.unwrap() : std::move(aValue);
  }

  /** Take the error value from this Result, which must be an error result. */
  E unwrapErr() {
    MOZ_ASSERT(isErr());
    return mImpl.unwrapErr();
  }

  /** See the success value from this Result, which must be a success result. */
  const V& inspect() const { return mImpl.inspect(); }

  /** See the error value from this Result, which must be an error result. */
  const E& inspectErr() const {
    MOZ_ASSERT(isErr());
    return mImpl.inspectErr();
  }

  /** Propagate the error value from this Result, which must be an error result.
   *
   * This can be used to propagate an error from a function call to the caller
   * with a different value type, but the same error type:
   *
   *    Result<T1, E> Func1() {
   *       Result<T2, E> res = Func2();
   *       if (res.isErr()) { return res.propagateErr(); }
   *    }
   */
  GenericErrorResult<E> propagateErr() {
    MOZ_ASSERT(isErr());
    return GenericErrorResult<E>{mImpl.unwrapErr()};
  }

  /**
   * Map a function V -> W over this result's success variant. If this result is
   * an error, do not invoke the function and propagate the error.
   *
   * Mapping over success values invokes the function to produce a new success
   * value:
   *
   *     // Map Result<int, E> to another Result<int, E>
   *     Result<int, E> res(5);
   *     Result<int, E> res2 = res.map([](int x) { return x * x; });
   *     MOZ_ASSERT(res2.unwrap() == 25);
   *
   *     // Map Result<const char*, E> to Result<size_t, E>
   *     Result<const char*, E> res("hello, map!");
   *     Result<size_t, E> res2 = res.map(strlen);
   *     MOZ_ASSERT(res2.unwrap() == 11);
   *
   * Mapping over an error does not invoke the function and propagates the
   * error:
   *
   *     Result<V, int> res(5);
   *     MOZ_ASSERT(res.isErr());
   *     Result<W, int> res2 = res.map([](V v) { ... });
   *     MOZ_ASSERT(res2.isErr());
   *     MOZ_ASSERT(res2.unwrapErr() == 5);
   */
  template <typename F>
  auto map(F f) -> Result<decltype(f(*((V*)nullptr))), E> {
    using RetResult = Result<decltype(f(*((V*)nullptr))), E>;
    return MOZ_LIKELY(isOk()) ? RetResult(f(unwrap())) : RetResult(unwrapErr());
  }

  /**
   * Map a function V -> W over this result's error variant. If this result is
   * a success, do not invoke the function and move the success over.
   *
   * Mapping over error values invokes the function to produce a new error
   * value:
   *
   *     // Map Result<V, int> to another Result<V, int>
   *     Result<V, int> res(5);
   *     Result<V, int> res2 = res.mapErr([](int x) { return x * x; });
   *     MOZ_ASSERT(res2.unwrapErr() == 25);
   *
   *     // Map Result<V, const char*> to Result<V, size_t>
   *     Result<V, const char*> res("hello, map!");
   *     Result<size_t, E> res2 = res.mapErr(strlen);
   *     MOZ_ASSERT(res2.unwrapErr() == 11);
   *
   * Mapping over a success does not invoke the function and copies the error:
   *
   *     Result<int, V> res(5);
   *     MOZ_ASSERT(res.isOk());
   *     Result<int, W> res2 = res.mapErr([](V v) { ... });
   *     MOZ_ASSERT(res2.isOk());
   *     MOZ_ASSERT(res2.unwrap() == 5);
   */
  template <typename F>
  auto mapErr(F f) -> Result<V, std::result_of_t<F(E)>> {
    using RetResult = Result<V, std::result_of_t<F(E)>>;
    return isOk() ? RetResult(unwrap()) : RetResult(f(unwrapErr()));
  }

  /**
   * Given a function V -> Result<W, E>, apply it to this result's success value
   * and return its result. If this result is an error value, it is propagated.
   *
   * This is sometimes called "flatMap" or ">>=" in other contexts.
   *
   * `andThen`ing over success values invokes the function to produce a new
   * result:
   *
   *     Result<const char*, Error> res("hello, andThen!");
   *     Result<HtmlFreeString, Error> res2 = res.andThen([](const char* s) {
   *       return containsHtmlTag(s)
   *         ? Result<HtmlFreeString, Error>(Error("Invalid: contains HTML"))
   *         : Result<HtmlFreeString, Error>(HtmlFreeString(s));
   *       }
   *     });
   *     MOZ_ASSERT(res2.isOk());
   *     MOZ_ASSERT(res2.unwrap() == HtmlFreeString("hello, andThen!");
   *
   * `andThen`ing over error results does not invoke the function, and just
   * propagates the error result:
   *
   *     Result<int, const char*> res("some error");
   *     auto res2 = res.andThen([](int x) { ... });
   *     MOZ_ASSERT(res2.isErr());
   *     MOZ_ASSERT(res.unwrapErr() == res2.unwrapErr());
   */
  template <typename F, typename = std::enable_if_t<detail::IsResult<
                            decltype((*((F*)nullptr))(*((V*)nullptr)))>::value>>
  auto andThen(F f) -> decltype(f(*((V*)nullptr))) {
    return MOZ_LIKELY(isOk()) ? f(unwrap()) : propagateErr();
  }
};

/**
 * A type that auto-converts to an error Result. This is like a Result without
 * a success type. It's the best return type for functions that always return
 * an error--functions designed to build and populate error objects. It's also
 * useful in error-handling macros; see MOZ_TRY for an example.
 */
template <typename E>
class MOZ_MUST_USE_TYPE GenericErrorResult {
  E mErrorValue;

  template <typename V, typename E2>
  friend class Result;

 public:
  explicit GenericErrorResult(E&& aErrorValue)
      : mErrorValue(std::forward<E>(aErrorValue)) {}
};

template <typename E>
inline GenericErrorResult<E> Err(E&& aErrorValue) {
  return GenericErrorResult<E>(std::forward<E>(aErrorValue));
}

}  // namespace mozilla

/**
 * MOZ_TRY(expr) is the C++ equivalent of Rust's `try!(expr);`. First, it
 * evaluates expr, which must produce a Result value. On success, it
 * discards the result altogether. On error, it immediately returns an error
 * Result from the enclosing function.
 */
#define MOZ_TRY(expr)                                   \
  do {                                                  \
    auto mozTryTempResult_ = ::mozilla::ToResult(expr); \
    if (MOZ_UNLIKELY(mozTryTempResult_.isErr())) {      \
      return mozTryTempResult_.propagateErr();          \
    }                                                   \
  } while (0)

/**
 * MOZ_TRY_VAR(target, expr) is the C++ equivalent of Rust's `target =
 * try!(expr);`. First, it evaluates expr, which must produce a Result value. On
 * success, the result's success value is assigned to target. On error,
 * immediately returns the error result. |target| must evaluate to a reference
 * without any side effects.
 */
#define MOZ_TRY_VAR(target, expr)                     \
  do {                                                \
    auto mozTryVarTempResult_ = (expr);               \
    if (MOZ_UNLIKELY(mozTryVarTempResult_.isErr())) { \
      return mozTryVarTempResult_.propagateErr();     \
    }                                                 \
    (target) = mozTryVarTempResult_.unwrap();         \
  } while (0)

#endif  // mozilla_Result_h
