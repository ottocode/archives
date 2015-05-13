/** IR Generator Test File
 *  ========================================================================
 *
 *  Contains some simple tests for the ir generator
 *
 *
 *  Last Modified: 4/22/14
 *  Contributor(s): Nicholas Otto
 */
#include <stdio.h>
#include <stdlib.h>
#include "../src/frontend/parser.h"
#include "../src/utility/utility.h"
#include "../src/utility/structures.h"
#include "../src/frontend/scanner.h"
#include "../src/initializeNOCC.h"



/** Begin irgen testing
 *  -------------------
 *  [Description]
 *
 *  [parameter1]: <description of parameter>
 *
 *  [returns]: [what it returns]
 */
int irgenmain(const char *file)
{
    printf("\nBegin irgen tests\n");

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

	

    free_kwtable();
    free_parse_tree(head);
    printf("End irgen tests\n\n\n");

    return 0;
}
