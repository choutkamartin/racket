#lang racket
(require rackunit)
(require "anagram.rkt")

; Pro testování je použit RackUnit
; Pokud po spuštění nedojde k chybě, testy proběhly úspěšně

; Pokud bude vstupem pouze jedno slovo, neměl by program vrátit žádné anagramy
(check-equal? (anagrams (list "test")) '())

; Pokud bude vstup obsahovat dvě slova, která nejsou přesmyčkou, neměl by program vrátit žádné anagramy
(check-equal? (anagrams (list "test fotbal")) '())

; Pokud bude vstup obsahovat dvě slova, která jsou přesmyčkou, ale jedno ze slov je oddělené čárkou, měl by program ze slov čárku odstranit a považovat slova za anagram
(check-equal? (anagrams (list "hello-world" "worldhello")) '(("hello-world" "worldhello")))

; Pokud bude vstup obsahovat dvě slova, která jsou přesmyčkou, měl by program vrátit právě tyto slova
(check-equal? (anagrams (list "test" "sett")) '(("sett" "test")))

; Pokud bude vstup obsahovat čtyři slova, která jsou přesmyčkou, měl by program vrátit dvě dvojice slov, která jsou přesmyčkou
(check-equal? (anagrams (list "test" "sett" "kolo" "okol")) '(("sett" "test") ("kolo" "okol")))
