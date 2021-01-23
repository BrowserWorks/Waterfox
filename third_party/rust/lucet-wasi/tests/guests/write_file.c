#include <assert.h>
#include <stdio.h>
#include <string.h>

static char *message = "hello, file!";

int main()
{
    FILE *file = fopen("/sandbox/output.txt", "w");
    assert(file != NULL);

    int nwritten = fprintf(file, "%s", message);
    assert(nwritten == strlen(message));

    assert(fclose(file) == 0);
}
