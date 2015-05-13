/** NOC - a senior project C compiler
 *  ========================================================================
 *
 *  NOC is a C compiler created as a senior project in Spring 2014.
 *
 *
 *  Last Modified: 2/15/14
 *  Contributor(s): Nicholas Otto
 */
#include <stdio.h>
#include "noc.h"
#include "../src/frontend/parser.h"
#include "../src/utility/utility.h"
#include "../src/utility/structures.h"
#include "../src/frontend/scanner.h"
#include "../src/initializeNOCC.h"


/** Main function
 *  -------------
 *  Begin the compiler, calling appropriate starting points
 *
 *  argc: number of command line arguments
 *  argv: command line arguments
 *
 *  returns: 0 on normal exit, > 0 otherwise
 */
int main(int argc, char **argv)
{
    displayinfo();
    if(argc < 2){
		printf("Nothing to compile.\n");
        return 1;
    }

    if(*argv[1] == '-'){
        if(argc < 2){  //need at least 2 or else no file to compile
            return 1;
        }
        if(DEBUG){
            printf("Processing arguments %s\n", argv[1]);
        }
        if(argv[1][1] == 'p'){
            printf("Running pre-processor only\n");
        }
        else{
            printf("Unknown argument '%s'\n", argv[1]);
        }
    }
    else{
        if(DEBUG){
            printf("Compiling %s\n", argv[1]);

		    struct tree_node *head;
    		open_file(argv[1], "r+b");

			initialize_kwtable();
			head = build_parse_tree();
			close_file(argv[1]);

    		//int total_nodes = print_parse_tree(head, -1, 0); //DEBUG
			free_kwtable();
			free_parse_tree(head);
        }
    }

    return 0;
}


/** Display Info About NOCC
 *  -----------------------
 *  Shows a short message about the compiler including the version,
 *      author, and any other relevant information
 *
 */
void displayinfo()
{
    printf("NOCC version 0.0.1\n");
    printf("Author: Nicholas Otto, University of San Diego\n");
    if(DEBUG){
        printf("Debug statements: ON\n");
    }
    printf("\n");
}
