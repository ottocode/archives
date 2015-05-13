/** Scanner Test File
 *  ========================================================================
 *
 *  Here is the test suite for the scanner functions
 *
 *
 *  Last Modified: 2/14/14
 *  Contributor(s): Nicholas Otto
 */
#include <stdio.h>
#include <stdlib.h>
#include "../src/frontend/scanner.h"
#include "../src/utility/utility.h"


/** Begin scanner testing
 *  ---------------------
 *  Runs the execution of the scanner tests
 *
 *
 *  returns: 0 on success, error code otherwise
 */
int scannermain(const char *file)
{
    int error_code, ret;
    struct token *temptoken;

    printf("\nBeginning Tests for Scanner\n");


    ret = 0;

    if( (error_code = open_file(file, "r+b")) == 0 ){
        printf("Test FAILED\n");
        printf("\topen_file\t\tScanner Tests\n\terror: %d\n", error_code);
        ret = error_code;
    }

    //This isn't really an error...//TODO fix (or just remove the remaining_characters() function)
    if( (error_code = remaining_characters())==0 ){
        printf("Test FAILED\n");
        printf("\tremaining_characters\t\tScanner Tests\n\terror: %d\n", error_code);
        ret = error_code;
    }

    temptoken = get_next_token();
    for(;;temptoken = get_next_token()){
        if( temptoken == NULL || temptoken == (void *)1 ){
            printf("Test FAILED\n");
            printf("\tget_next_token\t\tScanner Tests\n");
            ret = error_code;
            break;
        }
        else if (temptoken == (void *)2){
            printf("End of scan test file\n");
            break;
        }
        else{
            printf("token type: %s\n", getEnumName(temptoken->type));
            printf("\tlexeme: '%s', lexeme length: %d\n", 
                temptoken->lexeme, temptoken->lexeme_length);
        }
        free(temptoken->lexeme);
        free(temptoken);
    }


    if( (error_code = close_file()) ){
        printf("Test FAILED\n");
        printf("\tclose_file\t\tScanner Tests\n\terror: %d\n", error_code);
        ret = error_code;
    }
    

    return ret; 
}
