/** Parser Header File
 *  ========================================================================
 *
 *  Defines functions used by the Parser
 *
 *
 *  Last Modified: 4/12/14
 *  Contributor(s): Nicholas Otto
 */
#ifndef PARSER_H
#define PARSER_H 

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../utility/structures.h"
#include "scanner.h"
#include "../utility/utility.h"

extern struct input_item *input_head;    //the front of the input stream
/** Make a new tree node
 *  --------------------
 *  Allocates memory for a new tree node and adds it to existing tree
 *
 *  node_type: enum type describing the type of node being created
 *
 *  returns: void
 */
void tree_mknode(int node_type);

/** Add an attribute to a tree node
 *  -------------------------------
 *  Adds an attribute to an existing tree node
 *
 *  t: pointer to the struct identifier which is source of attribute to add
 *  pos: position in the (x,=,a,op,b) field to add attribute (index start at 0)
 *
 */
void tree_add_attr(struct identifier *t, int pos);

/** Push onto parse stack
 *  ---------------------
 *  Pushes a grammar symbol onto the stack and updates tree info
 *
 *  symbol: the value to be pushed onto the stack
 *
 */
void stack_push(int symbol);

/** Peek into parse stack
 *  ---------------------
 *  Looks up what the top stack symbol is.
 *
 *  top: a pointer to the top of the stack
 *
 *  returns: the top stack item
 */
struct stack_item * stack_peek();

/** Pop off parse stack
 *  ---------------------
 *  Pops the top stack symbol.
 *
 *  returns: the top stack symbol
 */
int stack_pop();

/** Consume token
 *  -------------------------------
 *  Get and consume the next token
 *
 *  parameter1: description of parameter
 *
 *  returns: a pointer to a token of input
 */
struct token * input_consume();

/** Peek at input
 *  -------------------------------
 *  Look up next input token without consuming it.
 *
 *  parameter1: description of parameter
 *
 *  returns: The token pointer at the top of the queue.  Caller is responsible for 
 *      freeing
 */
struct token * input_peek();

/** Match input to token list
 *  -------------------------------
 *  Match the input to a list of tokens.
 *
 *  parameter1: description of parameter
 *
 *  returns: what it returns
 */
void input_match();
 
/** Check if token is an identifier
 *  -------------------------------
 *
 *  parameter1: description of parameter
 *
 *  returns: what it returns
 */
void token_isIdentifier();

/** Parse the input stream
 *
 *  returns: A pointer to the head of the parse tree
 */
struct tree_node * build_parse_tree();

int compound_statement(struct token *token);

/** Log an error during parsing
 *  ---------------------------
 *  If during the process of building the parse tree there is an incorrect input,
 *      print an error message.
 *
 *  error: the top of the stack
 *
 */
void log_error(Symbol error);




/** Print out the parse tree
 *  ------------------------
 *  Purely for debugging purposes.
 *
 */
int print_parse_tree(struct tree_node *head, int parent, int order);

/** Free the tree
 *  ------------------------
 *
 */
int free_parse_tree(struct tree_node *head);

int compound_statement(struct token *token);
int declaration_list(struct token *token);
int declaration(struct token *token);
int declaration_specifiers(struct token *token);
int type_qualifier(struct token *token);
int type_specifier(struct token *token);
int pointer_qualifier(struct token *token);
int typedef_name(struct token *token);
int define_array(struct token *token);
int statement_list(struct token *token);
int statement(struct token *token);
int labeled_statement(struct token *token);
int jump_statement(struct token *token);
int expression_statement(struct token *token);
int expression(struct token *token);
int assignment_expression(struct token *token);
int lvalue(struct token *token);
int assignment_operator(struct token *token);
int rvalue(struct token *token);
int lrvalue(struct token *token);
int binary_op(struct token *token);
int reference_operator(struct token *token);
int postfix_expression(struct token *token);
int lpostfix_expression(struct token *token);
int primary_expression_list(struct token *token);
int primary_expression(struct token *token);
int primary_expression_mods(struct token *token);
int logical_or_expression(struct token *token);
int logical_and_expression(struct token *token);
int inclusive_or_expression(struct token *token);
int exclusive_or_expression(struct token *token);
int and_expression(struct token *token);
int equality_expression(struct token *token);
int relational_expression(struct token *token);
int shift_expression(struct token *token);
int additive_expression(struct token *token);
int multiplicative_expression(struct token *token);
int cast_expression(struct token *token);
int direct_expression(struct token *token);
int token_openparen(struct token *token);
int token_closeparen(struct token *token);
int token_openscope(struct token *token);
int token_closescope(struct token *token);
int token_endstatement(struct token *token);
int error_symbol(struct token *token);


#endif
