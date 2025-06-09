%{
#include "y.tab.h"
#include <ctype.h>
#include <string.h>
%}

%%
[ \t]       ; // Ignore whitespace
\n           { return '\n'; } // Send newline to YACC
[0-9]+        { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
"+"           { return '+'; }
"-"           { return '-'; }
"*"           { return '*'; }
"/"           { return '/'; }
"("           { return '('; }
")"           { return ')'; }
.             { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
