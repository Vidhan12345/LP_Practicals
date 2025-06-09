%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>  // For strdup()

extern void yyerror(char *);  // Declare yyerror

// Explicitly declare yylex to avoid implicit declaration warning
int yylex(void);
%}

%%

[0-9]+      { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z]+   { yylval.str = strdup(yytext); return ID; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
";"         { return SEMI; }
\n          { return '\n'; }
[ \t]       ; /* skip whitespace */
.           { yyerror("Invalid character"); }

%%

int yywrap(void) {
    return 1;
}