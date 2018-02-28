/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsHtml5AtomTable.h"
#include "nsHtml5Atom.h"
#include "nsThreadUtils.h"

nsHtml5AtomEntry::nsHtml5AtomEntry(KeyTypePointer aStr)
  : nsStringHashKey(aStr)
  , mAtom(new nsHtml5Atom(*aStr))
{
}

nsHtml5AtomEntry::nsHtml5AtomEntry(const nsHtml5AtomEntry& aOther)
  : nsStringHashKey(aOther)
  , mAtom(nullptr)
{
  NS_NOTREACHED("nsHtml5AtomTable is broken and tried to copy an entry");
}

nsHtml5AtomEntry::~nsHtml5AtomEntry()
{
}

nsHtml5AtomTable::nsHtml5AtomTable()
  : mRecentlyUsedParserAtoms{}
{
#ifdef DEBUG
  mPermittedLookupEventTarget = mozilla::GetCurrentThreadSerialEventTarget();
#endif
}

nsHtml5AtomTable::~nsHtml5AtomTable()
{
}

nsIAtom*
nsHtml5AtomTable::GetAtom(const nsAString& aKey)
{
#ifdef DEBUG
  {
    MOZ_ASSERT(mPermittedLookupEventTarget->IsOnCurrentThread());
  }
#endif

  uint32_t index = mozilla::HashString(aKey) % RECENTLY_USED_PARSER_ATOMS_SIZE;
  nsIAtom* cachedAtom = mRecentlyUsedParserAtoms[index];
  if (cachedAtom && cachedAtom->Equals(aKey)) {
    return cachedAtom;
  }

  nsIAtom* atom = NS_GetStaticAtom(aKey);
  if (atom) {
    mRecentlyUsedParserAtoms[index] = atom;
    return atom;
  }
  nsHtml5AtomEntry* entry = mTable.PutEntry(aKey);
  if (!entry) {
    return nullptr;
  }

  mRecentlyUsedParserAtoms[index] = entry->GetAtom();
  return entry->GetAtom();
}
