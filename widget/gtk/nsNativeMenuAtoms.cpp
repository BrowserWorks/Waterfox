/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsIAtom.h"
#include "nsStaticAtom.h"

#include "nsNativeMenuAtoms.h"

using namespace mozilla;

#define WIDGET_ATOM(_name) nsIAtom* nsNativeMenuAtoms::_name;
#define WIDGET_ATOM2(_name, _value) nsIAtom* nsNativeMenuAtoms::_name;
#include "nsNativeMenuAtomList.h"
#undef WIDGET_ATOM
#undef WIDGET_ATOM2

#define WIDGET_ATOM(name_) NS_STATIC_ATOM_BUFFER(name_##_buffer, #name_)
#define WIDGET_ATOM2(name_, value_) NS_STATIC_ATOM_BUFFER(name_##_buffer, value_)
#include "nsNativeMenuAtomList.h"
#undef WIDGET_ATOM
#undef WIDGET_ATOM2

static const nsStaticAtom gAtoms[] = {
#define WIDGET_ATOM(name_) NS_STATIC_ATOM(name_##_buffer, &nsNativeMenuAtoms::name_),
#define WIDGET_ATOM2(name_, value_) NS_STATIC_ATOM(name_##_buffer, &nsNativeMenuAtoms::name_),
#include "nsNativeMenuAtomList.h"
#undef WIDGET_ATOM
#undef WIDGET_ATOM2
};

/* static */ void
nsNativeMenuAtoms::RegisterAtoms()
{
    NS_RegisterStaticAtoms(gAtoms);
}
