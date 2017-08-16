/*
 * Copyright (c) 2009, Giampaolo Rodola'. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include <Python.h>

static PyObject* psutil_net_if_addrs(PyObject* self, PyObject* args);
static PyObject* psutil_posix_getpriority(PyObject* self, PyObject* args);
static PyObject* psutil_posix_setpriority(PyObject* self, PyObject* args);

#if defined(__FreeBSD__) || defined(__APPLE__)
static PyObject* psutil_net_if_stats(PyObject* self, PyObject* args);
#endif
