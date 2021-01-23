/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "KeyPath.h"
#include "IDBObjectStore.h"
#include "Key.h"
#include "ReportInternalError.h"

#include "nsCharSeparatedTokenizer.h"
#include "nsJSUtils.h"
#include "nsPrintfCString.h"
#include "xpcpublic.h"

#include "js/Array.h"  // JS::NewArrayObject
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/dom/Blob.h"
#include "mozilla/dom/BlobBinding.h"
#include "mozilla/dom/File.h"
#include "mozilla/dom/IDBObjectStoreBinding.h"

namespace mozilla {
namespace dom {
namespace indexedDB {

namespace {

inline bool IgnoreWhitespace(char16_t c) { return false; }

typedef nsCharSeparatedTokenizerTemplate<IgnoreWhitespace> KeyPathTokenizer;

bool IsValidKeyPathString(const nsAString& aKeyPath) {
  NS_ASSERTION(!aKeyPath.IsVoid(), "What?");

  KeyPathTokenizer tokenizer(aKeyPath, '.');

  while (tokenizer.hasMoreTokens()) {
    const auto& token = tokenizer.nextToken();

    if (!token.Length()) {
      return false;
    }

    if (!JS_IsIdentifier(token.Data(), token.Length())) {
      return false;
    }
  }

  // If the very last character was a '.', the tokenizer won't give us an empty
  // token, but the keyPath is still invalid.
  return aKeyPath.IsEmpty() || aKeyPath.CharAt(aKeyPath.Length() - 1) != '.';
}

enum KeyExtractionOptions { DoNotCreateProperties, CreateProperties };

nsresult GetJSValFromKeyPathString(
    JSContext* aCx, const JS::Value& aValue, const nsAString& aKeyPathString,
    JS::Value* aKeyJSVal, KeyExtractionOptions aOptions,
    KeyPath::ExtractOrCreateKeyCallback aCallback, void* aClosure) {
  NS_ASSERTION(aCx, "Null pointer!");
  NS_ASSERTION(IsValidKeyPathString(aKeyPathString), "This will explode!");
  NS_ASSERTION(!(aCallback || aClosure) || aOptions == CreateProperties,
               "This is not allowed!");
  NS_ASSERTION(aOptions != CreateProperties || aCallback,
               "If properties are created, there must be a callback!");

  nsresult rv = NS_OK;
  *aKeyJSVal = aValue;

  KeyPathTokenizer tokenizer(aKeyPathString, '.');

  nsString targetObjectPropName;
  JS::Rooted<JSObject*> targetObject(aCx, nullptr);
  JS::Rooted<JS::Value> currentVal(aCx, aValue);
  JS::Rooted<JSObject*> obj(aCx);

  while (tokenizer.hasMoreTokens()) {
    const auto& token = tokenizer.nextToken();

    NS_ASSERTION(!token.IsEmpty(), "Should be a valid keypath");

    const char16_t* keyPathChars = token.BeginReading();
    const size_t keyPathLen = token.Length();

    if (!targetObject) {
      // We're still walking the chain of existing objects
      // http://w3c.github.io/IndexedDB/#evaluate-a-key-path-on-a-value
      // step 4 substep 1: check for .length on a String value.
      if (currentVal.isString() && !tokenizer.hasMoreTokens() &&
          token.EqualsLiteral("length")) {
        aKeyJSVal->setNumber(double(JS_GetStringLength(currentVal.toString())));
        break;
      }

      if (!currentVal.isObject()) {
        return NS_ERROR_DOM_INDEXEDDB_DATA_ERR;
      }
      obj = &currentVal.toObject();

      // We call JS_GetOwnUCPropertyDescriptor on purpose (as opposed to
      // JS_GetUCPropertyDescriptor) to avoid searching the prototype chain.
      JS::Rooted<JS::PropertyDescriptor> desc(aCx);
      bool ok = JS_GetOwnUCPropertyDescriptor(aCx, obj, keyPathChars,
                                              keyPathLen, &desc);
      IDB_ENSURE_TRUE(ok, NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR);

      JS::Rooted<JS::Value> intermediate(aCx);
      bool hasProp = false;

      if (desc.object()) {
        intermediate = desc.value();
        hasProp = true;
      } else {
        // If we get here it means the object doesn't have the property or the
        // property is available throuch a getter. We don't want to call any
        // getters to avoid potential re-entrancy.
        // The blob object is special since its properties are available
        // only through getters but we still want to support them for key
        // extraction. So they need to be handled manually.
        Blob* blob;
        if (NS_SUCCEEDED(UNWRAP_OBJECT(Blob, &obj, blob))) {
          if (token.EqualsLiteral("size")) {
            ErrorResult rv;
            uint64_t size = blob->GetSize(rv);
            MOZ_ALWAYS_TRUE(!rv.Failed());

            intermediate = JS_NumberValue(size);
            hasProp = true;
          } else if (token.EqualsLiteral("type")) {
            nsString type;
            blob->GetType(type);

            JSString* string =
                JS_NewUCStringCopyN(aCx, type.get(), type.Length());

            intermediate = JS::StringValue(string);
            hasProp = true;
          } else {
            RefPtr<File> file = blob->ToFile();
            if (file) {
              if (token.EqualsLiteral("name")) {
                nsString name;
                file->GetName(name);

                JSString* string =
                    JS_NewUCStringCopyN(aCx, name.get(), name.Length());

                intermediate = JS::StringValue(string);
                hasProp = true;
              } else if (token.EqualsLiteral("lastModified")) {
                ErrorResult rv;
                int64_t lastModifiedDate = file->GetLastModified(rv);
                MOZ_ALWAYS_TRUE(!rv.Failed());

                intermediate = JS_NumberValue(lastModifiedDate);
                hasProp = true;
              }
              // The spec also lists "lastModifiedDate", but we deprecated and
              // removed support for it.
            }
          }
        }
      }

      if (hasProp) {
        // Treat explicitly undefined as an error.
        if (intermediate.isUndefined()) {
          return NS_ERROR_DOM_INDEXEDDB_DATA_ERR;
        }
        if (tokenizer.hasMoreTokens()) {
          // ...and walk to it if there are more steps...
          currentVal = intermediate;
        } else {
          // ...otherwise use it as key
          *aKeyJSVal = intermediate;
        }
      } else {
        // If the property doesn't exist, fall into below path of starting
        // to define properties, if allowed.
        if (aOptions == DoNotCreateProperties) {
          return NS_ERROR_DOM_INDEXEDDB_DATA_ERR;
        }

        targetObject = obj;
        targetObjectPropName = token;
      }
    }

    if (targetObject) {
      // We have started inserting new objects or are about to just insert
      // the first one.

      aKeyJSVal->setUndefined();

      if (tokenizer.hasMoreTokens()) {
        // If we're not at the end, we need to add a dummy object to the
        // chain.
        JS::Rooted<JSObject*> dummy(aCx, JS_NewPlainObject(aCx));
        if (!dummy) {
          IDB_REPORT_INTERNAL_ERR();
          rv = NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
          break;
        }

        if (!JS_DefineUCProperty(aCx, obj, token.BeginReading(), token.Length(),
                                 dummy, JSPROP_ENUMERATE)) {
          IDB_REPORT_INTERNAL_ERR();
          rv = NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
          break;
        }

        obj = dummy;
      } else {
        JS::Rooted<JSObject*> dummy(
            aCx, JS_NewObject(aCx, IDBObjectStore::DummyPropClass()));
        if (!dummy) {
          IDB_REPORT_INTERNAL_ERR();
          rv = NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
          break;
        }

        if (!JS_DefineUCProperty(aCx, obj, token.BeginReading(), token.Length(),
                                 dummy, JSPROP_ENUMERATE)) {
          IDB_REPORT_INTERNAL_ERR();
          rv = NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
          break;
        }

        obj = dummy;
      }
    }
  }

  // We guard on rv being a success because we need to run the property
  // deletion code below even if we should not be running the callback.
  if (NS_SUCCEEDED(rv) && aCallback) {
    rv = (*aCallback)(aCx, aClosure);
  }

  if (targetObject) {
    // If this fails, we lose, and the web page sees a magical property
    // appear on the object :-(
    JS::ObjectOpResult succeeded;
    if (!JS_DeleteUCProperty(aCx, targetObject, targetObjectPropName.get(),
                             targetObjectPropName.Length(), succeeded)) {
      IDB_REPORT_INTERNAL_ERR();
      return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
    }
    IDB_ENSURE_TRUE(succeeded, NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR);
  }

  NS_ENSURE_SUCCESS(rv, rv);
  return rv;
}

}  // namespace

// static
nsresult KeyPath::Parse(const nsAString& aString, KeyPath* aKeyPath) {
  KeyPath keyPath(0);
  keyPath.SetType(STRING);

  if (!keyPath.AppendStringWithValidation(aString)) {
    return NS_ERROR_FAILURE;
  }

  *aKeyPath = keyPath;
  return NS_OK;
}

// static
nsresult KeyPath::Parse(const Sequence<nsString>& aStrings, KeyPath* aKeyPath) {
  KeyPath keyPath(0);
  keyPath.SetType(ARRAY);

  for (uint32_t i = 0; i < aStrings.Length(); ++i) {
    if (!keyPath.AppendStringWithValidation(aStrings[i])) {
      return NS_ERROR_FAILURE;
    }
  }

  *aKeyPath = keyPath;
  return NS_OK;
}

// static
nsresult KeyPath::Parse(const Nullable<OwningStringOrStringSequence>& aValue,
                        KeyPath* aKeyPath) {
  KeyPath keyPath(0);

  aKeyPath->SetType(NONEXISTENT);

  if (aValue.IsNull()) {
    *aKeyPath = keyPath;
    return NS_OK;
  }

  if (aValue.Value().IsString()) {
    return Parse(aValue.Value().GetAsString(), aKeyPath);
  }

  MOZ_ASSERT(aValue.Value().IsStringSequence());

  const Sequence<nsString>& seq = aValue.Value().GetAsStringSequence();
  if (seq.Length() == 0) {
    return NS_ERROR_FAILURE;
  }
  return Parse(seq, aKeyPath);
}

void KeyPath::SetType(KeyPathType aType) {
  mType = aType;
  mStrings.Clear();
}

bool KeyPath::AppendStringWithValidation(const nsAString& aString) {
  if (!IsValidKeyPathString(aString)) {
    return false;
  }

  if (IsString()) {
    NS_ASSERTION(mStrings.Length() == 0, "Too many strings!");
    mStrings.AppendElement(aString);
    return true;
  }

  if (IsArray()) {
    mStrings.AppendElement(aString);
    return true;
  }

  MOZ_ASSERT_UNREACHABLE("What?!");
  return false;
}

nsresult KeyPath::ExtractKey(JSContext* aCx, const JS::Value& aValue,
                             Key& aKey) const {
  uint32_t len = mStrings.Length();
  JS::Rooted<JS::Value> value(aCx);

  aKey.Unset();

  for (uint32_t i = 0; i < len; ++i) {
    nsresult rv =
        GetJSValFromKeyPathString(aCx, aValue, mStrings[i], value.address(),
                                  DoNotCreateProperties, nullptr, nullptr);
    if (NS_FAILED(rv)) {
      return rv;
    }

    ErrorResult errorResult;
    auto result = aKey.AppendItem(aCx, IsArray() && i == 0, value, errorResult);
    if (!result.Is(Ok, errorResult)) {
      NS_ASSERTION(aKey.IsUnset(), "Encoding error should unset");
      errorResult.SuppressException();
      return NS_ERROR_DOM_INDEXEDDB_DATA_ERR;
    }
  }

  aKey.FinishArray();

  return NS_OK;
}

nsresult KeyPath::ExtractKeyAsJSVal(JSContext* aCx, const JS::Value& aValue,
                                    JS::Value* aOutVal) const {
  NS_ASSERTION(IsValid(), "This doesn't make sense!");

  if (IsString()) {
    return GetJSValFromKeyPathString(aCx, aValue, mStrings[0], aOutVal,
                                     DoNotCreateProperties, nullptr, nullptr);
  }

  const uint32_t len = mStrings.Length();
  JS::Rooted<JSObject*> arrayObj(aCx, JS::NewArrayObject(aCx, len));
  if (!arrayObj) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  JS::Rooted<JS::Value> value(aCx);
  for (uint32_t i = 0; i < len; ++i) {
    nsresult rv =
        GetJSValFromKeyPathString(aCx, aValue, mStrings[i], value.address(),
                                  DoNotCreateProperties, nullptr, nullptr);
    if (NS_FAILED(rv)) {
      return rv;
    }

    if (!JS_DefineElement(aCx, arrayObj, i, value, JSPROP_ENUMERATE)) {
      IDB_REPORT_INTERNAL_ERR();
      return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
    }
  }

  aOutVal->setObject(*arrayObj);
  return NS_OK;
}

nsresult KeyPath::ExtractOrCreateKey(JSContext* aCx, const JS::Value& aValue,
                                     Key& aKey,
                                     ExtractOrCreateKeyCallback aCallback,
                                     void* aClosure) const {
  NS_ASSERTION(IsString(), "This doesn't make sense!");

  JS::Rooted<JS::Value> value(aCx);

  aKey.Unset();

  nsresult rv =
      GetJSValFromKeyPathString(aCx, aValue, mStrings[0], value.address(),
                                CreateProperties, aCallback, aClosure);
  if (NS_FAILED(rv)) {
    return rv;
  }

  ErrorResult errorResult;
  auto result = aKey.AppendItem(aCx, false, value, errorResult);
  if (!result.Is(Ok, errorResult)) {
    NS_ASSERTION(aKey.IsUnset(), "Should be unset");
    errorResult.SuppressException();
    return value.isUndefined() ? NS_OK : NS_ERROR_DOM_INDEXEDDB_DATA_ERR;
  }

  aKey.FinishArray();

  return NS_OK;
}

void KeyPath::SerializeToString(nsAString& aString) const {
  NS_ASSERTION(IsValid(), "Check to see if I'm valid first!");

  if (IsString()) {
    aString = mStrings[0];
    return;
  }

  if (IsArray()) {
    // We use a comma in the beginning to indicate that it's an array of
    // key paths. This is to be able to tell a string-keypath from an
    // array-keypath which contains only one item.
    // It also makes serializing easier :-)
    uint32_t len = mStrings.Length();
    for (uint32_t i = 0; i < len; ++i) {
      aString.Append(',');
      aString.Append(mStrings[i]);
    }

    return;
  }

  MOZ_ASSERT_UNREACHABLE("What?");
}

// static
KeyPath KeyPath::DeserializeFromString(const nsAString& aString) {
  KeyPath keyPath(0);

  if (!aString.IsEmpty() && aString.First() == ',') {
    keyPath.SetType(ARRAY);

    // We use a comma in the beginning to indicate that it's an array of
    // key paths. This is to be able to tell a string-keypath from an
    // array-keypath which contains only one item.
    nsCharSeparatedTokenizerTemplate<IgnoreWhitespace> tokenizer(aString, ',');
    tokenizer.nextToken();
    while (tokenizer.hasMoreTokens()) {
      keyPath.mStrings.AppendElement(tokenizer.nextToken());
    }

    if (tokenizer.separatorAfterCurrentToken()) {
      // There is a trailing comma, indicating the original KeyPath has
      // a trailing empty string, i.e. [..., '']. We should append this
      // empty string.
      keyPath.mStrings.EmplaceBack();
    }

    return keyPath;
  }

  keyPath.SetType(STRING);
  keyPath.mStrings.AppendElement(aString);

  return keyPath;
}

nsresult KeyPath::ToJSVal(JSContext* aCx,
                          JS::MutableHandle<JS::Value> aValue) const {
  if (IsArray()) {
    uint32_t len = mStrings.Length();
    JS::Rooted<JSObject*> array(aCx, JS::NewArrayObject(aCx, len));
    if (!array) {
      IDB_WARNING("Failed to make array!");
      return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
    }

    for (uint32_t i = 0; i < len; ++i) {
      JS::Rooted<JS::Value> val(aCx);
      nsString tmp(mStrings[i]);
      if (!xpc::StringToJsval(aCx, tmp, &val)) {
        IDB_REPORT_INTERNAL_ERR();
        return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
      }

      if (!JS_DefineElement(aCx, array, i, val, JSPROP_ENUMERATE)) {
        IDB_REPORT_INTERNAL_ERR();
        return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
      }
    }

    aValue.setObject(*array);
    return NS_OK;
  }

  if (IsString()) {
    nsString tmp(mStrings[0]);
    if (!xpc::StringToJsval(aCx, tmp, aValue)) {
      IDB_REPORT_INTERNAL_ERR();
      return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
    }
    return NS_OK;
  }

  aValue.setNull();
  return NS_OK;
}

nsresult KeyPath::ToJSVal(JSContext* aCx, JS::Heap<JS::Value>& aValue) const {
  JS::Rooted<JS::Value> value(aCx);
  nsresult rv = ToJSVal(aCx, &value);
  if (NS_SUCCEEDED(rv)) {
    aValue = value;
  }
  return rv;
}

bool KeyPath::IsAllowedForObjectStore(bool aAutoIncrement) const {
  // Any keypath that passed validation is allowed for non-autoIncrement
  // objectStores.
  if (!aAutoIncrement) {
    return true;
  }

  // Array keypaths are not allowed for autoIncrement objectStores.
  if (IsArray()) {
    return false;
  }

  // Neither are empty strings.
  if (IsEmpty()) {
    return false;
  }

  // Everything else is ok.
  return true;
}

}  // namespace indexedDB
}  // namespace dom
}  // namespace mozilla
