%{
#include <stdio.h>

int identifier_count = 0;  // To count identifiers (integers)
int operator_count = 0;    // To count operators (+ and *)
%}

%%
[0-9]+             { identifier_count++; }  // Match integers (Identifiers)
[+*]               { operator_count++; }    // Match operators + and *
[ \t\n]            { /* Ignore spaces, tabs, and newlines */ }
.                   { /* Ignore other characters */ }
%%

int main() {
    char input[100];  // To hold the input expression
    printf("Enter arithmetic expression:\n");

    // Use fgets to read the input
    fgets(input, sizeof(input), stdin); 

    // Set the input to yylex for lexical analysis
    YY_BUFFER_STATE buffer = yy_scan_string(input);
    yylex();  // Perform lexical analysis (start scanning input)

    printf("Identifiers count: %d\n", identifier_count);
    printf("Operators count: %d\n", operator_count);

    return 0;
}

int yywrap() {
    return 1;  // Return 1 to indicate the end of input
}
 
