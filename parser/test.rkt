#lang racket
(require rackunit)
(require "parser.rkt")

; Pro testování je použit RackUnit
; Pokud po spuštění nedojde k chybě, testy proběhly úspěšně

(check-equal? 
 (parse-program "x = 3 + 4; y = x * (2 + 3);")
 '((Assign "x" ("+" (Number "3") (Number "4")))
   (Assign "y" ("*" (Identifier "x") ("+" (Number "2") (Number "3"))))))

(check-equal? 
 (parse-program "x = 3 + 4;")
 '((Assign "x" ("+" (Number "3") (Number "4")))))

(check-equal? 
 (parse-program "x = 3;")
 '((Assign "x" (Number "3"))))

; Parsování výrazů bez středníku je zakázáno, a mělo by skončit odchycenou chybou
(check-exn exn:fail? (thunk (parse-program "x = 3")))

; Parsování neúplných výrazů je zakázáno, a mělo by skončit odchycenou chybou
(check-exn exn:fail? (thunk (parse-program "x =")))