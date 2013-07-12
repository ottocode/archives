/** Main test suite.
 * Compile with gcc -flags test_suite.c test_random.c test_queue.c random.c queue.c -lm
 */

#include "test_suite.h"
#include <stdio.h>

int main(){

    printf("\nTesting random.c\n");
    test_random();

    printf("\nTesting queue.c\n");
    test_queue();

      return 0;
}
