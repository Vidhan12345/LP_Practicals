%{
#include "pract8.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern YYSTYPE yylval;
%}

%%
[0-9]+ {
    yylval.num = atoi(yytext);
    return NUMBER;
}

[a-zA-Z][a-zA-Z0-9]* {
    strcpy(yylval.str, yytext);
    return ID;
}

"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MUL; }
"/"     { return DIV; }
"="     { return ASSIGN; }
";"     { return ';'; }
"("     { return '('; }
")"     { return ')'; }
[ \t\n] ;  // Ignore whitespace
.       { return yytext[0]; }

%%
int yywrap() { return 1; }
