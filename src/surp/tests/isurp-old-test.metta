;; Importing(Loading) path
;; TEST-AUX data/isurp-mock-coupled.metta
;; TEST-AUX data/ugly-sodaDrinker.metta
;; TEST-AUX src/surp/isurp-old.metta

;;; they are working together when import true-nested facts need common-utils helper function
;;" ;; TEST-AUX data/isurp-true-nested.metta"
;;" ;; TEST-AUX src/common-utils/utils.metta"


        ;; MORK aux paths load facts into the space(AtomeSpace) Name; 
(exec (freq 001 import-coupled-facts-to-dbc)
  (, (Inheritance (Person $person) $trait))
  (O
    (+ (&dbc (Inheritance (Person $person) $trait)))))

(exec (freq 002 import-ugly_man_sodaDrinker-to-db)
  (, (Inheritance $person $catagory))
  (O
    (+ (&db (Inheritance $person $catagory)))))

(exec (freq 001 import-true-nested-data-to-db)
  (, (Inheritance $antecedent $consequent))
  (O
    (+ (&dbn (Inheritance $antecedent $consequent)))))



;; Run test case with Three conjection partition pattern from &dbc database(atomespace)
(isurp-old
  (, (Inheritance (Person $x) man)
     (Inheritance (Person $x) ugly)
     (Inheritance (Person $x) sodaDrinker))
  &dbc
  True)

;;; (Expected result isurp-old-coupled-normalized (0.999707773232028))


(isurp-old (, (Inheritance $x man) 
                (Inheritance $x ugly)
                (Inheritance $x sodaDrinker))   
                &db False) 

;;; Expected result: 0.00014607068574401354


; (isurp-old (, (Inheritance (And (And (Person $x) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))
;                            (Inheritance (And (And (Person $x)   man) (Or human sodaDrinker)) (Or (And human man) (And human ugly)))
;                            (Inheritance (And (And human man)   (Or (Person $x) (Person Mike)))   (Or (And human man)   (And human sodaDrinker)))
;                             (Inheritance (And (And (Person $x) man) (Or human ugly))        (Or (And human man) (And human sodaDrinker)))) &dbn True)
                             
;;; Expeected Result is: 0.9996837944664032



;;;;  Clean up result
(exec (freq 110 clean_up_raw_facts_from_last_result)
    (,(Inheritance $human $catagory))
    (O (- (Inheritance $human $catagory))))

(exec (freq 111 clean_up_facts-with-space-last_result)
    (,($db (Inheritance $human $catagory)))
    (O (- ($db (Inheritance $human $catagory)))))

; (exec (freq 112 clean_up_true_nested_data_from_last_result)
;     (, ($db (Inheritance (And $and_pattern $or_pattern) (Or $and_pattern $and_pattern))))
;     (O (- ($db (Inheritance (And $and_pattern $or_pattern) (Or $and_pattern $and_pattern))))))
    
(exec (freq 113 clean-acc-defs)
  (, (DEF $name $p $t))
  (O (- (DEF $name $p $t))))
