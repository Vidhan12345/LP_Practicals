%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

int regCount = 1;

char* newReg() {
    char *buf = malloc(10);
    sprintf(buf, "R%d", regCount++);
    return buf;
}
%}

%union {
    char *str;
}

%token <str> ID NUM
%type <str> expr

%%

input:
    stmt
    ;

stmt:
    expr '\n' {
        printf("; Final result in: %s\n", $1);
        free($1);
        return 0;
    }
    ;

expr:
    expr '+' expr {
        char *res = newReg();
        printf("MOV %s, %s\n", res, $1);
        printf("ADD %s, %s\n", res, $3);
        free($1); free($3);
        $$ = res;
    }
    | expr '-' expr {
        char *res = newReg();
        printf("MOV %s, %s\n", res, $1);
        printf("SUB %s, %s\n", res, $3);
        free($1); free($3);
        $$ = res;
    }
    | expr '*' expr {
        char *res = newReg();
        printf("MOV %s, %s\n", res, $1);
        printf("MUL %s, %s\n", res, $3);
        free($1); free($3);
        $$ = res;
    }
    | expr '/' expr {
        char *res = newReg();
        printf("MOV %s, %s\n", res, $1);
        printf("DIV %s, %s\n", res, $3);
        free($1); free($3);
        $$ = res;
    }
    | '(' expr ')' {
        $$ = $2;
    }
    | ID {
        $$ = strdup($1);
    }
    | NUM {
        $$ = strdup($1);
    }
    ;

%%

int main() {
    printf("Enter an expression:\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}
