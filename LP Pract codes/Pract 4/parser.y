%{
#include <stdio.h>
#include <stdlib.h>
int n; // Will store the number of 'a's we expect
int count = 0; // Counts the 'a's we actually see
void yyerror(const char *s);
int yylex();
%}
%token A B
%%
input: /* empty */
 | input string '\n' { count = 0; } // Reset counter after each line
 ;
string: pattern { printf("Valid string: a^%db\n", n); }
 | error { printf(""); yyerrok; }
 ;
pattern: a_part B { if (count != n) yyerror("Incorrect number of 'a's"); }
 ;
a_part: /* empty */
 | a_part A { count++; }
 ;
%%
void yyerror(const char *s) {
}
int main() {
 printf("Enter the value of n: ");
 scanf("%d", &n);
 printf("Now enter strings to validate (each ending with newline):\n");
 printf("(Press Ctrl+D to exit)\n");
 return yyparse();
}
/* Simple lexer */
int yylex() {
 int c = getchar();

 if (c == 'a') return A;
 if (c == 'b') return B;
 if (c == '\n') return '\n';
 if (c == EOF) return 0;

 return c; // Return other characters as-is (will cause parse error)
}