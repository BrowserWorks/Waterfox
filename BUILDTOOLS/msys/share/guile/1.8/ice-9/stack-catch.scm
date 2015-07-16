;;; installed-scm-file

;;;; 	Copyright (C) 2001, 2006 Free Software Foundation, Inc.
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

(define-module (ice-9 stack-catch)
  :export (stack-catch))

(define (stack-catch key thunk handler)
  "Like @code{catch}, invoke @var{thunk} in the dynamic context of
@var{handler} for exceptions matching @var{key}, but also save the
current stack state in the @var{the-last-stack} fluid, for the purpose
of debugging or re-throwing of an error.  If thunk throws to the
symbol @var{key}, then @var{handler} is invoked this way:\n
@example
 (handler key args ...)
@end example\n
@var{key} is a symbol or #t.\n
@var{thunk} takes no arguments.  If @var{thunk} returns normally, that
is the return value of @code{catch}.\n
Handler is invoked outside the scope of its own @code{catch}.  If
@var{handler} again throws to the same key, a new handler from further
up the call chain is invoked.\n
If the key is @code{#t}, then a throw to @emph{any} symbol will match
this call to @code{catch}."
  (catch key
	 thunk
	 handler
	 lazy-handler-dispatch))
