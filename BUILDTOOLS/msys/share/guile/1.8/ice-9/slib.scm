;;;; slib.scm --- definitions needed to get SLIB to work with Guile
;;;;
;;;; Copyright (C) 1997, 1998, 2000, 2001, 2002, 2003, 2004, 2006, 2007 Free Software Foundation, Inc.
;;;;
;;;; This library is free software; you can redistribute it and/or
;;;; modify it under the terms of the GNU Lesser General Public
;;;; License as published by the Free Software Foundation; either
;;;; version 2.1 of the License, or (at your option) any later version.
;;;;
;;;; This library is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;;; Lesser General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU Lesser General Public
;;;; License along with this library; if not, write to the Free Software
;;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;;;;
(define-module (ice-9 slib)
  :export (slib:load slib:load-source defmacro:load
	   implementation-vicinity library-vicinity home-vicinity
	   scheme-implementation-type scheme-implementation-version
	   output-port-width output-port-height array-indexes
	   make-random-state
	   -1+ <? <=? =? >? >=?
	   require slib:error slib:exit slib:warn slib:eval
	   defmacro:eval logical:logand logical:logior logical:logxor
	   logical:lognot logical:ash logical:logcount logical:integer-length
	   logical:bit-extract logical:integer-expt logical:ipow-by-squaring
	   slib:eval-load slib:tab slib:form-feed difftime offset-time
	   software-type)
  :no-backtrace)


;; Initialize SLIB.
(load-from-path "slib/guile.init")

;; SLIB redefines a few core symbols based on their default definition.
;; Thus, we only replace them at this point so that their previous definition
;; is visible when `guile.init' is loaded.
(module-replace! (current-module)
                 '(delete-file open-file provide provided? system))
