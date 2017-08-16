/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <string.h>
#include "mozilla/Result.h"

using mozilla::Err;
using mozilla::GenericErrorResult;
using mozilla::Ok;
using mozilla::Result;

struct Failed
{
  int x;
};

static_assert(sizeof(Result<Ok, Failed&>) == sizeof(uintptr_t),
              "Result with empty value type should be pointer-sized");
static_assert(sizeof(Result<int*, Failed&>) == sizeof(uintptr_t),
              "Result with two aligned pointer types should be pointer-sized");
static_assert(sizeof(Result<char*, Failed*>) > sizeof(char*),
              "Result with unaligned success type `char*` must not be pointer-sized");
static_assert(sizeof(Result<int*, char*>) > sizeof(char*),
              "Result with unaligned error type `char*` must not be pointer-sized");

enum Foo8 : uint8_t {};
enum Foo16 : uint16_t {};
enum Foo32 : uint32_t {};
static_assert(sizeof(Result<Ok, Foo8>) <= sizeof(uintptr_t),
              "Result with small types should be pointer-sized");
static_assert(sizeof(Result<Ok, Foo16>) <= sizeof(uintptr_t),
              "Result with small types should be pointer-sized");
static_assert(sizeof(Foo32) >= sizeof(uintptr_t) ||
              sizeof(Result<Ok, Foo32>) <= sizeof(uintptr_t),
              "Result with small types should be pointer-sized");

static_assert(sizeof(Result<Foo16, Foo8>) <= sizeof(uintptr_t),
              "Result with small types should be pointer-sized");
static_assert(sizeof(Result<Foo8, Foo16>) <= sizeof(uintptr_t),
              "Result with small types should be pointer-sized");
static_assert(sizeof(Foo32) >= sizeof(uintptr_t) ||
              sizeof(Result<Foo32, Foo16>) <= sizeof(uintptr_t),
              "Result with small types should be pointer-sized");
static_assert(sizeof(Foo32) >= sizeof(uintptr_t) ||
              sizeof(Result<Foo16, Foo32>) <= sizeof(uintptr_t),
              "Result with small types should be pointer-sized");

static GenericErrorResult<Failed&>
Fail()
{
  static Failed failed;
  return Err<Failed&>(failed);
}

static Result<Ok, Failed&>
Task1(bool pass)
{
  if (!pass) {
    return Fail();  // implicit conversion from GenericErrorResult to Result
  }
  return Ok();
}

static Result<int, Failed&>
Task2(bool pass, int value)
{
  MOZ_TRY(Task1(pass)); // converts one type of result to another in the error case
  return value;  // implicit conversion from T to Result<T, E>
}

static Result<int, Failed&>
Task3(bool pass1, bool pass2, int value)
{
  int x, y;
  MOZ_TRY_VAR(x, Task2(pass1, value));
  MOZ_TRY_VAR(y, Task2(pass2, value));
  return x + y;
}

static void
BasicTests()
{
  MOZ_RELEASE_ASSERT(Task1(true).isOk());
  MOZ_RELEASE_ASSERT(!Task1(true).isErr());
  MOZ_RELEASE_ASSERT(!Task1(false).isOk());
  MOZ_RELEASE_ASSERT(Task1(false).isErr());

  // MOZ_TRY works.
  MOZ_RELEASE_ASSERT(Task2(true, 3).isOk());
  MOZ_RELEASE_ASSERT(Task2(true, 3).unwrap() == 3);
  MOZ_RELEASE_ASSERT(Task2(false, 3).isErr());

  // MOZ_TRY_VAR works.
  MOZ_RELEASE_ASSERT(Task3(true, true, 3).isOk());
  MOZ_RELEASE_ASSERT(Task3(true, true, 3).unwrap() == 6);
  MOZ_RELEASE_ASSERT(Task3(true, false, 3).isErr());
  MOZ_RELEASE_ASSERT(Task3(false, true, 3).isErr());

  // Lvalues should work too.
  {
    Result<Ok, Failed&> res = Task1(true);
    MOZ_RELEASE_ASSERT(res.isOk());
    MOZ_RELEASE_ASSERT(!res.isErr());

    res = Task1(false);
    MOZ_RELEASE_ASSERT(!res.isOk());
    MOZ_RELEASE_ASSERT(res.isErr());
  }

  {
    Result<int, Failed&> res = Task2(true, 3);
    MOZ_RELEASE_ASSERT(res.isOk());
    MOZ_RELEASE_ASSERT(res.unwrap() == 3);

    res = Task2(false, 4);
    MOZ_RELEASE_ASSERT(res.isErr());
  }

  // Some tests for pointer tagging.
  {
    int i = 123;
    double d = 3.14;

    Result<int*, double&> res = &i;
    static_assert(sizeof(res) == sizeof(uintptr_t),
                  "should use pointer tagging to fit in a word");

    MOZ_RELEASE_ASSERT(res.isOk());
    MOZ_RELEASE_ASSERT(*res.unwrap() == 123);

    res = Err(d);
    MOZ_RELEASE_ASSERT(res.isErr());
    MOZ_RELEASE_ASSERT(&res.unwrapErr() == &d);
    MOZ_RELEASE_ASSERT(res.unwrapErr() == 3.14);
  }
}


/* * */

struct Snafu : Failed {};

static Result<Ok, Snafu*>
Explode()
{
  static Snafu snafu;
  return Err(&snafu);
}

static Result<Ok, Failed*>
ErrorGeneralization()
{
  MOZ_TRY(Explode());  // change error type from Snafu* to more general Failed*
  return Ok();
}

static void
TypeConversionTests()
{
  MOZ_RELEASE_ASSERT(ErrorGeneralization().isErr());
}

static void
EmptyValueTest()
{
  struct Fine {};
  mozilla::Result<Fine, int&> res((Fine()));
  res.unwrap();
  MOZ_RELEASE_ASSERT(res.isOk());
  static_assert(sizeof(res) == sizeof(uintptr_t),
                "Result with empty value type should be pointer-sized");
}

static void
ReferenceTest()
{
  struct MyError { int x = 0; };
  MyError merror;
  Result<int, MyError&> res(merror);
  MOZ_RELEASE_ASSERT(&res.unwrapErr() == &merror);
}

static void
MapTest()
{
  struct MyError {
    int x;

    explicit MyError(int y) : x(y) { }
  };

  // Mapping over success values.
  Result<int, MyError> res(5);
  bool invoked = false;
  auto res2 = res.map([&invoked](int x) {
    MOZ_RELEASE_ASSERT(x == 5);
    invoked = true;
    return "hello";
  });
  MOZ_RELEASE_ASSERT(res2.isOk());
  MOZ_RELEASE_ASSERT(invoked);
  MOZ_RELEASE_ASSERT(strcmp(res2.unwrap(), "hello") == 0);

  // Mapping over error values.
  MyError err(1);
  Result<char, MyError> res3(err);
  MOZ_RELEASE_ASSERT(res3.isErr());
  Result<char, MyError> res4 = res3.map([](int x) {
    MOZ_RELEASE_ASSERT(false);
    return 'a';
  });
  MOZ_RELEASE_ASSERT(res4.isErr());
  MOZ_RELEASE_ASSERT(res4.unwrapErr().x == err.x);

  // Function pointers instead of lamdbas as the mapping function.
  Result<const char*, MyError> res5("hello");
  auto res6 = res5.map(strlen);
  MOZ_RELEASE_ASSERT(res6.isOk());
  MOZ_RELEASE_ASSERT(res6.unwrap() == 5);
}

static void
AndThenTest()
{
  // `andThen`ing over success results.
  Result<int, const char*> r1(10);
  Result<int, const char*> r2 = r1.andThen([](int x) {
    return Result<int, const char*>(x + 1);
  });
  MOZ_RELEASE_ASSERT(r2.isOk());
  MOZ_RELEASE_ASSERT(r2.unwrap() == 11);

  // `andThen`ing over error results.
  Result<int, const char*> r3("error");
  Result<int, const char*> r4 = r3.andThen([](int x) {
    MOZ_RELEASE_ASSERT(false);
    return Result<int, const char*>(1);
  });
  MOZ_RELEASE_ASSERT(r4.isErr());
  MOZ_RELEASE_ASSERT(r3.unwrapErr() == r4.unwrapErr());
}

/* * */

int main()
{
  BasicTests();
  TypeConversionTests();
  EmptyValueTest();
  ReferenceTest();
  MapTest();
  AndThenTest();
  return 0;
}
