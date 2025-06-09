%{
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*

%%

"+"|"-"|"*"|"/"|"%"|"="|"+="|"-="|"*="|"/="|"%="|"=="|"!="|"<"|">"|"&&"|"||"|"!" {
    printf("Operator: %s\n", yytext);
    return OPERATOR;
}

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {
    printf("Keyword: %s\n", yytext);
    return KEYWORD;
}

{IDENTIFIER} {
    printf("Identifier: %s\n", yytext);
    return IDENTIFIER;
}

[ \t\n] ;  /* Ignore whitespace */

. {
    printf("Unknown token: %s\n", yytext);
}

%%

int yywrap() {
    return 1;
}