/*
 *
 * GStreamer
 * Copyright (C) 2004 Dirk Ziegelmeier <dziegel@gmx.de>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

/*
 * 
 * See: http://bugzilla.gnome.org/show_bug.cgi?id=163578
 */

/*
 * This file is copied from TVTIME's sources.
 * Original author: Achim Schneider <batchall@mordor.ch>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#ifndef XAX

#if defined (HAVE_CPU_I386) && !defined(HAVE_CPU_X86_64)

#define XAX   "eax"
#define XBX   "ebx"
#define XCX   "ecx"
#define XDX   "edx"
#define XSI   "esi"
#define XDI   "edi"
#define XSP   "esp"
#define MOVX  "movl"
#define LEAX  "leal"
#define DECX  "decl"
#define PUSHX "pushl"
#define POPX  "popl"
#define CMPX  "cmpl"
#define ADDX  "addl"
#define SHLX  "shll"
#define SHRX  "shrl"
#define SUBX  "subl"

#elif defined (HAVE_CPU_X86_64)

#define XAX   "rax"
#define XBX   "rbx"
#define XCX   "rcx"
#define XDX   "rdx"
#define XSI   "rsi"
#define XDI   "rdi"
#define XSP   "rsp"
#define MOVX  "movq"
#define LEAX  "leaq"
#define DECX  "decq"
#define PUSHX "pushq"
#define POPX  "popq"
#define CMPX  "cmpq"
#define ADDX  "addq"
#define SHLX  "shlq"
#define SHRX  "shrq"
#define SUBX  "subq"

#else
#error Undefined architecture. Define either ARCH_X86 or ARCH_X86_64.
#endif

#endif
