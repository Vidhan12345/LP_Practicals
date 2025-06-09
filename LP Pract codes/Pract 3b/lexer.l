%{
#include "y.tab.h"
%}

%%
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
[ \t\n]     { /* ignore whitespace */ }
.           { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
