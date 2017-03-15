/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ArrayUtils.h"

#include "nsIAtom.h"
#include "nsString.h"
#include "UTFStrings.h"
#include "nsIServiceManager.h"
#include "nsStaticAtom.h"

#include "gtest/gtest.h"

using namespace mozilla;

namespace TestAtoms {

TEST(Atoms, Basic)
{
  for (unsigned int i = 0; i < ArrayLength(ValidStrings); ++i) {
    nsDependentString str16(ValidStrings[i].m16);
    nsDependentCString str8(ValidStrings[i].m8);

    nsCOMPtr<nsIAtom> atom = NS_Atomize(str16);

    EXPECT_TRUE(atom->Equals(str16));

    nsString tmp16;
    nsCString tmp8;
    atom->ToString(tmp16);
    atom->ToUTF8String(tmp8);
    EXPECT_TRUE(str16.Equals(tmp16));
    EXPECT_TRUE(str8.Equals(tmp8));

    EXPECT_TRUE(nsDependentString(atom->GetUTF16String()).Equals(str16));

    EXPECT_TRUE(nsAtomString(atom).Equals(str16));
    EXPECT_TRUE(nsDependentAtomString(atom).Equals(str16));
    EXPECT_TRUE(nsAtomCString(atom).Equals(str8));
  }
}

TEST(Atoms, 16vs8)
{
  for (unsigned int i = 0; i < ArrayLength(ValidStrings); ++i) {
    nsCOMPtr<nsIAtom> atom16 = NS_Atomize(ValidStrings[i].m16);
    nsCOMPtr<nsIAtom> atom8 = NS_Atomize(ValidStrings[i].m8);
    EXPECT_EQ(atom16, atom8);
  }
}

TEST(Atoms, BufferSharing)
{
  nsString unique;
  unique.AssignLiteral("this is a unique string !@#$");

  nsCOMPtr<nsIAtom> atom = NS_Atomize(unique);

  EXPECT_EQ(unique.get(), atom->GetUTF16String());
}

TEST(Atoms, Null)
{
  nsAutoString str(NS_LITERAL_STRING("string with a \0 char"));
  nsDependentString strCut(str.get());

  EXPECT_FALSE(str.Equals(strCut));

  nsCOMPtr<nsIAtom> atomCut = NS_Atomize(strCut);
  nsCOMPtr<nsIAtom> atom = NS_Atomize(str);

  EXPECT_EQ(atom->GetLength(), str.Length());
  EXPECT_TRUE(atom->Equals(str));
  EXPECT_NE(atom, atomCut);
  EXPECT_TRUE(atomCut->Equals(strCut));
}

TEST(Atoms, Invalid)
{
  for (unsigned int i = 0; i < ArrayLength(Invalid16Strings); ++i) {
    nsrefcnt count = NS_GetNumberOfAtoms();

    {
      nsCOMPtr<nsIAtom> atom16 = NS_Atomize(Invalid16Strings[i].m16);
      EXPECT_TRUE(atom16->Equals(nsDependentString(Invalid16Strings[i].m16)));
    }

    EXPECT_EQ(count, NS_GetNumberOfAtoms());
  }

  for (unsigned int i = 0; i < ArrayLength(Invalid8Strings); ++i) {
    nsrefcnt count = NS_GetNumberOfAtoms();

    {
      nsCOMPtr<nsIAtom> atom8 = NS_Atomize(Invalid8Strings[i].m8);
      nsCOMPtr<nsIAtom> atom16 = NS_Atomize(Invalid8Strings[i].m16);
      EXPECT_EQ(atom16, atom8);
      EXPECT_TRUE(atom16->Equals(nsDependentString(Invalid8Strings[i].m16)));
    }

    EXPECT_EQ(count, NS_GetNumberOfAtoms());
  }

// Don't run this test in debug builds as that intentionally asserts.
#ifndef DEBUG
  nsCOMPtr<nsIAtom> emptyAtom = NS_Atomize("");

  for (unsigned int i = 0; i < ArrayLength(Malformed8Strings); ++i) {
    nsrefcnt count = NS_GetNumberOfAtoms();

    nsCOMPtr<nsIAtom> atom8 = NS_Atomize(Malformed8Strings[i]);
    EXPECT_EQ(atom8, emptyAtom);
    EXPECT_EQ(count, NS_GetNumberOfAtoms());
  }
#endif
}

#define FIRST_ATOM_STR "first static atom. Hello!"
#define SECOND_ATOM_STR "second static atom. @World!"
#define THIRD_ATOM_STR "third static atom?!"

bool
isStaticAtom(nsIAtom* atom)
{
  // Don't use logic && in order to ensure that all addrefs/releases are always
  // run, even if one of the tests fail. This allows us to run this code on a
  // non-static atom without affecting its refcount.
  bool rv = (atom->AddRef() == 2);
  rv &= (atom->AddRef() == 2);
  rv &= (atom->AddRef() == 2);

  rv &= (atom->Release() == 1);
  rv &= (atom->Release() == 1);
  rv &= (atom->Release() == 1);
  return rv;
}

TEST(Atoms, Table)
{
  nsrefcnt count = NS_GetNumberOfAtoms();

  nsCOMPtr<nsIAtom> thirdDynamic = NS_Atomize(THIRD_ATOM_STR);

  EXPECT_FALSE(isStaticAtom(thirdDynamic));

  EXPECT_TRUE(thirdDynamic);
  EXPECT_EQ(NS_GetNumberOfAtoms(), count + 1);
}

}
