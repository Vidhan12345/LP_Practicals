%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char* s);

int temp_count = 0;

void generate_code(char* result, char* arg1, char* op, char* arg2);

%}

%union {
    int num;
    char str[100];
}

%token <num> NUMBER
%token <str> ID
%token PLUS MINUS MUL DIV ASSIGN

%type <str> expr term factor statement

%%

program:
    statement_list
;

statement_list:
      statement
    | statement_list statement
;

statement:
    ID ASSIGN expr ';' {
        generate_code($1, $3, "=", NULL);
    }
;

expr:
    expr PLUS term {
        sprintf($$, "t%d", temp_count++);
        generate_code($$, $1, "+", $3);
    }
  | expr MINUS term {
        sprintf($$, "t%d", temp_count++);
        generate_code($$, $1, "-", $3);
    }
  | term {
        strcpy($$, $1);
    }
;

term:
    term MUL factor {
        sprintf($$, "t%d", temp_count++);
        generate_code($$, $1, "*", $3);
    }
  | term DIV factor {
        sprintf($$, "t%d", temp_count++);
        generate_code($$, $1, "/", $3);
    }
  | factor {
        strcpy($$, $1);
    }
;

factor:
    NUMBER {
        sprintf($$, "%d", $1);
    }
  | ID {
        strcpy($$, $1);
    }
  | '(' expr ')' {
        strcpy($$, $2);
    }
;

%%

void generate_code(char* result, char* arg1, char* op, char* arg2) {
    if (arg2 == NULL)
        printf("%s = %s\n", result, arg1);
    else
        printf("%s = %s %s %s\n", result, arg1, op, arg2);
}

int main() {
    printf("Enter expressions (end with Ctrl+D / EOF):\n");
    yyparse();
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
