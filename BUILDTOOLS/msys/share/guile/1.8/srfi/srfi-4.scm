;;; srfi-4.scm --- Homogeneous Numeric Vector Datatypes

;; 	Copyright (C) 2001, 2002, 2004, 2006 Free Software Foundation, Inc.
;;
;; This library is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public
;; License as published by the Free Software Foundation; either
;; version 2.1 of the License, or (at your option) any later version.
;; 
;; This library is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public
;; License along with this library; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

;;; Author: Martin Grabmueller <mgrabmue@cs.tu-berlin.de>

;;; Commentary:

;; This module exports the homogeneous numeric vector procedures as
;; defined in SRFI-4.  They are fully documented in the Guile
;; Reference Manual.

;;; Code:

(define-module (srfi srfi-4))

(re-export
;;; Unsigned 8-bit vectors.
 u8vector? make-u8vector u8vector u8vector-length u8vector-ref
 u8vector-set! u8vector->list list->u8vector

;;; Signed 8-bit vectors.
 s8vector? make-s8vector s8vector s8vector-length s8vector-ref
 s8vector-set! s8vector->list list->s8vector

;;; Unsigned 16-bit vectors.
 u16vector? make-u16vector u16vector u16vector-length u16vector-ref
 u16vector-set! u16vector->list list->u16vector

;;; Signed 16-bit vectors.
 s16vector? make-s16vector s16vector s16vector-length s16vector-ref
 s16vector-set! s16vector->list list->s16vector

;;; Unsigned 32-bit vectors.
 u32vector? make-u32vector u32vector u32vector-length u32vector-ref
 u32vector-set! u32vector->list list->u32vector

;;; Signed 32-bit vectors.
 s32vector? make-s32vector s32vector s32vector-length s32vector-ref
 s32vector-set! s32vector->list list->s32vector

;;; Unsigned 64-bit vectors.
 u64vector? make-u64vector u64vector u64vector-length u64vector-ref
 u64vector-set! u64vector->list list->u64vector

;;; Signed 64-bit vectors.
 s64vector? make-s64vector s64vector s64vector-length s64vector-ref
 s64vector-set! s64vector->list list->s64vector

;;; 32-bit floating point vectors.
 f32vector? make-f32vector f32vector f32vector-length f32vector-ref
 f32vector-set! f32vector->list list->f32vector

;;; 64-bit floating point vectors.
 f64vector? make-f64vector f64vector f64vector-length f64vector-ref
 f64vector-set! f64vector->list list->f64vector
 )
