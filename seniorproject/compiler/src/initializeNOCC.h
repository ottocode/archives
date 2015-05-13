/** File Title
 *  ========================================================================
 *
 *  Overall description of file
 *
 *
 *  Last Modified: 4/14/14
 *  Contributor(s): Nicholas Otto
 */

#ifndef INITIALIZENOCC_H
#define INITIALIZENOCC_H

#include <stdlib.h>
#include <stdio.h>
#include "utility/structures.h"
#include "utility/utility.h"

//extern struct hashentry *kwtable[PRIME];
//extern struct hashentry *symboltable[PRIME];

/** Build KW table
 *  --------------
 *  Pre-insert the keywords into the kwtable
 *
 */
void initialize_kwtable();


/** Initialize Symbol Table
 *  -----------------------
 *  Define the symbol table structure.
 *
 */
void initialize_kwtable();

/** Free KW table
 *  -------------
 *
 */
void free_kwtable();

//for debugging purposes
//DEBUG
void test_kwtable();

#endif

