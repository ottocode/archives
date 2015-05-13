/** Test Bench
 *  ========================================================================
 *
 *  Manages the running of all of the tests
 *      Test currently include: scanner
 *
 *
 *  Last Modified: 2/14/14
 *  Contributor(s): Nicholas Otto
 */
#include <stdio.h>
#include <stdlib.h>
#include "testbench.h"
#include "machine.h"


/** Main Function
 *  -------------
 *  Run the tests, initially separated by module (eg scanner, preprocessor, etc)
 *
 *  argc: number of command line arguments
 *  argv: the command line arguments, starting with executable name
 *
 *  returns: 0 if all successful, error code otherwise
 */
int main(int argc, char **argv)
{
    int error_code;

    printf("Beginning Test-Bench for NOCC\n");

    /*
    if( (error_code = scannermain(testscanfile)) ){
        printf("Testing Stopped during scanner tests\nCode: %d\n", error_code);
        exit(error_code);
    }
    */

    if (argc > 1){
        if( (error_code = scannermain(argv[1])) ){
            printf("Testing Stopped during scanner tests\nCode: %d\n", error_code);
            exit(error_code);
        }
        else{
            if( (error_code = parsermain(argv[1])) ){
                printf("Testing Stopped during parser tests\nCode: %d\n", error_code);
                exit(error_code);
            }
        }
    }
    else{

        if( (error_code = scannermain(parse1file)) ){
            printf("Testing Stopped during scanner tests\nCode: %d\n", error_code);
            exit(error_code);
        }
        else{
            if( (error_code = parsermain(parse1file)) ){
                printf("Testing Stopped during parser tests\nCode: %d\n", error_code);
                exit(error_code);
            }
        }
    }


    return 0;
}
