#lang racket

(provide parse-program)

(define (parse-program input)
  ; Funkce pro tokenizaci vstupu
  (define (tokenize str)
    (map string-trim
         (filter (lambda (s) (not (string=? s "")))
                 (regexp-match* #px"([A-Za-z]+|\\d+|[-+*/=();])" str))))
  
  (define tokens (tokenize input))
  
  ; Výstupní seznam
  (define output '())

  ; Zásobník pro udržení stavu
  (define stack '(Program))

  ; Funkce pro porovnání aktuálního tokenu a očekávaného tokenu
  (define (expect token)
    (if (and (not (null? tokens)) (equal? (car tokens) token))
        (begin
          (set! tokens (cdr tokens))
          token)
        (error "Unexpected token" tokens)))
  
  ; Funkce pro zpracování různých pravidel
  (define (parse-expression)
    (let loop ((term (parse-term)))
      (cond [(and (not (null? tokens)) (member (car tokens) '("+" "-")))
             (let ((op (expect (car tokens))))
               (loop (list op term (parse-term))))]
            [else term])))

  (define (parse-term)
    (let loop ((factor (parse-factor)))
      (cond [(and (not (null? tokens)) (member (car tokens) '("*" "/")))
             (let ((op (expect (car tokens))))
               (loop (list op factor (parse-factor))))]
            [else factor])))

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
    (expect ";")
    (list 'Assign id expr))
  
  (define (parse-statement-list)
    (if (and (not (null? tokens)) (not (equal? (car tokens) "$")))
        (cons (parse-statement) (parse-statement-list))
        '()))

  (parse-statement-list)
  )

