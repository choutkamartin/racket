#lang racket
(require "anagram.rkt")

; Vyhledávač přesmyček (anagramů) ze vstupního listu slov

; Martin Choutka
; xchom027@studenti.czu.cz

; Cílem vyhledávače je ze vstupního listu slov vyhledat přesmyčky.
; Vstupem může být definovaný list slov přímo v kódu či externí soubor slova.txt.
; V takovém souboru musí být každé slovo na novém řádku.

; Inicializace funkce níže vypíše dvojici slov, která jsou anagramy.
anagram-list
