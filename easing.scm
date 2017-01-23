(define (linear-ease direction percent)
  (assert (and (<= 0 percent) (>= 1 percent)))
  percent)

(define (quadratic-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (linear-ease 
   direction
   (cond
    ((eq? direction 'in)
     (expt percent 2))
    ((eq? direction 'out)
     (* percent (- 2 percent)))
    ((eq? direction 'inout)
     (let ((p (* percent 2)))
       (if (< p 1)
           (* 0.5 (expt percent 2))
           (let ((p (- p 1)))
             (* -0.5 (- (* p (- p 2)) 1)))))))))

(define (cubic-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (linear-ease
   direction
   (cond
    ((eq? direction 'in)
     (expt percent 3))
    ((eq? direction 'out)
     (let ((p (- percent 1)))
       (+ 1 (expt p 3))))
    ((eq? direction 'inout)
     (let ((p (* percent 2)))
       (if (< p 1)
           (* 0.5 (expt p 3))
           (let ((p (- p 2)))
             (* 0.5 (+ 2 (expt p 3))))))))))

(define (quartic-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (linear-ease
   direction
   (cond
    ((eq? direction 'in)
     (expt percent 4))
    ((eq? direction 'out)
     (let ((p (- percent 1)))
       (- 1 (expt p 4))))
    ((eq? direction 'inout)
     (let ((p (* percent 2)))
       (if (< p 1)
           (* 0.5 (expt p 4))
           (let ((p (- p 2)))
             (* -0.5 (- (expt p 4) 2)))))))))

(define (quintic-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (linear-ease
   direction
   (cond
    ((eq? direction 'in)
     (expt percent 5))
    ((eq? direction 'out)
     (let ((p (- percent 1)))
       (+ 1 (expt p 5))))
    ((eq? direction 'inout)
     (let ((p (* percent 2)))
       (if (< p 1)
           (* 0.5 (expt p 5))
           (let ((p (- p 2)))
             (* 0.5 (+ (expt p 5) 2)))))))))

(define (sinusoidal-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (define pi 3.14159265358979)
  (linear-ease
   direction
   (cond
    ((eq? direction 'in)
     (- 1 (cos (* percent pi 0.5))))
    ((eq? direction 'out)
     (sin (* percent pi 0.5)))
    ((eq? direction 'inout)
     (* 0.5 (- 1 (cos (* pi percent))))))))

(define (exponential-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (linear-ease
   direction
   (cond
    ((eq? direction 'in)
     (if (= percent 0) 
         0
         (expt 1024 (- percent 1))))
    ((eq? direction 'out)
     (if (= percent 1)
         1
         (- 1 (expt 2 (* -10 percent)))))
    ((eq? direction 'inout)
     (cond
      ((= percent 0) 0)
      ((= percent 1) 1)
      ((< (* percent 2) 1)
       (* 0.5 (expt 1024 (- (* percent 2) 1))))
      (else
       (* 0.5 (- 2 (expt 2 (* -10 (- (* percent 2) 1)))))))))))

(define (circular-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (linear-ease
   direction
   (cond
    ((eq? direction 'in)
     (- 1 (sqrt (- 1 (expt percent 2)))))
    ((eq? direction 'out)
     (sqrt (- 1 (expt (- percent 1) 2))))
    ((eq? direction 'inout)
     (let ((p (* percent 2)))
       (if (< p 1)
           (* -0.5 (- (sqrt (- 1 (expt p 2))) 1))
           (* 0.5 (+ (sqrt (- 1 (expt (- p 2) 2))) 1))))))))

(define (elastic-ease direction percent #!optional (a 1.0) (p 0.4))
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (define pi 3.14159265358979)
  (define invpi (/ 1 pi))
  (define invp (/ 1 p))
  (define k
    (let ((s (if (< a 1)
                 (/ p 4)
                 (* p (asin (/ 1 a)) 0.5 invpi)))
          (a (if (< a 1) 1 a)))
      (cond
       ((= percent 0) 0)
       ((= percent 1) 1)
       ((eq? direction 'in)
        (let ((percent (- percent 1)))
          (- (* a 
                (expt 2 (* 10 percent))
                (sin (* (- percent s) 2 pi invp))))))
       ((eq? direction 'out)
        (+ (* a 
              (expt 2 (* -10 percent))
              (sin (* (- percent s) 2 pi invp)))
           1))
       ((eq? direction 'inout)
        (let ((p (* percent 2)))
          (if (< p 1)
              (* -0.5 a 
                 (expt 2 (* 10 (- p 1)))
                 (sin (* (- p 1 s) 2 pi invp)))
              (+ 1 (* a 0.5 
                      (expt 2 (* -10 (- p 1)))
                      (sin (* (- p 1 s) 2 pi invp))))))))))
  (linear-ease 
   direction
   (cond
    ((< k 0) 0)
    ((> k 1) 1)
    (else k))))

(define (back-ease direction percent #!optional (s 1.70158))
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (define k (cond
             ((eq? direction 'in)
              (* (expt percent 2)
                 (- (* percent (+ s 1)) s)))
             ((eq? direction 'out)
              (let ((p (- percent 1)))
                (+ 1 (* (expt p 2)
                        (+ s (* p (+ s 1)))))))
             ((eq? direction 'inout)
              (let ((s (* s 1.525))
                    (p (* percent 2)))
                (if (< p 1)
                    (* 0.5 (* (expt p 2) (- (* p (+ s 1)) s)))
                    (let ((p (- p 2)))
                      (* 0.5 (+ 2 (* (expt p 2) (+ s (* p (+ s 1))))))))))))
  (linear-ease
   direction
   (cond
    ((< k 0) 0)
    ((> k 1) 1)
    (else k))))

(define (bounce-ease direction percent)
  (assert (or (eq? direction 'in) (eq? direction 'out) (eq? direction 'inout)))
  (define (out p)
    (cond
     ((< p (/ 1 2.75))
      (* 7.5625 (expt p 2)))
     ((< p (/ 2 2.75))
      (let ((p (- p (/ 1.5 2.75))))
        (+ 0.75 (* 7.5625 (expt p 2)))))
     ((< p (/ 2.5 2.75))
      (let ((p (- p (/ 2.25 2.75))))
        (+ 0.9375 (* 7.5625 (expt p 2)))))
     (else 
      (let ((p (- p (/ 2.625 2.75))))
        (+ 0.984375 (* 7.5625 (expt p 2)))))))
  (define (in p)
    (- 1 (out (- 1 p))))
  (linear-ease 
   direction
   (cond
    ((eq? direction 'in)
     (in percent))
    ((eq? direction 'out)
     (out percent))
    ((eq? direction 'inout)
     (if (< percent 0.5)
         (* 0.5 (in (* percent 2)))
         (+ 0.5 (* 0.5 (out (- (* percent 2) 1)))))))))
