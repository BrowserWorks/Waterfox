;;; installed-scm-file

;;;; Copyright (C) 1999, 2006 Free Software Foundation, Inc.
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
