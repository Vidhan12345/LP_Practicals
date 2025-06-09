%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempCount = 0;

char* newTemp() {
    char* temp = (char*)malloc(8);
    sprintf(temp, "t%d", tempCount++);
    return temp;
}

void yyerror(char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%union {
    char* str;
}

%token <str> ID NUM
%token ASSIGN PLUS MINUS MUL DIV SEMI
%type <str> expr term factor

%start stmts

%%

stmts: 
    stmts stmt
    | stmt
    ;

stmt: 
    ID ASSIGN expr SEMI {
        printf("%s = %s\n", $1, $3);
        free($1); free($3);
    }
    | ID ASSIGN expr '\n' {
        printf("%s = %s\n", $1, $3);
        free($1); free($3);
    }
    ;

expr: 
    expr PLUS term {
        char* temp = newTemp();
        printf("%s = %s + %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | expr MINUS term {
        char* temp = newTemp();
        printf("%s = %s - %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | term {
        $$ = $1;
    }
    ;

term: 
    term MUL factor {
        char* temp = newTemp();
        printf("%s = %s * %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | term DIV factor {
        char* temp = newTemp();
        printf("%s = %s / %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | factor {
        $$ = $1;
    }
    ;

factor: 
    ID {
        $$ = strdup($1);
    }
    | NUM {
        $$ = strdup($1);
    }
    ;

%%

extern int yylex();

int main() {
    yyparse();
    return 0;
}