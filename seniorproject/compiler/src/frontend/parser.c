/** Parse the token stream into parse tree
 *  ========================================================================
 *
 *  The parser needs to call for successive tokens and create a parse tree of
 *      the source tokens.
 *      Will be implemented as a top-down, recursive decent parser (predictive
 *      if I'm feeling ambitions).
 *
 *
 *  Last Modified: 4/12/14
 *  Contributor(s): Nicholas Otto
 */
#include "parser.h"

/* Array defining all of the stack operations in parser_stackops.c */
/* The order MUST, MUST <<<<<<< MUST match utility/structures.h for 
 *      enum SYMBOLS
 */
int (*stack_operation[ERROR_SYMBOL])(struct token *token) = 
{
    compound_statement, declaration_list, declaration,
    declaration_specifiers, type_qualifier, type_specifier,
    pointer_qualifier, typedef_name,
    define_array,
    statement_list, statement,
    labeled_statement, jump_statement, expression_statement,
    expression, assignment_expression,
    lvalue, assignment_operator, rvalue, lrvalue, binary_op,
    reference_operator, postfix_expression, lpostfix_expression,
    primary_expression_list, primary_expression, primary_expression_mods,
    logical_or_expression, logical_and_expression,
    inclusive_or_expression, exclusive_or_expression, and_expression,
    equality_expression, relational_expression, shift_expression,
    additive_expression, multiplicative_expression,
    cast_expression, direct_expression, 
    token_openscope, token_closescope,
    token_endstatement,
    token_openparen, token_closeparen,
    token_openscope, token_closescope,
    error_symbol
};


struct tree_node *tree_head;        //the head of the parse tree
struct tree_node *tree_curr;        //the current node of the parse tree
struct stack_item *stack_top;       //the top of the stack
struct input_item *input_head;    //the front of the input stream
struct input_item *input_tail;    //the front of the input stream


void tree_mknode(int node_type)
{
    //create a new node
    struct tree_node *newnode = malloc(sizeof(struct tree_node));
    printf("\nmaking node: %s at: %p\n\n", getStackSymbolName(node_type), newnode);//DEBUG
    newnode->first_child = NULL;
    newnode->last_child = NULL;
    newnode->right_sibling = NULL;
    newnode->node_type = node_type;


    //if tree curr is null, this is the new head
    if (tree_curr == NULL){
        newnode->parent = NULL;
        tree_head = newnode;
    }
    else if (tree_curr->first_child == NULL){
        //if parent has no children, add as first child
        newnode->parent = tree_curr;
        tree_curr->first_child = newnode;
        tree_curr->last_child = newnode;
        printf("making subtree:\n\t%s with parent> %s\n", 
            getStackSymbolName(newnode->node_type),
            getStackSymbolName(newnode->parent->node_type));//DEBUG

        printf("Newnode: %p, parent->child: %p\n", newnode, tree_curr->first_child);
    }
    else{
        //otherwise, if parent has a last child add as right sibling of last child
        newnode->parent = tree_curr;
        tree_curr->last_child->right_sibling = newnode;
        tree_curr->last_child = newnode;
        printf("making subtree:\n\t%s with parent> %s as sibling\n", 
            getStackSymbolName(newnode->node_type),
            getStackSymbolName(newnode->parent->node_type));//DEBUG
    }

    tree_curr = newnode;
}

void tree_add_attr(struct identifier *t, int pos)
{


    printf("Adding attribute \"%s\" to %s node in position %d\n", t->lexeme, 
        getStackSymbolName(tree_curr->node_type), pos);//DEBUG

    switch(pos){
        case 0:
            tree_curr->attributes.x = t;
            break;
        case 1:
            tree_curr->attributes.eq = t;
            break;
        case 2:
            tree_curr->attributes.a = t;
            break;
        case 3:
            tree_curr->attributes.op = t;
            break;
        case 4:
            tree_curr->attributes.b = t;
            break;
        default:
            break;
    }
    return;

}

void stack_push(int symbol)
{
    printf("pushing: %s\n", getStackSymbolName(symbol));//DEBUG
    struct stack_item *newStack = malloc(sizeof(struct stack_item));

    newStack->symbol = symbol;
    newStack->tree_pos = tree_curr;
    newStack->next_stack_item = stack_top;

    //if stack_top = NULL, then need to allocate memory
    stack_top = newStack;

}

struct stack_item * stack_peek()
{
    if(stack_top != NULL){
        return stack_top;
    }
    else{
        return NULL;
    }
}

int stack_pop()
{
    if(stack_top != NULL){
        Symbol retval = stack_top->symbol;
        struct stack_item *old_top = stack_top;
        stack_top = stack_top->next_stack_item;
        printf("popping %s\n", getStackSymbolName(old_top->symbol));//DEBUG
        free(old_top);
        return retval;
    }
    else{
        return -1;
    }
}

struct token * input_consume()
{
    printf("consuming input: ");//DEBUG
    //printf("old head is %p\n", input_head);//DEBUG
    /* Call get_next_token() */

    /* Update queue tail */
    struct input_item *newtail = malloc(sizeof(struct input_item));
    newtail->Token = NULL;
    newtail->next_input = NULL;
    input_tail->next_input = newtail;
    input_tail = newtail;
    input_tail->Token = get_next_token();

    /* update queue head and free old input_item 
     *  NOTE: this does not free the token value! */
    struct token *retval = input_head->Token;
    struct input_item *oldhead = input_head;

    input_head = input_head->next_input;
    //free(oldhead->Token->lexeme);//if these are freed, the return value is useless
    //free(oldhead->Token);
    free(oldhead);
    
    printf("%s\n", retval->lexeme);//DEBUG
    //printf("new head is %p\n", input_head);//DEBUG
    return retval;
}

struct token * input_peek()
{

    return input_head->Token;
}

void input_match()
{

}
 
void token_isIdentifier()
{

}

void initialize_parser_objects()
{
    //initialize tree_head to null.
    tree_head = NULL;
    tree_curr = tree_head;

    //initialize top of stack, push first grammar symbol
    stack_top = NULL;
    stack_push(COMPOUND_STATEMENT);
    
    //initialize input
    input_head = malloc(sizeof(struct input_item));
    input_head->Token = get_next_token();
    input_tail = input_head;
    input_head->next_input = input_tail;

}

/** Free global parser data objects
 *  -------------------------------------
 *  Frees the stack_top and input structures.
 *  DOES NOT free the head of the parse tree
 *  
 */
void free_parser_objects()
{
    free(stack_top);
    free(input_head);
}

/** Parse the input stream
 *
 *
 *  returns: A pointer to the head of the parse tree.
 */
struct tree_node * build_parse_tree()
{

    printf("Building parse tree\n");//DEBUG

    initialize_parser_objects();

    struct token *t;

    for(;;){//loop until break;


        t = input_head->Token;
        printf("\n");//DEBUG
        //if t is endcase, break
        if( t == NULL || t == (void *) 1){  //no file or cannot scan file
            free_token(t);
            return NULL;
        }
        else if(t == (void *) 2){  //end of file reached, return tree
            //free_token(t);
            break;
        }

        printf("TREE HEAD: %p\n", tree_curr);

        printf("\nNew token\n");//DEBUG
        printf("Token is %s, lexeme: %s, op?: %d\n", getEnumName(t->type), 
                t->lexeme, t->op_type); //DEBUG

        //update the current tree pointer
        if(stack_peek() != NULL){
            tree_curr = stack_peek()->tree_pos;
        }
        else{
            tree_curr = tree_head;
        }
        Symbol s = (stack_peek())->symbol;
        if( s <= 0 || s >= ERROR_SYMBOL){ s = ERROR_SYMBOL; }

        printf("symbol is:%d, %s\n", s, getStackSymbolName(s));//DEBUG

        printf("t->lexeme: %s\n", t->lexeme);
        int success = stack_operation[s-1](t);
        if (success != 0){
            break;
        }

        
    }

    
    free_parser_objects();
    

    return tree_head;

}


/** Log an error during parsing
 *  ---------------------------
 *  If during the process of building the parse tree there is an incorrect input,
 *      print an error message.
 *
 *  error: the top of the stack
 *
 */
void log_error(Symbol error)
{
    printf("Error during creation of the parse tree!\n");
    printf("Stack top was: %s\n", getStackSymbolName(error));
}

/** Print node attributes
 *  ---------------------
 *  Prints the lexemes of attributes struct
 */
void fprintf_attributes(FILE *fp, struct tree_node *curr)
{

    if(curr == NULL){
        return;
    }
    else{
        fprintf(fp, "(");
        if(curr->attributes.x == NULL || curr->attributes.x->lexeme == NULL){
            fprintf(fp, ", ");
        }
        else{
            fprintf(fp, "%s, ", curr->attributes.x->lexeme);
        }
        if(curr->attributes.eq == NULL || curr->attributes.eq->lexeme == NULL){
            fprintf(fp, ", ");
        }
        else{
            fprintf(fp, "%s, ", curr->attributes.eq->lexeme);
        }
        if(curr->attributes.a == NULL || curr->attributes.a->lexeme == NULL){
            fprintf(fp, ", ");
        }
        else{
            fprintf(fp, "%s, ", curr->attributes.a->lexeme);
        }
        if(curr->attributes.op == NULL || curr->attributes.op->lexeme == NULL){
            fprintf(fp, ", ");
        }
        else{
            fprintf(fp, "%s, ", curr->attributes.op->lexeme);
        }
        if(curr->attributes.b == NULL || curr->attributes.b->lexeme == NULL){
        }
        else{
            fprintf(fp, "%s ", curr->attributes.b->lexeme);
        }
        fprintf(fp, ")\n");
    }
}



/** Print out the parse tree
 *  ------------------------
 *  Purely for debugging purposes.
 *
 */
int print_parse_tree(struct tree_node *head, int parent, int order)
{
    if(head == NULL){
        return 0;
    }
    printf("\nNode: %d. parent: %d\t\ttype: %s\n", order, parent, getStackSymbolName(head->node_type));
    printf("head: %p\n", head);//DEBUG
    printf("\tAt address: %p.  Parent: %p\n", head, head->parent);
    fprintf_attributes(stdout, head);
    //printf("child: %p\n", head->first_child);
    parent = order;
    order++;

    //moving on to children
    head = head->first_child;
    while(head != NULL){
        order = print_parse_tree(head, parent, order);
        head = head->right_sibling;
    }

    return order;
}
/** Free the tree
 *  ------------------------
 *
 */
int free_parse_tree(struct tree_node *head)
{
    if(head == NULL){
        return 0;
    }
    struct tree_node *tmp1;
    struct tree_node *tmp2;
    //moving on to children
    tmp1 = head->first_child;
    while(tmp1 != NULL){
        tmp2 = tmp1->right_sibling;
        free_parse_tree(tmp1);
        tmp1 = tmp2;
    }
    free(head);
    return 0;
}

