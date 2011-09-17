;;; Discrete Math PS-6

;;; Exercise 2

;; attacker's possible list of throws (frequency, aj, ai)
(define a-list
  (list '(1 1 1)
	'(3 2 1)
	'(3 3 1)
	'(3 4 1)
	'(3 5 1)
	'(3 6 1)
	'(4 2 2)
	'(9 3 2)
	'(9 4 2)
	'(9 5 2)
	'(9 6 2)
	'(7 3 3)
	'(15 4 3)
	'(15 5 3)
	'(15 6 3)
	'(10 4 4)
	'(21 5 4)
	'(21 6 4)
	'(13 5 5)
	'(27 6 5)
	'(16 6 6)))

;; defender's possible list of throws using 2 dice (frequency dj di)
(define d2-list
  (list '(1 1 1)
	'(2 2 1)
	'(2 3 1)
	'(2 4 1)
	'(2 5 1)
	'(2 6 1)
	'(1 2 2)
	'(2 3 2)
	'(2 4 2)
	'(2 5 2)
	'(2 6 2)
	'(1 3 3)
	'(2 4 3)
	'(2 5 3)
	'(2 6 3)
	'(1 4 4)
	'(2 5 4)
	'(2 6 4)
	'(1 5 5)
	'(2 6 5)
	'(1 6 6)))

;; defender's possible list of throws using 1 die
(define d1-list '(1 2 3 4 5 6))

;; game1 when the defender throws 1 die all the time
(define (game1)
  (let ((org-d1-list d1-list))
    (define (helper total a-score d-score a-list d1-list)
      (cond ((null? d1-list)
	     (helper total a-score d-score (cdr a-list) org-d1-list))
	    ((null? a-list)
	     (newline)
	     (display (list 'd-score d-score (/ d-score total)))
	     (newline)
	     (display (list 'a-score a-score (/ a-score total)))
	     (newline)
	     (display (list 'total-score (+ d-score a-score) 'total: total)))
	    (else (let ((dj (car d1-list))
			(aj (cadar a-list))
			(a-freq (caar a-list)))
		    (cond ((>= dj aj)
			   (helper (+ total a-freq)
				   a-score
				   (+ d-score a-freq)
				   a-list
				   (cdr d1-list)))
			  (else (helper (+ total a-freq)
					(+ a-score a-freq)
					d-score
					a-list
					(cdr d1-list))))))))
    (helper 0 0 0 a-list d1-list)))

;; test of game1
;(d-score 441 .3402777777777778)
;(a-score 855 .6597222222222222)
;(total-score 1296 total: 1296)

;; game2 when the defender throws 2 dice all the time
(define (game2)
  (let ((org-d2-list d2-list))
    (define (helper total draws a-score d-score a-list d2-list)
      (cond ((null? d2-list)	    
	     (helper total draws a-score d-score (cdr a-list) org-d2-list))
	    ((null? a-list)
	     (newline)
	     (display (list 'd-score: d-score (/ d-score total)))
	     (newline)
	     (display (list 'a-score: a-score (/ a-score total)))
	     (newline)
	     (display (list 'draws: draws (/ draws total)))
	     (newline)
	     (display (list 'total-score: (+ d-score a-score draws) 'total: total)))
	    (else (let ((dj (cadar d2-list))
			(di (caddar d2-list))
			(d-freq (caar d2-list))
			(aj (cadar a-list))
			(ai (caddar a-list))
			(a-freq (caar a-list)))
		    (cond ((and (>= dj aj) (>= di ai))
			   (helper (+ total (* a-freq d-freq))
				   draws
				   a-score
				   (+ d-score (* a-freq d-freq))
				   a-list
				   (cdr d2-list)))
			  ((and (> aj dj) (> ai di))
			   (helper (+ total (* a-freq d-freq))
				   draws
				   (+ a-score (* a-freq d-freq))
				   d-score
				   a-list
				   (cdr d2-list)))
			  (else (helper (+ total (* a-freq d-freq))
					(+ draws (* a-freq d-freq))
					a-score
					d-score
					a-list
					(cdr d2-list))))))))
    (helper 0 0 0 0 a-list d2-list)))

;; test of game2
;(d-score: 2275 .2925668724279835)
;(a-score: 2890 .37165637860082307)
;(draws: 2611 .3357767489711934)
;(total-score: 7776 total: 7776)

;;; Exercise 3

(define (birthday percent)
  (define (helper chance n)
    (cond ((< chance percent)
	   (newline)
	   (display (list 'people (- n 1) 'chance chance))
	   (helper (- 1 (/ (+ (p 365 n)
			      (* (c n 2) (p 365 (- n 1)))
			   (expt 365 n)))
		   (+ n 1)))))
  (helper 0 0))
		 
;(people 0 chance 0)
;(people 1 chance 0)
;(people 2 chance 0)
;(people 3 chance 7.506098705145625e-6)
;(people 4 chance 5.2419303012474217e-5)
;(people 5 chance 1.864206166853899e-4)
;(people 6 chance 4.8175380115778044e-4)
;(people 7 chance 1.029435031951631e-3)
;(people 8 chance 1.9369353288944957e-3)
;(people 9 chance 3.325396970427108e-3)
;(people 10 chance .00532645860152281)
;(people 11 chance 8.078774963128255e-3)
;(people 12 chance 1.1724325740076313e-2)
;(people 13 chance 1.6404613669056878e-2)
;(people 14 chance 2.2256854597167752e-2)
;(people 15 chance .02941026157333615)
;(people 16 chance 3.7982521339541386e-2)
;(people 17 chance .04807655492501983)
;(people 18 chance 5.9777644694731236e-2)
;(people 19 chance .0731509985139367)
;(people 20 chance .08823980809014709)
;(people 21 chance .10506384352663534)
;(people 22 chance .12361861019176246)
;(people 23 chance .14387507771747898)
;(people 24 chance .1657799748280081)
;(people 25 chance .18925662828277512)
;(people 26 chance .21420630997176293)
;(people 27 chance .24051004354465177)
;(people 28 chance .26803081123419514)
;(people 29 chance .29661609301480196)
;(people 30 chance .3261006640968933)
;(people 31 chance .35630957308332856)
;(people 32 chance .38706122190349146)
;(people 33 chance .41817046980582495)
;(people 34 chance .44945168706565597)
;(people 35 chance .4807216894198981)
;(people 36 chance .5118024912869221)
;(people 37 chance .5425238242410414)
;(people 38 chance .5727253766331302)
  

