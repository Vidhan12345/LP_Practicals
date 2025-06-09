%{
#include <stdio.h>
FILE *outputFile;
%}

%%
[a-zA-Z0-9_{}();,"'\t]+    { fputs(yytext, outputFile); }
\/\*[^*]*\*+([^/*][^*]*\*+)*\/    { /* Ignore multi-line comments */ }
\/\/[^\n]*    { /* Ignore single-line comments */ }
\n            { fputc('\n', outputFile); }
%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc != 3) {
        printf("Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        perror("Error opening input file");
        return 1;
    }

    outputFile = fopen(argv[2], "w");
    if (!outputFile) {
        perror("Error opening output file");
        fclose(inputFile);
        return 1;
    }

    yyin = inputFile;
    yylex();

    fclose(inputFile);
    fclose(outputFile);

    printf("Output written to %s\n", argv[2]);
    return 0;
}