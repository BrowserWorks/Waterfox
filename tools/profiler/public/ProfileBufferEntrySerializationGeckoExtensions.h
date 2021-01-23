/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef ProfileBufferEntrySerializationGeckoExtensions_h
#define ProfileBufferEntrySerializationGeckoExtensions_h

#include "mozilla/ProfileBufferEntrySerialization.h"

#include "js/AllocPolicy.h"
#include "js/Utility.h"
#include "nsString.h"

namespace mozilla {

// ----------------------------------------------------------------------------
// ns[C]String

// nsString or nsCString contents are serialized as the number of bytes (encoded
// as ULEB128) and all the characters in the string. The terminal '\0' is
// omitted.
// Make sure you write and read with the same character type!
//
// Usage: `nsCString s = ...; aEW.WriteObject(s);`
template <typename T>
struct ProfileBufferEntryWriter::Serializer<nsTString<T>> {
  static Length Bytes(const nsTString<T>& aS) {
    // Note that we store the size in *bytes*, not in number of characters.
    const auto bytes = aS.Length() * sizeof(T);
    return ProfileBufferEntryWriter::ULEB128Size(bytes) +
           static_cast<Length>(bytes);
  }

  static void Write(ProfileBufferEntryWriter& aEW, const nsTString<T>& aS) {
    // Note that we store the size in *bytes*, not in number of characters.
    const auto bytes = aS.Length() * sizeof(T);
    aEW.WriteULEB128(bytes);
    // Copy the bytes from the string's buffer.
    aEW.WriteBytes(reinterpret_cast<const char*>(aS.BeginReading()), bytes);
  }
};

template <typename T>
struct ProfileBufferEntryReader::Deserializer<nsTString<T>> {
  static void ReadInto(ProfileBufferEntryReader& aER, nsTString<T>& aS) {
    aS = Read(aER);
  }

  static nsTString<T> Read(ProfileBufferEntryReader& aER) {
    // Note that the stored size is in *bytes*, not in number of characters.
    const auto bytes = aER.ReadULEB128<Length>();
    nsTString<T> s;
    nsresult rv;
    // BulkWrite is the most efficient way to copy bytes into the target string.
    auto writer = s.BulkWrite(bytes / sizeof(T), 0, true, rv);
    MOZ_RELEASE_ASSERT(NS_SUCCEEDED(rv));
    aER.ReadBytes(reinterpret_cast<char*>(writer.Elements()), bytes);
    writer.Finish(bytes / sizeof(T), true);
    return s;
  }
};

// ----------------------------------------------------------------------------
// nsAuto[C]String

// nsAuto[C]String contents are serialized as the number of bytes (encoded as
// ULEB128) and all the characters in the string. The terminal '\0' is omitted.
// Make sure you write and read with the same character type!
//
// Usage: `nsAutoCString s = ...; aEW.WriteObject(s);`
template <typename T, size_t N>
struct ProfileBufferEntryWriter::Serializer<nsTAutoStringN<T, N>> {
  static Length Bytes(const nsTAutoStringN<T, N>& aS) {
    // Note that we store the size in *bytes*, not in number of characters.
    const auto bytes = aS.Length() * sizeof(T);
    return ProfileBufferEntryWriter::ULEB128Size(bytes) +
           static_cast<Length>(bytes);
  }

  static void Write(ProfileBufferEntryWriter& aEW,
                    const nsTAutoStringN<T, N>& aS) {
    const auto bytes = aS.Length() * sizeof(T);
    // Note that we store the size in *bytes*, not in number of characters.
    aEW.WriteULEB128(bytes);
    // Copy the bytes from the string's buffer.
    aEW.WriteBytes(reinterpret_cast<const char*>(aS.BeginReading()), bytes);
  }
};

template <typename T, size_t N>
struct ProfileBufferEntryReader::Deserializer<nsTAutoStringN<T, N>> {
  static void ReadInto(ProfileBufferEntryReader& aER,
                       nsTAutoStringN<T, N>& aS) {
    aS = Read(aER);
  }

  static nsTAutoStringN<T, N> Read(ProfileBufferEntryReader& aER) {
    // Note that the stored size is in *bytes*, not in number of characters.
    const auto bytes = aER.ReadULEB128<Length>();
    nsTAutoStringN<T, N> s;
    nsresult rv;
    // BulkWrite is the most efficient way to copy bytes into the target string.
    auto writer = s.BulkWrite(bytes / sizeof(T), 0, true, rv);
    MOZ_RELEASE_ASSERT(NS_SUCCEEDED(rv));
    aER.ReadBytes(reinterpret_cast<char*>(writer.Elements()), bytes);
    writer.Finish(bytes / sizeof(T), true);
    return s;
  }
};

// ----------------------------------------------------------------------------
// JS::UniqueChars

// JS::UniqueChars contents are serialized as the number of bytes (encoded as
// ULEB128) and all the characters in the string. The terminal '\0' is omitted.
// Note: A nullptr pointer will be serialized like an empty string, so when
// deserializing it will result in an allocated buffer only containing a
// single null terminator.
//
// Usage: `JS::UniqueChars s = ...; aEW.WriteObject(s);`
template <>
struct ProfileBufferEntryWriter::Serializer<JS::UniqueChars> {
  static Length Bytes(const JS::UniqueChars& aS) {
    if (!aS) {
      return ProfileBufferEntryWriter::ULEB128Size<Length>(0);
    }
    const auto len = static_cast<Length>(strlen(aS.get()));
    return ProfileBufferEntryWriter::ULEB128Size(len) + len;
  }

  static void Write(ProfileBufferEntryWriter& aEW, const JS::UniqueChars& aS) {
    if (!aS) {
      aEW.WriteULEB128<Length>(0);
      return;
    }
    const auto len = static_cast<Length>(strlen(aS.get()));
    aEW.WriteULEB128(len);
    aEW.WriteBytes(aS.get(), len);
  }
};

template <>
struct ProfileBufferEntryReader::Deserializer<JS::UniqueChars> {
  static void ReadInto(ProfileBufferEntryReader& aER, JS::UniqueChars& aS) {
    aS = Read(aER);
  }

  static JS::UniqueChars Read(ProfileBufferEntryReader& aER) {
    const auto len = aER.ReadULEB128<Length>();
    // Use the same allocation policy as JS_smprintf.
    char* buffer =
        static_cast<char*>(js::SystemAllocPolicy{}.pod_malloc<char>(len + 1));
    aER.ReadBytes(buffer, len);
    buffer[len] = '\0';
    return JS::UniqueChars(buffer);
  }
};

}  // namespace mozilla

#endif  // ProfileBufferEntrySerializationGeckoExtensions_h
