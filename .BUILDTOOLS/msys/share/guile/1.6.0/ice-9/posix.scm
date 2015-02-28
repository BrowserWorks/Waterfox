;;; installed-scm-file

;;;; Copyright (C) 1999 Free Software Foundation, Inc.
;;;; 
;;;; This program is free software; you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation; either version 2, or (at your option)
;;;; any later version.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU General Public License
;;;; along with this software; see the file COPYING.  If not, write to
;;;; the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
;;;; Boston, MA 02111-1307 USA
;;;;
;;;; As a special exception, the Free Software Foundation gives permission
;;;; for additional uses of the text contained in its release of GUILE.
;;;;
;;;; The exception is that, if you link the GUILE library with other files
;;;; to produce an executable, this does not by itself cause the
;;;; resulting executable to be covered by the GNU General Public License.
;;;; Your use of that executable is in no way restricted on account of
;;;; linking the GUILE library code into it.
;;;;
;;;; This exception does not however invalidate any other reasons why
;;;; the executable file might be covered by the GNU General Public License.
;;;;
;;;; This exception applies only to the code released by the
;;;; Free Software Foundation under the name GUILE.  If you copy
;;;; code from other Free Software Foundation releases into a copy of
;;;; GUILE, as the General Public License permits, the exception does
;;;; not apply to the code that you add in this way.  To avoid misleading
;;;; anyone as to the status of such modified files, you must delete
;;;; this exception notice from them.
;;;;
;;;; If you write modifications of your own for GUILE, it is your choice
;;;; whether to permit this exception to apply to your modifications.
;;;; If you do not wish that, delete this exception notice.
;;;; 

(define (stat:dev f) (vector-ref f 0))
(define (stat:ino f) (vector-ref f 1))
(define (stat:mode f) (vector-ref f 2))
(define (stat:nlink f) (vector-ref f 3))
(define (stat:uid f) (vector-ref f 4))
(define (stat:gid f) (vector-ref f 5))
(define (stat:rdev f) (vector-ref f 6))
(define (stat:size f) (vector-ref f 7))
(define (stat:atime f) (vector-ref f 8))
(define (stat:mtime f) (vector-ref f 9))
(define (stat:ctime f) (vector-ref f 10))
(define (stat:blksize f) (vector-ref f 11))
(define (stat:blocks f) (vector-ref f 12))

;; derived from stat mode.
(define (stat:type f) (vector-ref f 13))
(define (stat:perms f) (vector-ref f 14))

(define (passwd:name obj) (vector-ref obj 0))
(define (passwd:passwd obj) (vector-ref obj 1))
(define (passwd:uid obj) (vector-ref obj 2))
(define (passwd:gid obj) (vector-ref obj 3))
(define (passwd:gecos obj) (vector-ref obj 4))
(define (passwd:dir obj) (vector-ref obj 5))
(define (passwd:shell obj) (vector-ref obj 6))

(define (group:name obj) (vector-ref obj 0))
(define (group:passwd obj) (vector-ref obj 1))
(define (group:gid obj) (vector-ref obj 2))
(define (group:mem obj) (vector-ref obj 3))

(define (utsname:sysname obj) (vector-ref obj 0))
(define (utsname:nodename obj) (vector-ref obj 1))
(define (utsname:release obj) (vector-ref obj 2))
(define (utsname:version obj) (vector-ref obj 3))
(define (utsname:machine obj) (vector-ref obj 4))

(define (getpwent) (getpw))
(define (setpwent) (setpw #t))
(define (endpwent) (setpw))

(define (getpwnam name) (getpw name))
(define (getpwuid uid) (getpw uid))

(define (getgrent) (getgr))
(define (setgrent) (setgr #t))
(define (endgrent) (setgr))

(define (getgrnam name) (getgr name))
(define (getgrgid id) (getgr id))
