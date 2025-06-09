%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex(void);
extern char *yytext;
void yyerror(const char *s);
%}

%union {
    char *str;
}

%token <str> IDENTIFIER KEYWORD OPERATOR

%%

program: 
    program statement
    | statement
;

statement:
    IDENTIFIER { printf("Parsed Identifier: %s\n", $1); free($1); }
    | KEYWORD { printf("Parsed Keyword: %s\n", $1); free($1); }
    | OPERATOR { printf("Parsed Operator: %s\n", $1); free($1); }
;

%%

void yyerror(const char *s) { 
    fprintf(stderr, "Error: %s\n", s); 
}

int main() { 
    printf("Parsing started...\n"); 
    yyparse();
    printf("Parsing completed.\n"); 
    return 0; 
}