;; =============================================================================
;;      Converted isurp-old.metta ALGORITHM (MM2 / MORK)
;; ============================================================================

        ;;****************************
        ;; conditional based calling
        ;;****************************

;; =============================================================================
;;  Main Function Calling: isurp-old (2-Conjunct Pattern)
;; =============================================================================

    ;; calling with two conjection c1 and c2 and assing conject with index value
(exec (freq 080 isurp-start-2)
  (, (isurp-old (, $c1 $c2) $db $norm))
  (O
    (pure (isurp2-init $ctx (, $c1 $c2) $db $norm) $ctx
      (vars_to_indices (' (, $c1 $c2))))
    (- (isurp-old (, $c1 $c2) $db $norm))))

    ;; initialize with zero value all count of partition and joint at first 
(exec (freq 081 isurp-init-2-b)
  (, (isurp2-init $ctx (, $c1 $c2) $db $norm))
  (O
    (+ (isurp2-eval $ctx ($c1 $c2) $db $norm))
    (+ (isurp2-cnt-total $ctx $norm 0))
    (+ (isurp2-cnt-j $ctx $norm 0))
    (+ (isurp2-cnt-1 $ctx $norm 0))
    (+ (isurp2-cnt-2 $ctx $norm 0))
    (- (isurp2-init $ctx (, $c1 $c2) $db $norm))))

    ;; total match count from atomespace
(exec (freq 082 isurp2-cnt-db)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $atom)
     (isurp2-cnt-total $ctx $norm 0))
  (O
    (count (isurp2-cnt-total $ctx $norm $n) $n $atom)
    (- (isurp2-cnt-total $ctx $norm 0))))

    ;; total joint count from all partition
(exec (freq 082 isurp2-cnt-joint)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $c1)
     ($db $c2)
     (isurp2-cnt-j $ctx $norm 0))
  (O
    (count (isurp2-cnt-j $ctx $norm $j) $j ($c1 $c2))
    (- (isurp2-cnt-j $ctx $norm 0))))

    ;;total match with conjection one pattern
(exec (freq 082 isurp2-cnt-one)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $c1)
     (isurp2-cnt-1 $ctx $norm 0))
  (O
    (count (isurp2-cnt-1 $ctx $norm $k1) $k1 $c1)
    (- (isurp2-cnt-1 $ctx $norm 0))))

    ;;total match count with conject two from space
(exec (freq 082 isurp2-cnt-two)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     ($db $c2)
     (isurp2-cnt-2 $ctx $norm 0))
  (O
    (count (isurp2-cnt-2 $ctx $norm $k2) $k2 $c2)
    (- (isurp2-cnt-2 $ctx $norm 0))))

    ;; here to get mathmatical bilomial calculation
(exec (freq 083 isurp2-calc)
  (, (isurp2-eval $ctx ($c1 $c2) $db $norm)
     (isurp2-cnt-total $ctx $norm $n)
     (isurp2-cnt-j $ctx $norm $j)
     (isurp2-cnt-1 $ctx $norm $k1)
     (isurp2-cnt-2 $ctx $norm $k2))
  (O
    (pure (isurp2-p-joint $ctx $norm $ppat) $ppat
      (f64_to_string
        (div_f64
          (f64_from_string $j)
          (f64_from_string
            (i64_to_string
              (div_i64
                (falling_factorial (i64_from_string $n) (i64_from_string 2))
                (factorial (i64_from_string 2))))))))
    (pure (isurp2-p-indep $ctx $norm $pindep) $pindep
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k1)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 2))
                  (factorial (i64_from_string 2))))))
          (div_f64
            (f64_from_string $k2)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 2))
                  (factorial (i64_from_string 2)))))))))
    (- (isurp2-eval $ctx ($c1 $c2) $db $norm))
    (- (isurp2-cnt-total $ctx $norm $n))
    (- (isurp2-cnt-j $ctx $norm $j))
    (- (isurp2-cnt-1 $ctx $norm $k1))
    (- (isurp2-cnt-2 $ctx $norm $k2))))

    ;; Last result with Non Normalized(False)
(exec (freq 084 isurp2-emit-false)
  (, (isurp2-p-joint $ctx False $ppat)
     (isurp2-p-indep $ctx False $pindep))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (abs_f64
            (sub_f64
              (f64_from_string $ppat)
              (clamp_f64
                (f64_from_string $ppat)
                (f64_from_string $pindep)
                (f64_from_string $pindep))))
          (f64_from_string 1.0))))
    (- (isurp2-p-joint $ctx False $ppat))
    (- (isurp2-p-indep $ctx False $pindep))))

        ;; Last result with Non Normalized(True)
(exec (freq 084 isurp2-emit-true)
  (, (isurp2-p-joint $ctx True $ppat)
     (isurp2-p-indep $ctx True $pindep))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (div_f64
            (abs_f64
              (sub_f64
                (f64_from_string $ppat)
                (clamp_f64
                  (f64_from_string $ppat)
                  (f64_from_string $pindep)
                  (f64_from_string $pindep))))
            (max_f64 (f64_from_string $pindep) (f64_from_string $ppat)))
          (f64_from_string 1.0))))
    (- (isurp2-p-joint $ctx True $ppat))
    (- (isurp2-p-indep $ctx True $pindep))))


;; =============================================================================
;; 2. Main Function Calling: isurp-old (3-Conjunct Pattern)
;; =============================================================================

 
(exec (freq 080 isurp-start-3)
  (, (isurp-old (, $c1 $c2 $c3) $db $norm))
  (O
    (pure (isurp3-init $ctx (, $c1 $c2 $c3) $db $norm) $ctx
      (vars_to_indices (' (, $c1 $c2 $c3))))
    (- (isurp-old (, $c1 $c2 $c3) $db $norm))))

 ;;; initalize the value with zero for for each  possible condition 
(exec (freq 081 isurp-init-3-b)
  (, (isurp3-init $ctx (, $c1 $c2 $c3) $db $norm))
  (O
    (+ (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm))
    (+ (isurp3-cnt-total $ctx $norm 0))
    (+ (isurp3-cnt-j $ctx $norm 0))
    (+ (isurp3-cnt-1 $ctx $norm 0))
    (+ (isurp3-cnt-2 $ctx $norm 0))
    (+ (isurp3-cnt-3 $ctx $norm 0))
    (+ (isurp3-cnt-12 $ctx $norm 0))
    (+ (isurp3-cnt-13 $ctx $norm 0))
    (+ (isurp3-cnt-23 $ctx $norm 0))
    (- (isurp3-init $ctx (, $c1 $c2 $c3) $db $norm))))

    ;; Count total Database/Atome size 
(exec (freq 082 isurp3-cnt-total)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $atom)
     (isurp3-cnt-total $ctx $norm 0))
  (O
    (count (isurp3-cnt-total $ctx $norm $n) $n $atom)
    (- (isurp3-cnt-total $ctx $norm 0))))

     ;; count the joint score with three condition and return/preserve to next
(exec (freq 082 isurp3-cnt-j)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     ($db $c2)
     ($db $c3)
     (isurp3-cnt-j $ctx $norm 0))
  (O
    (count (isurp3-cnt-j $ctx $norm $j) $j ($c1 $c2 $c3))
    (- (isurp3-cnt-j $ctx $norm 0))))
    

    ;; count each of condition with match pattern from atomspace 
(exec (freq 082 isurp3-cnt-1)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     (isurp3-cnt-1 $ctx $norm 0))
  (O
    (count (isurp3-cnt-1 $ctx $norm $k1) $k1 $c1)
    (- (isurp3-cnt-1 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-2)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c2)
     (isurp3-cnt-2 $ctx $norm 0))
  (O
    (count (isurp3-cnt-2 $ctx $norm $k2) $k2 $c2)
    (- (isurp3-cnt-2 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-3)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c3)
     (isurp3-cnt-3 $ctx $norm 0))
  (O
    (count (isurp3-cnt-3 $ctx $norm $k3) $k3 $c3)
    (- (isurp3-cnt-3 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-12)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     ($db $c2)
     (isurp3-cnt-12 $ctx $norm 0))
  (O
    (count (isurp3-cnt-12 $ctx $norm $k12) $k12 ($c1 $c2))
    (- (isurp3-cnt-12 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-13)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c1)
     ($db $c3)
     (isurp3-cnt-13 $ctx $norm 0))
  (O
    (count (isurp3-cnt-13 $ctx $norm $k13) $k13 ($c1 $c3))
    (- (isurp3-cnt-13 $ctx $norm 0))))

(exec (freq 082 isurp3-cnt-23)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     ($db $c2)
     ($db $c3)
     (isurp3-cnt-23 $ctx $norm 0))
  (O
    (count (isurp3-cnt-23 $ctx $norm $k23) $k23 ($c2 $c3))
    (- (isurp3-cnt-23 $ctx $norm 0))))



 ;;; after we get the each of count value with it's condition 
(exec (freq 083 isurp3-calc)
  (, (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm)
     (isurp3-cnt-total $ctx $norm $n)
     (isurp3-cnt-j $ctx $norm $j)
     (isurp3-cnt-1 $ctx $norm $k1)
     (isurp3-cnt-2 $ctx $norm $k2)
     (isurp3-cnt-3 $ctx $norm $k3)
     (isurp3-cnt-12 $ctx $norm $k12)
     (isurp3-cnt-13 $ctx $norm $k13)
     (isurp3-cnt-23 $ctx $norm $k23))
  (O
    (pure (isurp3-pj $ctx $norm $ppat) $ppat
      (f64_to_string
        (div_f64
          (f64_from_string $j)
          (f64_from_string
            (i64_to_string
              (div_i64
                (falling_factorial (i64_from_string $n) (i64_from_string 3))
                (factorial (i64_from_string 3))))))))
    (pure (isurp3-p1 $ctx $norm $p1) $p1
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k12)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3))))))
          (div_f64
            (f64_from_string $k3)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (pure (isurp3-p2 $ctx $norm $p2) $p2
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k13)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3))))))
          (div_f64
            (f64_from_string $k2)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (pure (isurp3-p3 $ctx $norm $p3) $p3
      (f64_to_string
        (product_f64
          (div_f64
            (f64_from_string $k1)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3))))))
          (div_f64
            (f64_from_string $k23)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (pure (isurp3-p4 $ctx $norm $p4) $p4
      (f64_to_string
        (product_f64
          (product_f64
            (div_f64
              (f64_from_string $k1)
              (f64_from_string
                (i64_to_string
                  (div_i64
                    (falling_factorial (i64_from_string $n) (i64_from_string 3))
                    (factorial (i64_from_string 3))))))
            (div_f64
              (f64_from_string $k2)
              (f64_from_string
                (i64_to_string
                  (div_i64
                    (falling_factorial (i64_from_string $n) (i64_from_string 3))
                    (factorial (i64_from_string 3)))))))
          (div_f64
            (f64_from_string $k3)
            (f64_from_string
              (i64_to_string
                (div_i64
                  (falling_factorial (i64_from_string $n) (i64_from_string 3))
                  (factorial (i64_from_string 3)))))))))
    (- (isurp3-eval $ctx ($c1 $c2 $c3) $db $norm))
    (- (isurp3-cnt-total $ctx $norm $n))
    (- (isurp3-cnt-j $ctx $norm $j))
    (- (isurp3-cnt-1 $ctx $norm $k1))
    (- (isurp3-cnt-2 $ctx $norm $k2))
    (- (isurp3-cnt-3 $ctx $norm $k3))
    (- (isurp3-cnt-12 $ctx $norm $k12))
    (- (isurp3-cnt-13 $ctx $norm $k13))
    (- (isurp3-cnt-23 $ctx $norm $k23))))


      ;; here get min and max value from set of partition
(exec (freq 084 isurp3-minmax)
  (, (isurp3-pj $ctx $norm $ppat)
     (isurp3-p1 $ctx $norm $p1)
     (isurp3-p2 $ctx $norm $p2)
     (isurp3-p3 $ctx $norm $p3)
     (isurp3-p4 $ctx $norm $p4))
  (O
    (pure (isurp3-emin $ctx $norm $emin) $emin (min-atom (' ($p1 $p2 $p3 $p4))))
    (pure (isurp3-emax $ctx $norm $emax) $emax (max-atom (' ($p1 $p2 $p3 $p4))))
    (- (isurp3-p1 $ctx $norm $p1))
    (- (isurp3-p2 $ctx $norm $p2))
    (- (isurp3-p3 $ctx $norm $p3))
    (- (isurp3-p4 $ctx $norm $p4))))

    ;; With Raw or nonormalized 
(exec (freq 085 isurp3-emit-raw)
  (, (isurp3-pj $ctx False $ppat)
     (isurp3-emin $ctx False $emin)
     (isurp3-emax $ctx False $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (abs_f64
            (sub_f64
              (f64_from_string $ppat)
              (clamp_f64
                (f64_from_string $ppat)
                (f64_from_string $emin)
                (f64_from_string $emax))))
          (f64_from_string 1.0))))
    (- (isurp3-pj $ctx False $ppat))
    (- (isurp3-emin $ctx False $emin))
    (- (isurp3-emax $ctx False $emax))))

  ;;  With Normalize 
(exec (freq 085 isurp3-emit-norm)
  (, (isurp3-pj $ctx True $ppat)
     (isurp3-emin $ctx True $emin)
     (isurp3-emax $ctx True $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (div_f64
            (abs_f64
              (sub_f64
                (f64_from_string $ppat)
                (clamp_f64
                  (f64_from_string $ppat)
                  (f64_from_string $emin)
                  (f64_from_string $emax))))
            (max_f64 (f64_from_string $emax) (f64_from_string $ppat)))
          (f64_from_string 1.0))))
    (- (isurp3-pj $ctx True $ppat))
    (- (isurp3-emin $ctx True $emin))
    (- (isurp3-emax $ctx True $emax))))


;; =============================================================================
;; 3. Main Function Calling: isurp-old (4-Conjunct Pattern)
;; =============================================================================

(exec (freq 080 isurp-start-4)
  (, (isurp-old (, $c1 $c2 $c3 $c4) $db $norm))
  (O
    (pure (isurp4-init $ctx (, $c1 $c2 $c3 $c4) $db $norm) $ctx
      (vars_to_indices (' (, $c1 $c2 $c3 $c4))))
    (- (isurp-old (, $c1 $c2 $c3 $c4) $db $norm))))

(exec (freq 081 isurp-init-4-b)
  (, (isurp4-init $ctx (, $c1 $c2 $c3 $c4) $db $norm))
  (O
    (+ (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm))
    (+ (isurp4-cnt-total $ctx $norm 0))
    (+ (isurp4-cnt-j $ctx $norm 0))
    (+ (isurp4-cnt-1 $ctx $norm 0))
    (+ (isurp4-cnt-2 $ctx $norm 0))
    (+ (isurp4-cnt-3 $ctx $norm 0))
    (+ (isurp4-cnt-4 $ctx $norm 0))
    (+ (isurp4-cnt-12 $ctx $norm 0))
    (+ (isurp4-cnt-13 $ctx $norm 0))
    (+ (isurp4-cnt-14 $ctx $norm 0))
    (+ (isurp4-cnt-23 $ctx $norm 0))
    (+ (isurp4-cnt-24 $ctx $norm 0))
    (+ (isurp4-cnt-34 $ctx $norm 0))
    (+ (isurp4-cnt-123 $ctx $norm 0))
    (+ (isurp4-cnt-124 $ctx $norm 0))
    (+ (isurp4-cnt-134 $ctx $norm 0))
    (+ (isurp4-cnt-234 $ctx $norm 0))
    (- (isurp4-init $ctx (, $c1 $c2 $c3 $c4) $db $norm))))

    ;; Database count with atom size and store with n variable
(exec (freq 082 isurp4-cnt-total)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $atom)
     (isurp4-cnt-total $ctx $norm 0))
  (O
    (count (isurp4-cnt-total $ctx $norm $n) $n $atom)
    (- (isurp4-cnt-total $ctx $norm 0))))

    ;; if the joint are 0, all component are appeared with atomspace count joint as alone 
(exec (freq 082 isurp4-cnt-j)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) ($db $c3) ($db $c4)
     (isurp4-cnt-j $ctx $norm 0))
  (O
    (count (isurp4-cnt-j $ctx $norm $j) $j ($c1 $c2 $c3 $c4))
    (- (isurp4-cnt-j $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-1)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) 
     (isurp4-cnt-1 $ctx $norm 0))
  (O (count (isurp4-cnt-1 $ctx $norm $k) $k $c1) 
      (- (isurp4-cnt-1 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-2)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) (isurp4-cnt-2 $ctx $norm 0))
  (O (count (isurp4-cnt-2 $ctx $norm $k) $k $c2) (- (isurp4-cnt-2 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-3)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c3) (isurp4-cnt-3 $ctx $norm 0))
  (O (count (isurp4-cnt-3 $ctx $norm $k) $k $c3) (- (isurp4-cnt-3 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-4)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c4) (isurp4-cnt-4 $ctx $norm 0))
  (O (count (isurp4-cnt-4 $ctx $norm $k) $k $c4) (- (isurp4-cnt-4 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-12)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) (isurp4-cnt-12 $ctx $norm 0))
  (O (count (isurp4-cnt-12 $ctx $norm $k) $k ($c1 $c2)) (- (isurp4-cnt-12 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-13)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c3) (isurp4-cnt-13 $ctx $norm 0))
  (O (count (isurp4-cnt-13 $ctx $norm $k) $k ($c1 $c3)) (- (isurp4-cnt-13 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-14)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c4) (isurp4-cnt-14 $ctx $norm 0))
  (O (count (isurp4-cnt-14 $ctx $norm $k) $k ($c1 $c4)) (- (isurp4-cnt-14 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-23)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) ($db $c3) (isurp4-cnt-23 $ctx $norm 0))
  (O (count (isurp4-cnt-23 $ctx $norm $k) $k ($c2 $c3)) (- (isurp4-cnt-23 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-24)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) ($db $c4) (isurp4-cnt-24 $ctx $norm 0))
  (O (count (isurp4-cnt-24 $ctx $norm $k) $k ($c2 $c4)) (- (isurp4-cnt-24 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-34)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c3) ($db $c4) (isurp4-cnt-34 $ctx $norm 0))
  (O (count (isurp4-cnt-34 $ctx $norm $k) $k ($c3 $c4)) (- (isurp4-cnt-34 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-123)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) ($db $c3) (isurp4-cnt-123 $ctx $norm 0))
  (O (count (isurp4-cnt-123 $ctx $norm $k) $k ($c1 $c2 $c3)) (- (isurp4-cnt-123 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-124)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c2) ($db $c4) (isurp4-cnt-124 $ctx $norm 0))
  (O (count (isurp4-cnt-124 $ctx $norm $k) $k ($c1 $c2 $c4)) (- (isurp4-cnt-124 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-134)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c1) ($db $c3) ($db $c4) (isurp4-cnt-134 $ctx $norm 0))
  (O (count (isurp4-cnt-134 $ctx $norm $k) $k ($c1 $c3 $c4)) (- (isurp4-cnt-134 $ctx $norm 0))))

(exec (freq 082 isurp4-cnt-234)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     ($db $c2) ($db $c3) ($db $c4) (isurp4-cnt-234 $ctx $norm 0))
  (O (count (isurp4-cnt-234 $ctx $norm $k) $k ($c2 $c3 $c4)) (- (isurp4-cnt-234 $ctx $norm 0))))

(exec (freq 083 isurp4-calc)
  (, (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm)
     (isurp4-cnt-total $ctx $norm $n)
     (isurp4-cnt-j $ctx $norm $j)
     (isurp4-cnt-1 $ctx $norm $k1)
     (isurp4-cnt-2 $ctx $norm $k2)
     (isurp4-cnt-3 $ctx $norm $k3)
     (isurp4-cnt-4 $ctx $norm $k4)
     (isurp4-cnt-12 $ctx $norm $k12)
     (isurp4-cnt-13 $ctx $norm $k13)
     (isurp4-cnt-14 $ctx $norm $k14)
     (isurp4-cnt-23 $ctx $norm $k23)
     (isurp4-cnt-24 $ctx $norm $k24)
     (isurp4-cnt-34 $ctx $norm $k34)
     (isurp4-cnt-123 $ctx $norm $k123)
     (isurp4-cnt-124 $ctx $norm $k124)
     (isurp4-cnt-134 $ctx $norm $k134)
     (isurp4-cnt-234 $ctx $norm $k234))
  (O
    (pure (isurp4-pj $ctx $norm $ppat) $ppat
      (f64_to_string
        (div_f64
          (f64_from_string $j)
          (f64_from_string
            (i64_to_string
              (div_i64
                (falling_factorial (i64_from_string $n) (i64_from_string 4))
                (factorial (i64_from_string 4))))))))
    ;; 4 partitions of type 3+1
    (pure (isurp4-p1 $ctx $norm $p1) $p1
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k123) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p2 $ctx $norm $p2) $p2
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k124) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p3 $ctx $norm $p3) $p3
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k134) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p4 $ctx $norm $p4) $p4
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k234) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    ;; 3 partitions of type 2+2
    (pure (isurp4-p5 $ctx $norm $p5) $p5
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k12) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k34) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p6 $ctx $norm $p6) $p6
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k13) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k24) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p7 $ctx $norm $p7) $p7
      (f64_to_string (product_f64 (div_f64 (f64_from_string $k14) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k23) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    ;; 6 partitions of type 2+1+1
    (pure (isurp4-p8 $ctx $norm $p8) $p8
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k12) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p9 $ctx $norm $p9) $p9
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k13) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p10 $ctx $norm $p10) $p10
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k14) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p11 $ctx $norm $p11) $p11
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k23) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p12 $ctx $norm $p12) $p12
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k24) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (pure (isurp4-p13 $ctx $norm $p13) $p13
      (f64_to_string (product_f64 (product_f64 (div_f64 (f64_from_string $k34) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    ;; 1 partition of type 1+1+1+1
    (pure (isurp4-p14 $ctx $norm $p14) $p14
      (f64_to_string (product_f64 (product_f64 (product_f64 (div_f64 (f64_from_string $k1) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))) (div_f64 (f64_from_string $k2) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k3) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4))))))) (div_f64 (f64_from_string $k4) (f64_from_string (i64_to_string (div_i64 (falling_factorial (i64_from_string $n) (i64_from_string 4)) (factorial (i64_from_string 4)))))))))
    (- (isurp4-eval $ctx ($c1 $c2 $c3 $c4) $db $norm))
    (- (isurp4-cnt-total $ctx $norm $n))
    (- (isurp4-cnt-j $ctx $norm $j))
    (- (isurp4-cnt-1 $ctx $norm $k1))
    (- (isurp4-cnt-2 $ctx $norm $k2))
    (- (isurp4-cnt-3 $ctx $norm $k3))
    (- (isurp4-cnt-4 $ctx $norm $k4))
    (- (isurp4-cnt-12 $ctx $norm $k12))
    (- (isurp4-cnt-13 $ctx $norm $k13))
    (- (isurp4-cnt-14 $ctx $norm $k14))
    (- (isurp4-cnt-23 $ctx $norm $k23))
    (- (isurp4-cnt-24 $ctx $norm $k24))
    (- (isurp4-cnt-34 $ctx $norm $k34))
    (- (isurp4-cnt-123 $ctx $norm $k123))
    (- (isurp4-cnt-124 $ctx $norm $k124))
    (- (isurp4-cnt-134 $ctx $norm $k134))
    (- (isurp4-cnt-234 $ctx $norm $k234))))

(exec (freq 084 isurp4-minmax)
  (, (isurp4-pj $ctx $norm $ppat)
     (isurp4-p1 $ctx $norm $p1)
     (isurp4-p2 $ctx $norm $p2)
     (isurp4-p3 $ctx $norm $p3)
     (isurp4-p4 $ctx $norm $p4)
     (isurp4-p5 $ctx $norm $p5)
     (isurp4-p6 $ctx $norm $p6)
     (isurp4-p7 $ctx $norm $p7)
     (isurp4-p8 $ctx $norm $p8)
     (isurp4-p9 $ctx $norm $p9)
     (isurp4-p10 $ctx $norm $p10)
     (isurp4-p11 $ctx $norm $p11)
     (isurp4-p12 $ctx $norm $p12)
     (isurp4-p13 $ctx $norm $p13)
     (isurp4-p14 $ctx $norm $p14))
  (O
    (pure (isurp4-emin $ctx $norm $emin) $emin
      (min-atom (' ($p1 $p2 $p3 $p4 $p5 $p6 $p7 $p8 $p9 $p10 $p11 $p12 $p13 $p14))))
    (pure (isurp4-emax $ctx $norm $emax) $emax
      (max-atom (' ($p1 $p2 $p3 $p4 $p5 $p6 $p7 $p8 $p9 $p10 $p11 $p12 $p13 $p14))))
    (- (isurp4-p1 $ctx $norm $p1))
    (- (isurp4-p2 $ctx $norm $p2))
    (- (isurp4-p3 $ctx $norm $p3))
    (- (isurp4-p4 $ctx $norm $p4))
    (- (isurp4-p5 $ctx $norm $p5))
    (- (isurp4-p6 $ctx $norm $p6))
    (- (isurp4-p7 $ctx $norm $p7))
    (- (isurp4-p8 $ctx $norm $p8))
    (- (isurp4-p9 $ctx $norm $p9))
    (- (isurp4-p10 $ctx $norm $p10))
    (- (isurp4-p11 $ctx $norm $p11))
    (- (isurp4-p12 $ctx $norm $p12))
    (- (isurp4-p13 $ctx $norm $p13))
    (- (isurp4-p14 $ctx $norm $p14))))

(exec (freq 085 isurp4-emit-raw)
  (, (isurp4-pj $ctx False $ppat)
     (isurp4-emin $ctx False $emin)
     (isurp4-emax $ctx False $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (abs_f64
            (sub_f64
              (f64_from_string $ppat)
              (clamp_f64
                (f64_from_string $ppat)
                (f64_from_string $emin)
                (f64_from_string $emax))))
          (f64_from_string 1.0))))
    (- (isurp4-pj $ctx False $ppat))
    (- (isurp4-emin $ctx False $emin))
    (- (isurp4-emax $ctx False $emax))))

(exec (freq 085 isurp4-emit-norm)
  (, (isurp4-pj $ctx True $ppat)
     (isurp4-emin $ctx True $emin)
     (isurp4-emax $ctx True $emax))
  (O
    (pure ($res) $res
      (f64_to_string
        (min_f64
          (div_f64
            (abs_f64
              (sub_f64
                (f64_from_string $ppat)
                (clamp_f64
                  (f64_from_string $ppat)
                  (f64_from_string $emin)
                  (f64_from_string $emax))))
            (max_f64 (f64_from_string $emax) (f64_from_string $ppat)))
          (f64_from_string 1.0))))
    (- (isurp4-pj $ctx True $ppat))
    (- (isurp4-emin $ctx True $emin))
    (- (isurp4-emax $ctx True $emax))))
