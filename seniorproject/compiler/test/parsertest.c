/** Parser Test File
 *  ========================================================================
 *
 *  Test suite for the parser functions
 *
 *
 *  Last Modified: 4/14/14
 *  Contributor(s): Nicholas Otto
 */
#include <stdio.h>
#include <stdlib.h>
#include "../src/frontend/parser.h"
#include "../src/utility/utility.h"
#include "../src/utility/structures.h"
#include "../src/frontend/scanner.h"
#include "../src/backend/syndirtranslation.h"
#include "../src/initializeNOCC.h"

/** Begin parser testing
 *  --------------------
 *  Parses the input into a token stream.
 *  Ideally the scanner test already passes on the input.
 *
 *  Returns 0 on success.
 */
int parsermain(const char *file)
{
    printf("\nBegin parsing tests\n");

    open_file(file, "r+b");

    struct tree_node *head;

    //create the kw and symbol tables

    initialize_kwtable();
    head = build_parse_tree();
    close_file(file);


    if( head == NULL ){
        printf("Test FAILED\n");
        printf("Error building parse tree!\n");
    }
    printf("\n\nAbstract syntax tree:\n");
    int total_nodes = print_parse_tree(head, -1, 0);

    printf("Total number of tree nodes: %d\n", total_nodes);

    //synthesize_attributes(head);

    free_kwtable();
    //free_parse_tree(head); //TODO figure out where the double free is coming from
    printf("End parsing tests\n\n\n");

    //test_kwtable();
    return 0;
}

