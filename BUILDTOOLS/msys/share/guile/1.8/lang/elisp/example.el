
(defun html-page (title &rest contents)
  (concat "<HTML>\n"
	  "<HEAD>\n"
	  "<TITLE>" title "</TITLE>\n"
	  "</HEAD>\n"
	  "<BODY>\n"
	  (apply 'concat contents)
	  "</BODY>\n"
	  "</HTML>\n"))

(defmacro time (repeat-count &rest body)
  `(let ((count ,repeat-count)
	 (beg (current-time))
	 end)
     (while (> count 0)
       (setq count (- count 1))
       ,@body)
     (setq end (current-time))
     (+ (* 1000000.0 (+ (* 65536.0 (- (car end) (car beg)))
			(- (cadr end) (cadr beg))))
	(* 1.0 (- (caddr end) (caddr beg))))))

;Non-scientific performance measurements (Guile measurements are with
;`guile -q --no-debug'):
;
;(time 100000 (+ 3 4))
; => 225,071 (Emacs) 4,000,000 (Guile)
;(time 100000 (lambda () 1))
; => 2,410,456 (Emacs) 4,000,000 (Guile)
;(time 100000 (apply 'concat (mapcar (lambda (s) (concat s "." s)) '("a" "b" "c" "d"))))
; => 10,185,792 (Emacs) 136,000,000 (Guile)
;(defun sc (s) (concat s "." s))
;(time 100000 (apply 'concat (mapcar 'sc  '("a" "b" "c" "d"))))
; => 7,870,055 (Emacs) 26,700,000 (Guile)
;
;Sadly, it looks like the translator's performance sucks quite badly
;when compared with Emacs.  But the translator is still very new, so
;there's probably plenty of room of improvement.
