# -*- Mode: python; indent-tabs-mode: nil; tab-width: 40 -*-
# vim: set filetype=python:
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import gdb
import gdb.printing

class GeckoPrettyPrinter(object):
    pp = gdb.printing.RegexpCollectionPrettyPrinter('GeckoPrettyPrinters')

    def __init__(self, name, regexp):
        self.name = name
        self.regexp = regexp

    def __call__(self, wrapped):
        GeckoPrettyPrinter.pp.add_printer(self.name, self.regexp, wrapped)
        return wrapped

import gdbpp.linkedlist
import gdbpp.owningthread
import gdbpp.smartptr
import gdbpp.string
import gdbpp.tarray
import gdbpp.thashtable

gdb.printing.register_pretty_printer(None, GeckoPrettyPrinter.pp)
