#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX 10

// Global variables
char production[MAX][10];
char first[MAX][MAX], follow[MAX][MAX];
int numProductions;
char nonTerminals[MAX];
int firstCount[MAX], followCount[MAX];
int ntCount = 0;

// Function to check if a character is a non-terminal
int isNonTerminal(char c) {
    return isupper(c);
}

// Function to add a character to a set if it's not already present
void addToSet(char set[], int *count, char c) {
    for (int i = 0; i < *count; i++) {
        if (set[i] == c) return;
    }
    set[(*count)++] = c;
}

// Function to get the index of a non-terminal in the nonTerminals array
int getIndex(char c) {
    for (int i = 0; i < ntCount; i++) {
        if (nonTerminals[i] == c) return i;
    }
    return -1;
}

// Function to compute FIRST set for a non-terminal
void computeFirst(char c) {
    int index = getIndex(c);
    for (int i = 0; i < numProductions; i++) {
        if (production[i][0] == c) {
            int j = 2; // Skip the non-terminal and ->
            while (production[i][j] != '\0') {
                char symbol = production[i][j];
                
                if (!isNonTerminal(symbol)) {
                    // If terminal, add to FIRST set
                    addToSet(first[index], &firstCount[index], symbol);
                    break;
                } else {
                    // If non-terminal, compute its FIRST if not already done
                    int nextIndex = getIndex(symbol);
                    if (firstCount[nextIndex] == 0)
                        computeFirst(symbol);
                    
                    // Add all non-epsilon symbols from the FIRST set
                    int epsilonFound = 0;
                    for (int k = 0; k < firstCount[nextIndex]; k++) {
                        if (first[nextIndex][k] == '#') {
                            epsilonFound = 1;
                        } else {
                            addToSet(first[index], &firstCount[index], first[nextIndex][k]);
                        }
                    }
                    
                    // If epsilon not found, stop processing this production
                    if (!epsilonFound) break;
                    
                    j++;
                    // If we reached end of production, add epsilon
                    if (production[i][j] == '\0') {
                        addToSet(first[index], &firstCount[index], '#');
                    }
                }
            }
        }
    }
}

// Function to compute FOLLOW set for a non-terminal
void computeFollow(char c) {
    int index = getIndex(c);
    
    // Rule 1: $ is in FOLLOW(S) where S is the start symbol
    if (production[0][0] == c)
        addToSet(follow[index], &followCount[index], '$');
    
    for (int i = 0; i < numProductions; i++) {
        char *rhs = production[i];
        for (int j = 2; rhs[j] != '\0'; j++) {
            if (rhs[j] == c) {
                // Case 1: A → αBβ
                if (rhs[j + 1] != '\0') {
                    char next = rhs[j + 1];
                    
                    // Subcase 1: β is a terminal
                    if (!isNonTerminal(next)) {
                        addToSet(follow[index], &followCount[index], next);
                    } 
                    // Subcase 2: β is a non-terminal
                    else {
                        int nextIndex = getIndex(next);
                        
                        // Add FIRST(β) except ε to FOLLOW(B)
                        for (int k = 0; k < firstCount[nextIndex]; k++) {
                            if (first[nextIndex][k] != '#') {
                                addToSet(follow[index], &followCount[index], first[nextIndex][k]);
                            }
                        }
                        
                        // If FIRST(β) contains ε, add FOLLOW(A) to FOLLOW(B)
                        if (strchr(first[nextIndex], '#') != NULL) {
                            int lhsIndex = getIndex(production[i][0]);
                            if (followCount[lhsIndex] == 0)
                                computeFollow(production[i][0]);
                            for (int k = 0; k < followCount[lhsIndex]; k++) {
                                addToSet(follow[index], &followCount[index], follow[lhsIndex][k]);
                            }
                        }
                    }
                } 
                // Case 2: A → αB (or A → αBβ where β →* ε)
                else {
                    int lhsIndex = getIndex(production[i][0]);
                    if (lhsIndex != index) {
                        if (followCount[lhsIndex] == 0)
                            computeFollow(production[i][0]);
                        for (int k = 0; k < followCount[lhsIndex]; k++) {
                            addToSet(follow[index], &followCount[index], follow[lhsIndex][k]);
                        }
                    }
                }
            }
        }
    }
}

// Function to print the FIRST and FOLLOW sets in a table format
void printTable() {
    printf("\n===========================================================\n");
    printf("| %-15s | %-23s | %-25s |\n", "Nonterminal", "First", "Follow");
    printf("-----------------------------------------------------------\n");

    for (int i = 0; i < ntCount; i++) {
        char firstSet[30] = "";
        char followSet[30] = "";

        // Format FIRST set
        for (int j = 0; j < firstCount[i]; j++) {
            strncat(firstSet, &first[i][j], 1);
            if (j < firstCount[i] - 1) {
                strcat(firstSet, ", ");
            }
        }

        // Format FOLLOW set
        for (int j = 0; j < followCount[i]; j++) {
            strncat(followSet, &follow[i][j], 1);
            if (j < followCount[i] - 1) {
                strcat(followSet, ", ");
            }
        }

        // Print row with formatted columns
        printf("| %-15c | %-23s | %-25s |\n", nonTerminals[i], firstSet, followSet);
    }

    printf("===========================================================\n");
}

int main() {
    printf("Enter the number of productions: ");
    scanf("%d", &numProductions);
    getchar(); // Consume the newline character

    // Input productions
    for (int i = 0; i < numProductions; i++) {
        printf("Production %d: ", i + 1);
        fgets(production[i], sizeof(production[i]), stdin);
        production[i][strcspn(production[i], "\n")] = '\0'; // Remove newline

        // Add non-terminal to list if not already present
        char nt = production[i][0];
        if (getIndex(nt) == -1) {
            nonTerminals[ntCount++] = nt;
        }
    }

    // Compute FIRST sets for all non-terminals
    for (int i = 0; i < ntCount; i++) {
        computeFirst(nonTerminals[i]);
    }

    // Compute FOLLOW sets for all non-terminals
    for (int i = 0; i < ntCount; i++) {
        computeFollow(nonTerminals[i]);
    }

    // Print the results
    printTable();
    
    return 0;
}