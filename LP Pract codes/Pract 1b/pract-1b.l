%{
#include <stdio.h>
int lines = 0, spaces = 0, words = 0, characters = 0;
int in_word = 0;
%}

%%
\n            { lines++; characters++; in_word = 0; }  // Increment lines and characters on newline
" "           { spaces++; characters++; in_word = 0; }  // Increment spaces and characters
[^\n\s]       { characters++; if (!in_word) { words++; in_word = 1; } } // Count words and characters

%%
int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    FILE *file = fopen(argv[1], "r");  // Open the file passed as argument
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }
    yyin = file;  // Set the input file for FLEX
    yylex();      // Start lexical analysis
    printf("The number of lines: %d\n", lines);
    printf("The number of spaces: %d\n", spaces);
    printf("The number of words: %d\n", words);
    printf("The number of characters: %d\n", characters);
    fclose(file);  // Close the file after processing
    return 0;
}

int yywrap() {
    return 1;  // Indicate end of input
}
