;;; gap-buffer.scm --- String buffer that supports point

;;;	Copyright (C) 2002, 2003, 2006 Free Software Foundation, Inc.
;;;
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
;;;

;;; Author: Thien-Thi Nguyen <ttn@gnu.org>

;;; Commentary:

;; A gap buffer is a structure that models a string but allows relatively
;; efficient insertion of text somewhere in the middle.  The insertion
;; location is called `point' with minimum value 1, and a maximum value of the
;; length of the string (which is not fixed).
;;
;; Specifically, we allocate a continuous buffer of characters that is
;; composed of the BEFORE, the GAP and the AFTER (reading L->R), like so:
;;
;;                          +--- POINT
;;                          v
;;    +--------------------+--------------------+--------------------+
;;    |       BEFORE       |        GAP         |       AFTER        |
;;    +--------------------+--------------------+--------------------+
;;
;;     <----- bef-sz ----->|<----- gap-sz ----->|<----- aft-sz ----->
;;
;;     <-------------------|       usr-sz       |------------------->
;;
;;     <-------------------------- all-sz -------------------------->
;;
;; This diagram also shows how the different sizes are computed, and the
;; location of POINT.  Note that the user-visible buffer size `usr-sz' does
;; NOT include the GAP, while the allocation `all-sz' DOES.
;;
;; The consequence of this arrangement is that "moving point" is simply a
;; matter of kicking characters across the GAP, while insertion can be viewed
;; as filling up the gap, increasing `bef-sz' and decreasing `gap-sz'.  When
;; `gap-sz' falls below some threshold, we reallocate with a larger `all-sz'.
;;
;; In the implementation, we actually keep track of the AFTER start offset
;; `aft-ofs' since it is used more often than `gap-sz'.  In fact, most of the
;; variables in the diagram are for conceptualization only.
;;
;; A gap buffer port is a soft port (see Guile manual) that wraps a gap
;; buffer.  Character and string writes, as well as character reads, are
;; supported.  Flushing and closing are not supported.
;;
;; These procedures are exported:
;;   (gb? OBJ)
;;   (make-gap-buffer . INIT)
;;   (gb-point GB)
;;   (gb-point-min GB)
;;   (gb-point-max GB)
;;   (gb-insert-string! GB STRING)
;;   (gb-insert-char! GB CHAR)
;;   (gb-delete-char! GB COUNT)
;;   (gb-goto-char GB LOCATION)
;;   (gb->string GB)
;;   (gb-filter! GB STRING-PROC)
;;   (gb->lines GB)
;;   (gb-filter-lines! GB LINES-PROC)
;;   (make-gap-buffer-port GB)
;;
;; INIT is an optional port or a string.  COUNT and LOCATION are integers.
;; STRING-PROC is a procedure that takes and returns a string.  LINES-PROC is
;; a procedure that takes and returns a list of strings, each representing a
;; line of text (newlines are stripped and added back automatically).
;;
;; (The term and concept of "gap buffer" are borrowed from Emacs.  We will
;; gladly return them when libemacs.so is available. ;-)
;;
;; Notes:
;; - overrun errors are suppressed silently

;;; Code:

(define-module (ice-9 gap-buffer)
  :autoload (srfi srfi-13) (string-join)
  :export (gb?
           make-gap-buffer
           gb-point
           gb-point-min
           gb-point-max
           gb-insert-string!
           gb-insert-char!
           gb-delete-char!
           gb-erase!
           gb-goto-char
           gb->string
           gb-filter!
           gb->lines
           gb-filter-lines!
           make-gap-buffer-port))

(define gap-buffer
  (make-record-type 'gap-buffer
                    '(s                 ; the buffer, a string
                      all-sz            ; total allocation
                      gap-ofs           ; GAP starts, aka (1- point)
                      aft-ofs           ; AFTER starts
                      )))

(define gb? (record-predicate gap-buffer))

(define s:       (record-accessor gap-buffer 's))
(define all-sz:  (record-accessor gap-buffer 'all-sz))
(define gap-ofs: (record-accessor gap-buffer 'gap-ofs))
(define aft-ofs: (record-accessor gap-buffer 'aft-ofs))

(define s!       (record-modifier gap-buffer 's))
(define all-sz!  (record-modifier gap-buffer 'all-sz))
(define gap-ofs! (record-modifier gap-buffer 'gap-ofs))
(define aft-ofs! (record-modifier gap-buffer 'aft-ofs))

;; todo: expose
(define default-initial-allocation 128)
(define default-chunk-size 128)
(define default-realloc-threshold 32)

(define (round-up n)
  (* default-chunk-size (+ 1 (quotient n default-chunk-size))))

(define new (record-constructor gap-buffer '()))

(define (realloc gb inc)
  (let* ((old-s   (s: gb))
         (all-sz  (all-sz: gb))
         (new-sz  (+ all-sz inc))
         (gap-ofs (gap-ofs: gb))
         (aft-ofs (aft-ofs: gb))
         (new-s   (make-string new-sz))
         (new-aft-ofs (+ aft-ofs inc)))
    (substring-move! old-s 0 gap-ofs new-s 0)
    (substring-move! old-s aft-ofs all-sz new-s new-aft-ofs)
    (s! gb new-s)
    (all-sz! gb new-sz)
    (aft-ofs! gb new-aft-ofs)))

(define (make-gap-buffer . init)        ; port/string
  (let ((gb (new)))
    (cond ((null? init)
           (s! gb (make-string default-initial-allocation))
           (all-sz! gb default-initial-allocation)
           (gap-ofs! gb 0)
           (aft-ofs! gb default-initial-allocation))
          (else (let ((jam! (lambda (string len)
                              (let ((alloc (round-up len)))
                                (s! gb (make-string alloc))
                                (all-sz! gb alloc)
                                (substring-move! string 0 len (s: gb) 0)
                                (gap-ofs! gb len)
                                (aft-ofs! gb alloc))))
                      (v (car init)))
                  (cond ((port? v)
                         (let ((next (lambda () (read-char v))))
                           (let loop ((c (next)) (acc '()) (len 0))
                             (if (eof-object? c)
                                 (jam! (list->string (reverse acc)) len)
                                 (loop (next) (cons c acc) (1+ len))))))
                        ((string? v)
                         (jam! v (string-length v)))
                        (else (error "bad init type"))))))
    gb))

(define (gb-point gb)
  (1+ (gap-ofs: gb)))

(define (gb-point-min gb) 1)            ; no narrowing (for now)

(define (gb-point-max gb)
  (1+ (- (all-sz: gb) (- (aft-ofs: gb) (gap-ofs: gb)))))

(define (insert-prep gb len)
  (let* ((gap-ofs (gap-ofs: gb))
         (aft-ofs (aft-ofs: gb))
         (slack (- (- aft-ofs gap-ofs) len)))
    (and (< slack default-realloc-threshold)
         (realloc gb (round-up (- slack))))
    gap-ofs))

(define (gb-insert-string! gb string)
  (let* ((len (string-length string))
         (gap-ofs (insert-prep gb len)))
    (substring-move! string 0 len (s: gb) gap-ofs)
    (gap-ofs! gb (+ gap-ofs len))))

(define (gb-insert-char! gb char)
  (let ((gap-ofs (insert-prep gb 1)))
    (string-set! (s: gb) gap-ofs char)
    (gap-ofs! gb (+ gap-ofs 1))))

(define (gb-delete-char! gb count)
  (cond ((< count 0)                    ; backwards
         (gap-ofs! gb (max 0 (+ (gap-ofs: gb) count))))
        ((> count 0)                    ; forwards
         (aft-ofs! gb (min (all-sz: gb) (+ (aft-ofs: gb) count))))
        ((= count 0)                    ; do nothing
         #t)))

(define (gb-erase! gb)
  (gap-ofs! gb 0)
  (aft-ofs! gb (all-sz: gb)))

(define (point++n! gb n s gap-ofs aft-ofs) ; n>0; warning: reckless
  (substring-move! s aft-ofs (+ aft-ofs n) s gap-ofs)
  (gap-ofs! gb (+ gap-ofs n))
  (aft-ofs! gb (+ aft-ofs n)))

(define (point+-n! gb n s gap-ofs aft-ofs) ; n<0; warning: reckless
  (substring-move! s (+ gap-ofs n) gap-ofs s (+ aft-ofs n))
  (gap-ofs! gb (+ gap-ofs n))
  (aft-ofs! gb (+ aft-ofs n)))

(define (gb-goto-char gb new-point)
  (let ((pmax (gb-point-max gb)))
    (or (and (< new-point 1)    (gb-goto-char gb 1))
        (and (> new-point pmax) (gb-goto-char gb pmax))
        (let ((delta (- new-point (gb-point gb))))
          (or (= delta 0)
              ((if (< delta 0)
                   point+-n!
                   point++n!)
               gb delta (s: gb) (gap-ofs: gb) (aft-ofs: gb))))))
  new-point)

(define (gb->string gb)
  (let ((s (s: gb)))
    (string-append (substring s 0 (gap-ofs: gb))
                   (substring s (aft-ofs: gb)))))

(define (gb-filter! gb string-proc)
  (let ((new (string-proc (gb->string gb))))
    (gb-erase! gb)
    (gb-insert-string! gb new)))

(define (gb->lines gb)
  (let ((str (gb->string gb)))
    (let loop ((start 0) (acc '()))
      (cond ((string-index str #\newline start)
             => (lambda (w)
                  (loop (1+ w) (cons (substring str start w) acc))))
            (else (reverse (cons (substring str start) acc)))))))

(define (gb-filter-lines! gb lines-proc)
  (let ((new-lines (lines-proc (gb->lines gb))))
    (gb-erase! gb)
    (gb-insert-string! gb (string-join new-lines #\newline))))

(define (make-gap-buffer-port gb)
  (or (gb? gb)
      (error "not a gap-buffer:" gb))
  (make-soft-port
   (vector
    (lambda (c) (gb-insert-char! gb c))
    (lambda (s) (gb-insert-string! gb s))
    #f
    (lambda () (let ((gap-ofs (gap-ofs: gb))
                     (aft-ofs (aft-ofs: gb)))
                 (if (= aft-ofs (all-sz: gb))
                     #f
                     (let* ((s (s: gb))
                            (c (string-ref s aft-ofs)))
                       (string-set! s gap-ofs c)
                       (gap-ofs! gb (1+ gap-ofs))
                       (aft-ofs! gb (1+ aft-ofs))
                       c))))
    #f)
   "rw"))

;;; gap-buffer.scm ends here
