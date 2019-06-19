/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:expandtab:shiftwidth=4:tabstop=4:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __nsNativeMenuAtoms_h__
#define __nsNativeMenuAtoms_h__

class nsIAtom;

class nsNativeMenuAtoms
{
public:
    nsNativeMenuAtoms() = delete;

    static void RegisterAtoms();

#define WIDGET_ATOM(_name) static nsIAtom* _name;
#define WIDGET_ATOM2(_name, _value) static nsIAtom* _name;
#include "nsNativeMenuAtomList.h"
#undef WIDGET_ATOM
#undef WIDGET_ATOM2
};

#endif /* __nsNativeMenuAtoms_h__ */
