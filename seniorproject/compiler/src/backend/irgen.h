/** Header file for IR Generator
 *  ========================================================================
 *
 *  Defines functions used to generate the intermediate representation based
 *		off the parse tree
 *
 *	When describing the parse tree, the description for a 3 level parse tree
 *		graphically represented as:
 *			0
 *		   / \
 *		  1   2
 *       /   / \
 *      3   4   5
 *		is given in depth first order as:
 *		0 (x,=,a,op,b) -> 1(x,=,a,op,b) --> 3(x,=,a,op,b) -> 2(x,=,a,op,b)
 *			-->4(x,=,a,op,b) -->5(x,=,a,op,b)
 *		where the number of '-' characters represents the depth of the node
 *			and with the parent the previously seen next higher level.
 *
 *	(x,=,a,op,b) are the "fields" of each node.  Not every node will require
 *		5 attribute fields, nor will they always correspond to the general
 *		binary operator and assignment case.
 *
 *  Last Modified: 4/22/14
 *  Contributor(s): Nicholas Otto
 */
#include <stdio.h>
#include <stdlib.h>
#include "backendstructures.h"
#include "../utility/structures.h"


/** Declaration Generation
 *  ----------------------
 *  Run through the declarations in the parse tree and track space for each
 *		declaration
 *
 *	The IR generator produces 3 fields for declarations: "pointer", "array",
 *		and "data".  They are indicated as "pointerD", "arrayD", and "dataD".
 *	"pointerD" is simply a counter of pointers.  Since a pointer is merely a
 *		location in memory, only the size of the array really maters.
 *	"arrayD" is an array with each index containing the length of the
 *		array stored at the index.  The index itself specifies the specific
 *		array.  "arrayD_size" is the total length of the "arrayD" section.
 *		conveniently, "arrayD_size" = a1+a2+a3+ ...
 *	"dataD" is also an array of data declarations that are not pointers or
 *		arrays.  Each index represents another declaration, and the contents
 *		at that index is the size, in bytes, of that declaration.
 *
 *
 *  tree_head: A pointer to the head of the parse tree generated by the parser
 *  ir: A pointer to the intermediate representation structure being created.
 *
 *  returns: [what it returns]
 */
int declaration_generation(struct tree_node *tree_head, 
						struct intermediate_representation *ir);


/** Statement Generation
 *  --------------------
 *  Run through the statements in the parse tree and generate four address
 *		code for each.
 *
 *	There are _ types of statements:
 *		jump statements, labeled statements, and expression statements.
 *
 *	labeled statements appear in the source code as:
 *			"begin label:"
 *		where "label" is an identifier.  The statement following the labeled
 *		statement is the one the programmer intends to have executed next.
 *		Labeled statements have a tree structure of:
 *			Statement -> Labeled Statement (label,,,,)
 *			where "label" is the symbol after the "begin" keyword
 *
 *	jump statements appear in the source code as:
 *			"goto label conditional"
 *		where "label" is the symbol defining the labeled statement to move
 *		the execution order to if called for.  "conditional" is the 
 *		condition to check to determine if the jump should be performed.
 *		Jump statements have the tree structure:
 *			Statement -> Jump Statement (label, conditional,,,)
 *
 *	expression statements appear in the source code as:
 *		"x = a"
 *		"x = a op b"
 *		"x = (cast) a"
 *		where 'op' is the token representing the binary operation to perform
 *
 *		Expression Statements all start with the tree:
 *			Statement -> Expression_Statement --> Expression
 *				---> Assignment Expression (x,=,a,[op],[b])
 *					---->LValue (x,,,,)
 *					---->Assignment Operator (,=,,,)
 *					---->RValue (,,a,[op],[b])
 *
 *			Assuming the sub-trees lvalue, assignment operator, and rvalue
 *				are properly formed, this is as far as needed to go to 
 *				build the expression.
 *
 *
 *  tree_head: A pointer to the head of the parse tree generated by the parser
 *  ir: A pointer to the intermediate representation structure being created.
 *
 *  returns: [what it returns]
 */
int statement_generation(struct tree_node *tree_head, 
						struct intermediate_representation *ir);

/** Print IR 
 *  --------------
 *  The intermediate representation never needs to be in human readable form,
 *		but for debugging purposes, it can be printed out for inspection with
 *		this function
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int print_ir(int argc, char **argv)
{

    return 0;
}

/** [Function Title] 
 *  --------------
 *  [Description of function]
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
/*int main(int argc, char **argv)
{

    return 0;
}
*/
