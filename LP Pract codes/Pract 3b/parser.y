%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern int yylex();  // Lexical analyzer function
int yyparse();  // Parser function

void yyerror(const char *s);  // Error handling function

%}

%union {
    int num;  // Store the value of the numbers
}

%token <num> NUM
%token PLUS MINUS MUL DIV

%left PLUS MINUS
%left MUL DIV

%type <num> program expression

%%

program:
    expression { printf("Result: %d\n", $1); }
;

expression:
    NUM                           { $$ = $1; }
    | expression PLUS expression  { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression MUL expression   { $$ = $1 * $3; }
    | expression DIV expression   { 
                                    if ($3 == 0) {
                                        printf("Error: Division by zero\n");
                                        exit(1);
                                    }
                                    $$ = $1 / $3;
                                  }
    | '(' expression ')'          { $$ = $2; }  // Handle parentheses
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);  // Print the error message
}

int main() {
    printf("Enter an arithmetic expression: ");
    yyparse();  
    return 0;
}
