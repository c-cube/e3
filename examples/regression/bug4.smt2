; expect: SAT

; generated by nunchaku
(declare-datatypes
   ()
   ((pos_num (B_one) 
             (Bit1 (Bit1_0 pos_num)) 
             (Bit0 (Bit0_0 pos_num)))))
(declare-datatypes
   ()
   ((b_int (B_0) 
           (B_pos (B_pos_0 pos_num)) 
           (B_neg (B_neg_0 pos_num)))))
(declare-fun nun_sk_0 () b_int)
(define-fun-rec
   pos_plus ((v_0 pos_num) (v_1 pos_num)) pos_num
     (match v_0
       (case (Bit0 x)
          (match v_1
            (case (Bit0 y) (Bit0 (pos_plus x y))) 
            (case (Bit1 y_0) (Bit1 (pos_plus x y_0))) 
            (case B_one (Bit1 x)))) 
       (case (Bit1 x_0)
          (match v_1
            (case (Bit0 y_1) (Bit1 (pos_plus x_0 y_1))) 
            (case (Bit1 y_2) (Bit0 (pos_plus B_one (pos_plus x_0 y_2)))) 
            (case B_one (Bit0 (pos_plus B_one x_0))))) 
       (case B_one
          (match v_1
            (case (Bit0 x_1) (Bit1 x_1)) 
            (case (Bit1 x_2) (Bit0 (pos_plus B_one x_2))) 
            (case B_one (Bit0 B_one))))))
(define-fun-rec
   pos_mult ((x_3 pos_num) (x_4 pos_num)) pos_num
     (match x_3
       (case (Bit0 x_5)
          (match x_4
            (case (Bit0 y_3) (Bit0 (Bit0 (pos_mult x_5 y_3)))) 
            (case (Bit1 y_4) (Bit0 (pos_mult x_5 (Bit1 y_4)))) 
            (case B_one x_3))) 
       (case (Bit1 x_6)
          (match x_4
            (case (Bit0 y_5) (Bit0 (pos_mult (Bit1 x_6) y_5))) 
            (case (Bit1 y_6)
               (Bit1 (pos_plus x_6 (pos_plus y_6 (Bit0 (pos_mult x_6 y_6)))))) 
            (case B_one x_3))) 
       (case B_one
          (match x_4
            (case (Bit0 v_0_0) x_4) 
            (case (Bit1 v_0_1) x_4) 
            (case B_one x_4)))))
(define-fun-rec
   b_mult ((x_7 b_int) (x_8 b_int)) b_int
     (match x_7
       (case (B_neg x_9)
          (match x_8
            (case (B_neg y_7) (B_pos (pos_mult x_9 y_7))) 
            (case (B_pos y_8) (B_neg (pos_mult x_9 y_8))) 
            (case B_0 B_0))) 
       (case (B_pos x_10)
          (match x_8
            (case (B_neg y_9) (B_neg (pos_mult x_10 y_9))) 
            (case (B_pos y_10) (B_pos (pos_mult x_10 y_10))) 
            (case B_0 B_0))) 
       (case B_0
          (match x_8
            (case (B_neg v_0_2) B_0) 
            (case (B_pos v_0_3) B_0) 
            (case B_0 B_0)))))
(define-fun-rec b_5 () b_int (B_pos (Bit1 (Bit0 B_one))))
(define-fun-rec
   b_positive ((v_0_4 b_int)) Bool
     (match v_0_4
       (case (B_neg x_11) false) 
       (case (B_pos x_12) true) 
       (case B_0 true)))
(assert-not
 (or
  (not (= (b_mult nun_sk_0 nun_sk_0) (b_mult b_5 b_5))) 
  (not (b_positive nun_sk_0))))

