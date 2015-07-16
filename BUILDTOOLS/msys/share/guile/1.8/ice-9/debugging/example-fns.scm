(define-module (ice-9 debugging example-fns)
  #:export (fact1 fact2 facti))

(define (fact1 n)
  (if (= n 0)
      1
      (* n (fact1 (- n 1)))))

(define (facti n a)
  (if (= n 0)
      a
      (facti (- n 1) (* a n))))

(define (fact2 n)
  (facti n 1))

; Test: (fact2 3)
