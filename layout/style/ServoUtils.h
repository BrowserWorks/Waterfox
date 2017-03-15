/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* some utilities for stylo */

#ifndef mozilla_ServoUtils_h
#define mozilla_ServoUtils_h

#include "mozilla/TypeTraits.h"

#ifdef MOZ_STYLO
# define MOZ_DECL_STYLO_CHECK_METHODS \
  bool IsGecko() const { return !IsServo(); } \
  bool IsServo() const { return mType == StyleBackendType::Servo; }
#else
# define MOZ_DECL_STYLO_CHECK_METHODS \
  bool IsGecko() const { return true; } \
  bool IsServo() const { return false; }
#endif

/**
 * Macro used in a base class of |geckotype_| and |servotype_|.
 * The class should define |StyleBackendType mType;| itself.
 */
#define MOZ_DECL_STYLO_METHODS(geckotype_, servotype_)  \
  MOZ_DECL_STYLO_CHECK_METHODS                          \
  inline geckotype_* AsGecko();                         \
  inline servotype_* AsServo();                         \
  inline const geckotype_* AsGecko() const;             \
  inline const servotype_* AsServo() const;

/**
 * Macro used in inline header of class |type_| with its Gecko and Servo
 * subclasses named |geckotype_| and |servotype_| correspondingly for
 * implementing the inline methods defined by MOZ_DECL_STYLO_METHODS.
 */
#define MOZ_DEFINE_STYLO_METHODS(type_, geckotype_, servotype_) \
  geckotype_* type_::AsGecko() {                                \
    MOZ_ASSERT(IsGecko());                                      \
    return static_cast<geckotype_*>(this);                      \
  }                                                             \
  servotype_* type_::AsServo() {                                \
    MOZ_ASSERT(IsServo());                                      \
    return static_cast<servotype_*>(this);                      \
  }                                                             \
  const geckotype_* type_::AsGecko() const {                    \
    MOZ_ASSERT(IsGecko());                                      \
    return static_cast<const geckotype_*>(this);                \
  }                                                             \
  const servotype_* type_::AsServo() const {                    \
    MOZ_ASSERT(IsServo());                                      \
    return static_cast<const servotype_*>(this);                \
  }

#define MOZ_STYLO_THIS_TYPE  mozilla::RemovePointer<decltype(this)>::Type
#define MOZ_STYLO_GECKO_TYPE mozilla::RemovePointer<decltype(AsGecko())>::Type
#define MOZ_STYLO_SERVO_TYPE mozilla::RemovePointer<decltype(AsServo())>::Type

/**
 * Macro used to forward a method call to the concrete method defined by
 * the Servo or Gecko implementation. The class of the method using it
 * should use MOZ_DECL_STYLO_METHODS to define basic stylo methods.
 */
#define MOZ_STYLO_FORWARD_CONCRETE(method_, geckoargs_, servoargs_)         \
  static_assert(!mozilla::IsSame<decltype(&MOZ_STYLO_THIS_TYPE::method_),   \
                                 decltype(&MOZ_STYLO_GECKO_TYPE::method_)>  \
                ::value, "Gecko subclass should define its own " #method_); \
  static_assert(!mozilla::IsSame<decltype(&MOZ_STYLO_THIS_TYPE::method_),   \
                                 decltype(&MOZ_STYLO_SERVO_TYPE::method_)>  \
                ::value, "Servo subclass should define its own " #method_); \
  if (IsServo()) {                                                          \
    return AsServo()->method_ servoargs_;                                   \
  }                                                                         \
  return AsGecko()->method_ geckoargs_;

#define MOZ_STYLO_FORWARD(method_, args_) \
  MOZ_STYLO_FORWARD_CONCRETE(method_, args_, args_)

#endif // mozilla_ServoUtils_h
