/** Syntax Directed Translation Header File
 *  ========================================================================
 *
 *  The syntax directed translation of the declarations and staments of the 
 *		parse tree convert the parse tree into an intermediate representation
 *		more easily converted into assembly code or further iterations
 *		of IR code.
 *
 *
 *  Last Modified: 4/29/14
 *  Contributor(s): Nicholas Otto
 */
#ifndef SYNDIRTRANSLATION_H
#define SYNDIRTRANSLATION_H


#include <stdio.h>
#include <stdlib.h>
#include "../utility/structures.h"
#include "../utility/utility.h"

/** Synthesize Attributes
 *	---------------------
 *
 *	Start at the head of parse tree and synthesize attributes up to the statement
 *		and declaration nodes
 *
 *	head: The head of the parse tree, should be a compound_statement node with
 *		declaration and statement children
 *	
 *	returns: non-zero on success	
 */
int synthesize_attributes(struct tree_node *head);

/** Synthesize Delcaration
 *  ----------------------
 *  Synthesize the attributes for the declaration node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_declaration(struct tree_node *snode);

/** Synthesize Declaration Specifiers
 *  ---------------------------------
 *  Synthesize the attributes for the declaration specifiers node 
 *		by pulling the relevant information from child nodes.
 *
 */
int synthesize_declaration_specifiers(struct tree_node *snode);


/** Synthesize Typedef Name
 *  -----------------------
 *  Synthesize the attributes for the typdef name node by pulling the 
 *		relevant information from child nodes.
 */
int synthesize_typedef_name(struct tree_node *snode);




/** Synthesize Statement
 *  --------------------
 *  Synthesize the attributes for the statement node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_statement(struct tree_node *snode);


/** Synthesize Expression Statement
 *  -------------------------------
 *  Synthesize the attributes for the expression statement node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_expression_statement(struct tree_node *esnode);


/** Synthesize Expression 
 *  ---------------------
 *  Synthesize the attributes for the expression node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_expression(struct tree_node *enode);


/** Synthesize Assignment Expression
 *  --------------------------------
 *  Synthesize the attributes for the assignment expression node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_assignment_expression(struct tree_node *aenode);


/** Synthesize LValue
 *  -----------------
 *  Synthesize the attributes for the LValue node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_lvalue(struct tree_node *lvnode);


/** Synthesize LPostfix Expression
 *  ------------------------------
 *  Synthesize the attributes for the LPostfix Expression node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_lpostfix_expression(struct tree_node *lpnode);


/** Synthesize Primary Expression Mods
 *  ----------------------------------
 *  Synthesize the attributes for the Primary Expression Mods node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_primary_expression_mods(struct tree_node *pemnode);


/** Synthesize Assignment Operator
 *  ------------------------------
 *  Synthesize the attributes for the Assignment Operator node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_assignment_operator(struct tree_node *aonode);



/** Synthesize RValue
 *  -----------------
 *  Synthesize the attributes for the RValue node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_rvalue(struct tree_node *rvnode);

/** Synthesize Cast Expression
 *  --------------------------
 *  Synthesize the attributes for the cast expression node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_cast_expression(struct tree_node *cenode);

/** Synthesize LRValue
 *  -----------------
 *  Synthesize the attributes for the LRValue node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_lrvalue(struct tree_node *lrvnode);

/** Synthesize Reference Operator
 *  -----------------------------
 *  Synthesize the attributes for the reference operator node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_reference_operator(struct tree_node *renode);


/** Synthesize Postfix Expression
 *  -----------------------------
 *  Synthesize the attributes for the postfix expression node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_postfix_expression(struct tree_node *penode);


/** Synthesize Binary Op
 *  --------------------
 *  Synthesize the attributes for the Binary Operator node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_binary_op(struct tree_node *bonode);

/** Synthesize Jump Statement
 *  -------------------------
 *  Synthesize the attributes for the jump statement node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_jump_statement(struct tree_node *jsnode);

/** Synthesize Labeled Statement
 *  ----------------------------
 *  Synthesize the attributes for the labeled statement node by pulling the 
 *		relevant information from child nodes.
 *
 *  [parameter1]: [description of parameter]
 *
 *  returns: [what it returns]
 */
int synthesize_labeled_statement(struct tree_node *lsnode);




#endif
