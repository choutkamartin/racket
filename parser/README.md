## Syntaktický analyzátor pro jednoduchý programovací jazyk

Cílem analyzátoru je rozpoznat, zda vstupní program odpovídá pravidlům dané gramatiky a přeložit tento vstup do strukturovaného formátu seznamů, které reprezentují syntaxi programu.

Tento přístup je základem pro další zpracování, jako je interpretace nebo kompilace kódu.

```
Program (S) -> StatementList
StatementList -> Statement StatementList | ε
Statement -> Identifier '=' Expression ';'
Expression -> Term Expression'
Expression' -> '+' Term Expression' | '-' Term Expression' | ε
Term -> Factor Term'
Term' -> '*' Factor Term' | '/' Factor Term' | ε
Factor -> Identifier | Number | '(' Expression ')'
Identifier -> 'x' | 'y' | 'z'  
Number -> [0-9]+
```       							

