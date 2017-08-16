/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* atom list for CSS anonymous boxes */

#ifndef nsCSSAnonBoxes_h___
#define nsCSSAnonBoxes_h___

#include "nsIAtom.h"

// Empty class derived from nsIAtom so that function signatures can
// require an atom from this atom list.
class nsICSSAnonBoxPseudo : public nsIAtom {};

class nsCSSAnonBoxes {
public:

  static void AddRefAtoms();

  static bool IsAnonBox(nsIAtom *aAtom);
#ifdef MOZ_XUL
  static bool IsTreePseudoElement(nsIAtom* aPseudo);
#endif
  static bool IsNonElement(nsIAtom* aPseudo)
  {
    return aPseudo == mozText || aPseudo == oofPlaceholder ||
           aPseudo == firstLetterContinuation;
  }

#define CSS_ANON_BOX(_name, _value, _skips_fixup) static nsICSSAnonBoxPseudo* _name;
#include "nsCSSAnonBoxList.h"
#undef CSS_ANON_BOX

  typedef uint8_t NonInheritingBase;
  enum class NonInheriting : NonInheritingBase {
#define CSS_ANON_BOX(_name, _value, _skips_fixup) /* nothing */
#define CSS_NON_INHERITING_ANON_BOX(_name, _value) _name,
#include "nsCSSAnonBoxList.h"
#undef CSS_NON_INHERITING_ANON_BOX
#undef CSS_ANON_BOX
    _Count
  };

  // Be careful using this: if we have a lot of non-inheriting anon box types it
  // might not be very fast.  We may want to think of ways to handle that
  // (e.g. by moving to an enum instead of an atom, like we did for
  // pseudo-elements, or by adding a new value of the pseudo-element enum for
  // non-inheriting anon boxes or something).
  static bool IsNonInheritingAnonBox(nsIAtom* aPseudo)
  {
    return
#define CSS_ANON_BOX(_name, _value, _skips_fixup) /* nothing */
#define CSS_NON_INHERITING_ANON_BOX(_name, _value) _name == aPseudo ||
#include "nsCSSAnonBoxList.h"
#undef CSS_NON_INHERITING_ANON_BOX
#undef CSS_ANON_BOX
      false;
  }

  // Returns whether the given anonymous box skips parent display-based style
  // fixups.  Must only be called with an inheriting anonymous box.  (All
  // non-inheriting anonymous boxes skip this fixup, since it doesn't make
  // sense to perform the fixup with no inherited styles.)
  static bool AnonBoxSkipsParentDisplayBasedStyleFixup(nsIAtom* aPseudo)
  {
    MOZ_ASSERT(!IsNonInheritingAnonBox(aPseudo),
               "only call this for inheriting anonymous boxes");
    return
#define CSS_ANON_BOX(name_, value_, skips_fixup_) \
      (skips_fixup_ && name_ == aPseudo) ||
#define CSS_NON_INHERITING_ANON_BOX(_name, _value) /* nothing */
#include "nsCSSAnonBoxList.h"
#undef CSS_NON_INHERITING_ANON_BOX
#undef CSS_ANON_BOX
      false;
  }

  // Get the NonInheriting type for a given pseudo tag.  The pseudo tag must
  // test true for IsNonInheritingAnonBox.
  static NonInheriting NonInheritingTypeForPseudoTag(nsIAtom* aPseudo);

  // Get the atom for a given non-inheriting anon box type.  aBoxType must be <
  // NonInheriting::_Count.
  static nsIAtom* GetNonInheritingPseudoAtom(NonInheriting aBoxType);
};

#endif /* nsCSSAnonBoxes_h___ */
