#lang racket
(require rackunit)

(provide anagrams anagram-list)

; Definování funkce anagrams, která očekává jako vstup seznam s jednotlivými slovy.
(define (anagrams single-word-list)

  ; Ze vstupního řetězce odstraní pomlčky
  (define (remove-hyphen string)
    (list->string
     (filter (lambda (char) (not (char=? char #\-))) ;
             (string->list string))))

  ; Ze vstupního řetězce vytvoří klíč, kdy jsou charaktery klíče seřazeny abecedně
  (define (create-key string)
    (list->string
     (sort (filter (lambda (char) (not (char=? char #\-)))
                   (string->list string))
           char<?)))

  ; Funkce sloučí slova se stejným klíčem do jednoho seznamu
  (define (squash sequence)
    ; Vnořená funkce iter s parametry buffered-line, previous-key a sqnce.
    ; Tato funkce rekurzivně prochází seznamem sqnce a seskupuje slova podle jejich klíče.
    (define (iter buffered-line previous-key sqnce)
      ; Testuje, zda je seznam sqnce prázdný, jestliže ano, ukončuje rekurzi.
      (if (null? sqnce)
          (list buffered-line)
          ; Používá se let* k extrakci current-key a current-word z prvního prvku seznamu sqnce a definuje rest jako zbytek seznamu.
          (let* ([current-key (caar sqnce)]
                 [current-word (cadar sqnce)]
                 [rest (cdr sqnce)])
            ; Porovnává previous-key s current-key. Jestliže se rovnají, znamená to, že aktuální slovo patří ke stejné skupině jako buffered-line.
            (if (string=? previous-key current-key)
                (iter (cons current-word buffered-line) previous-key rest)
                ; Pokud se klíče rovnají, přidá current-word do buffered-line a rekurzivně volá iter se stejným klíčem a zbytkem seznamu.
                (cons buffered-line
                      (iter (list current-word) current-key rest))))))
    (cdr (iter '() "" sequence)))
  
  (let* ([key-added-list (map (lambda (line) (list (create-key line) line))
                              single-word-list)] ; Pro každé slovo v seznamu single-word-list se vytvoří klíč pomocí funkce create-key.
         [sorted-list (sort key-added-list string<? #:key car)] ; Seřadí key-added-list podle klíčů (první prvek v každém podseznamu, získaný pomocí car).

         ; Funkce squash (popisovaná dříve) je použita na sorted-list k seskupení slov podle klíčů.
         ; Filter odstraní všechny skupiny, které obsahují jen jedno slovo.
         [anagram-list (filter (lambda (entry) (> (length entry) 1))
                               (squash sorted-list))]

         ; Filtr je aplikován na anagram-list k odstranění těch skupin, kde jsou všechna slova identická po odstranění pomlček pomocí funkce remove-hyphen.
         ; Cílem je ponechat jen skupiny, kde slova se liší i po odstranění pomlček.
         [alist-without-hyphens (filter (lambda (entry)
                                          (not (string=? (remove-hyphen (car entry))
                                                         (remove-hyphen (cadr entry)))))
                                        anagram-list)]
         ; Pro každou skupinu v alist-without-hyphens, jsou slova seřazena podle abecedy pomocí funkce sort.
         ; To umožňuje jednodušší porovnávání skupin.
         [alist-sorted-entries (map (lambda (entry) (sort entry string<?))
                                    alist-without-hyphens)])
    alist-sorted-entries))


; Funkce anagram-list, která volá funkcí anagrams se vstupem ze souboru, kdy každý nový řádek je nové slovo.
(define anagram-list (anagrams (file->lines "slova.txt")))

; Cílem funkce je vyfiltrovat a seřadit ty skupiny, které obsahují více slov než je stanovený dolní limit lower-bound. 
(define (anagram-tuples-longer-than anagram-list lower-bound)
  (sort
   (filter
    (lambda (entry) (> (length entry) lower-bound))
    anagram-list)
   >
   #:key length))

; Cílem funkce je vyfiltrovat a seřadit ty skupiny, jejichž délka slova je delší než dolní limit lower-bound. 
(define (anagrams-longer-than anagram-list lower-bound)
  (sort
   (filter
    (lambda (entry) (> (string-length (car entry)) lower-bound))
    anagram-list)
   >
   #:key (lambda (entry) (string-length (car entry)))))
