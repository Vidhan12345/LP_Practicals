%{
#include <stdio.h>
%}

lower [a-z]
upper [A-Z]

%%

{lower}   { printf("%c", yytext[0] - 32); }  // Convert lowercase to uppercase
{upper}   { printf("%c", yytext[0] + 32); }  // Convert uppercase to lowercase
[\t\n]+   { printf("\n"); }  // Handle tabs and newlines
.         { printf("%c", yytext[0]); }  // Print other characters as is

%%

int yywrap() {
    return 1;  // Indicate end of file (EOF)
}

int main() {
    yylex();  // Start lexical analysis
    return 0;
}
