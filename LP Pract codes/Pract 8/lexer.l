%{
#include "y.tab.h"
%}

%%

a       { return A; }
b       { return B; }
\n      { return EOL; }
.       { return INVALID; }

%%

int yywrap(void) {
    return 1;
}