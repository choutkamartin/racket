#lang racket

(provide parse-program)

(define (parse-program input)
  ; Funkce pro tokenizaci vstupu uživatele
  (define (tokenize str)
    (map string-trim
         (filter (lambda (s) (not (string=? s "")))
                 (regexp-match* #px"([A-Za-z]+|\\d+|[-+*/=();])" str))))
  
  (define tokens (tokenize input))
  
  ; Výstupní zásobník
  (define output '())

  ; Funkce pro porovnání aktuálního tokenu s očekávaným tokenem
  (define (expect token)
    (if (and (not (null? tokens)) (equal? (car tokens) token))
        (begin
          (set! tokens (cdr tokens))
          token)
        (error "Unexpected token" tokens)))
  
  ; Funkce pro zpracování pravidel
  (define (parse-expression)
    (define (recur-exp term)
      (if (and (not (null? tokens)) (member (car tokens) '("+" "-")))
          (let ((op (expect (car tokens))))
            (recur-exp (list op term (parse-term))))
          term))
    (recur-exp (parse-term)))

  (define (parse-term)
    (define (recur-term factor)
      (if (and (not (null? tokens)) (member (car tokens) '("*" "/")))
          (let ((op (expect (car tokens))))
            (recur-term (list op factor (parse-factor))))
          factor))
    (recur-term (parse-factor)))

  (define (parse-factor)
    (cond [(char-numeric? (string-ref (car tokens) 0))
           (list 'Number (expect (car tokens)))]
          [(member (car tokens) '("x" "y" "z"))
           (list 'Identifier (expect (car tokens)))]
          [(equal? (car tokens) "(")
           (begin
             (expect "(")
             (define expr (parse-expression))
             (expect ")")
             expr)]
          [else (error "Expected number, identifier, or expression" tokens)]))

  (define (parse-statement)
    (define id (expect (car tokens)))
    (expect "=")
    (define expr (parse-expression))
    (if (and (not (null? tokens)) (equal? (car tokens) ";"))
        (expect ";")
        (error "Expected ;"))
    (list 'Assign id expr))

  (define (parse-statement-list)
    (if (and (not (null? tokens)) (not (equal? (car tokens) "$")))
        (cons (parse-statement) (parse-statement-list))
        '()))

  (parse-statement-list)
  )
