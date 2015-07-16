;;; srfi-60.scm --- Integers as Bits

;; Copyright (C) 2005, 2006 Free Software Foundation, Inc.
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

(define-module (srfi srfi-60)
  #:export (bitwise-and
	    bitwise-ior
	    bitwise-xor
	    bitwise-not
	    any-bits-set?
	    bit-count
	    bitwise-if bitwise-merge
	    log2-binary-factors first-set-bit
	    bit-set?
	    copy-bit
	    bit-field
	    copy-bit-field
	    arithmetic-shift
	    rotate-bit-field
	    reverse-bit-field
	    integer->list
	    list->integer
	    booleans->integer)
  #:re-export (logand
	       logior
	       logxor
	       integer-length
	       logtest
	       logcount
	       logbit?
	       ash))

(load-extension "libguile-srfi-srfi-60-v-2" "scm_init_srfi_60")

(define bitwise-and logand)
(define bitwise-ior logior)
(define bitwise-xor logxor)
(define bitwise-not lognot)
(define any-bits-set? logtest)
(define bit-count logcount)

(define (bitwise-if mask n0 n1)
  (logior (logand mask n0)
          (logand (lognot mask) n1)))
(define bitwise-merge bitwise-if)

(define first-set-bit log2-binary-factors)
(define bit-set? logbit?)
(define bit-field bit-extract)

(define (copy-bit-field n newbits start end)
  (logxor n (ash (logxor (bit-extract n start end)              ;; cancel old
			 (bit-extract newbits 0 (- end start))) ;; insert new
		 start)))

(define arithmetic-shift ash)

(cond-expand-provide (current-module) '(srfi-60))
