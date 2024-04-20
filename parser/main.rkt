#lang racket
(require "parser.rkt")
;; Syntaktický analyzátor pro jednoduchý programovací jazyk

;; Martin Choutka
;; xchom027@studenti.czu.cz

;; Cílem analyzátoru je rozpoznat, zda vstupní program odpovídá pravidlům dané gramatiky a přeložit tento vstup do strukturovaného formátu seznamů, které reprezentují syntaxi programu.
;; Tento přístup je základem pro další zpracování, jako je interpretace nebo kompilace kódu.

;; Program (S) -> StatementList
;; StatementList -> Statement StatementList | ε
;; Statement -> Identifier '=' Expression ';'
;; Expression -> Term Expression'
;; Expression' -> '+' Term Expression' | '-' Term Expression' | ε
;; Term -> Factor Term'
;; Term' -> '*' Factor Term' | '/' Factor Term' | ε
;; Factor -> Identifier | Number | '(' Expression ')'
;; Identifier -> 'x' | 'y' | 'z'  
;; Number -> [0-9]+       

;; Neterminál/Token	'x'	'y'	'z'	[0-9]	'+'	'-'	'*'	'/'	'='	'('	')'	';'	'$'
;; Program	1	1	1	1						1			
;; StatementList	2	2	2	2						2	3		3
;; Statement	4	4	4										
;; Expression	5	5	5	5						5			
;; Expression'					6	7					8	8	8
;; Term	9	9	9	9						9			
;; Term'					11	11	10	10			11	11	11
;; Factor	12	12	12	13						14			
;; Identifier	15	16	17										
;; Number				18									

;; Legenda pravidel:
;; 1.  Program -> StatementList
;; 2.  StatementList -> Statement StatementList
;; 3.  StatementList -> ε
;; 4.  Statement -> Identifier '=' Expression ';'
;; 5.  Expression -> Term Expression'
;; 6.  Expression' -> '+' Term Expression'
;; 7.  Expression' -> '-' Term Expression'
;; 8.  Expression' -> ε
;; 9.  Term -> Factor Term'
;; 10. Term' -> '*' Factor Term'
;; 11. Term' -> '/' Factor Term'
;; 12. Factor -> Identifier
;; 13. Factor -> Number
;; 14. Factor -> '(' Expression ')'
;; 15. Identifier -> 'x'
;; 16. Identifier -> 'y'
;; 17. Identifier -> 'z'
;; 18. Number -> [0-9]+

; Testování parseru
(parse-program "x = 3 + 4; y = x * (2 + 3);")

