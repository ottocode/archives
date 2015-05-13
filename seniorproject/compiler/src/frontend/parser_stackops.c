/** Stack operations for the NIC Parser
 *  ========================================================================
 *
 *  What to do, and how to do it for all of the stack/tree operations
 *
 *  Funtions are named based on what is at the top of the stack.
 *
 *  Last Modified: 4/17/14
 *  Contributor(s): Nicholas Otto
 */
#include <stdio.h>
#include <stdlib.h>
#include "../utility/structures.h"
#include "parser.h"

extern struct tree_node *tree_curr;        //the current node of the parse tree
extern struct stack_item *stack_top;       //the top of the stack
extern struct input_item *input_stream_head;    //the front of the input stream
extern struct input_item *input_stream_tail;    //the front of the input stream

/** Compound Statement
 *  Check that token is: {
 *  Add a compund statement to the tree
 *  Push onto stack:  }, statement-list, declaration-list 
 */
int compound_statement(struct token *token)
{
    printf("Hello from compound statement\n");//DEBUG

    if( token->type == OP && token->op_type == OPENSCOPE){
        tree_mknode(COMPOUND_STATEMENT);
        stack_pop();

        stack_push( TOKEN_CLOSESCOPE ); // }
        stack_push( STATEMENT_LIST );
        stack_push( DECLARATION_LIST );

        input_consume();
        free_token(token);
    }
    else{
        printf("Input not '{'\n");
        log_error(COMPOUND_STATEMENT);
        return -1;
    }

    return 0;
}

int declaration_list(struct token *token)
{
    printf("Hello from declaration list\n");//DEBUG
    
    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    if (ifkw == NULL){ //not a keyword
        printf("%s, not a keyword\n", token->lexeme);//DEBUG
        stack_pop();
    }
    else{ //check if right kind of keyword
        if( (ifkw->data->id == KW_TYPEQUALIFIER) ||
            (ifkw->data->id == KW_TYPESPECIFIER)){
            stack_push(DECLARATION);
            printf("%s, IS a keyword\n", token->lexeme);//DEBUG
        }
        else{
            stack_pop();
        }
    }

    return 0;
}

int declaration(struct token *token)
{ 
    printf("Hello from declaration\n");//DEBUG
    
    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    if (ifkw == NULL){ //not a keyword
        printf("%s, not a keyword\n", token->lexeme);//DEBUG
        log_error(DECLARATION);
        return -1;
    }
    else{ //check if right kind of keyword
        if( (ifkw->data->id == KW_TYPEQUALIFIER) ||
            (ifkw->data->id == KW_TYPESPECIFIER)){

            tree_mknode(DECLARATION);
            stack_pop();
            stack_push(TOKEN_ENDSTATEMENT);// ';' 
            stack_push(TYPEDEF_NAME);
            stack_push(DECLARATION_SPECIFIERS);
        }
        else{
            log_error(DECLARATION);
            return -1;
        }
    }
    return 0;
}

int declaration_specifiers(struct token *token)
{ 
    printf("Hello from declaration speficiers\n");//DEBUG
    
    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    if (ifkw == NULL){ //not a keyword
        printf("%s, not a keyword\n", token->lexeme);//DEBUG
        log_error(DECLARATION);
        return -1;
    }
    else{ //check if right kind of keyword
        if( ifkw->data->id == KW_TYPEQUALIFIER){
            tree_mknode(DECLARATION_SPECIFIERS);
            stack_pop();
            stack_push(POINTER_QUALIFIER);
            stack_push(TYPE_SPECIFIER);
            stack_push(TYPE_QUALIFIER);
        }
        else if( ifkw->data->id == KW_TYPESPECIFIER){
            tree_mknode(DECLARATION_SPECIFIERS);
            stack_pop();
            stack_push(POINTER_QUALIFIER);
            stack_push(TYPE_SPECIFIER);
        }
        else{
            log_error(DECLARATION_SPECIFIERS);
            return -1;
        }
    }
    return 0; 
}

int type_qualifier(struct token *token)
{
    printf("Hello from type_qualifier\n");//DEBUG
    
    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    if (ifkw == NULL){ //not a keyword
        printf("%s, not a keyword\n", token->lexeme);//DEBUG
        log_error(TYPE_QUALIFIER);
        return -1;
    }
    else{ //check if right kind of keyword
        if( ifkw->data->id == KW_TYPEQUALIFIER){
            tree_mknode(TYPE_QUALIFIER);
            stack_pop();

            tree_add_attr(ifkw->data, 0);//TODO
            input_consume();
            free(token);
            return 0;
        }
        else{
            log_error(DECLARATION);
            return -1;
        }
    }
    return 0;
}

int type_specifier(struct token *token)
{
    printf("Hello from type_specifier\n");//DEBUG
    
    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    if (ifkw == NULL){ //not a keyword
        printf("%s, not a keyword\n", token->lexeme);//DEBUG
        log_error(TYPE_SPECIFIER);
        return -1;
    }
    else{ //check if right kind of keyword
        if( ifkw->data->id == KW_TYPESPECIFIER){
            tree_mknode(TYPE_SPECIFIER);
            stack_pop();
            tree_add_attr(ifkw->data, 1);//TODO
            input_consume();
            free(token);
            return 0;
        }
        else{
            log_error(TYPE_SPECIFIER);
            return -1;
        }
    }

    return 0;
}

int pointer_qualifier(struct token *token)
{
    printf("Hello from pointer qualifier\n");
    if (token->op_type == STAR || token->op_type == MULTIPLY){
        
        struct hashentry *he = hash_retrieve(kwtable, token->lexeme);
        if (he == NULL){
            log_error(POINTER_QUALIFIER);
            printf("disconnect between scanner's %s and parser!\n", token->lexeme);
            return -1;
        }
        tree_add_attr(he->data, 2);
        input_consume();
        free_token(token);
    }
    else{
        stack_pop();
    }
    return 0;
}

int typedef_name(struct token *token)
{
    printf("Hello from typedef_name\n");//DEBUG
    
    if (token->type != ID_KW){
        printf("Not an identifier!\n");//DEBUG
        log_error(TYPEDEF_NAME);
        return -1;
    }

    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    if (ifkw != NULL){ //not a keyword
        printf("%s, not an identifier\n", token->lexeme);//DEBUG
        log_error(TYPEDEF_NAME);
        return -1;
    }
    else{ //add to symboltable
        //create a new identifier for symbol table
        struct identifier *newid = malloc(sizeof(struct identifier *));
        type_id(newid->type);
        newid->op_type = 0;
        newid->kw_name = 0;
        newid->lexeme = token->lexeme;

        //ensure not already in the symbol table
        struct hashentry *entry = hash_insert(symboltable, newid);
        if (entry == NULL){
            log_error(TYPEDEF_NAME);
            printf("Error inserting into symbol table!\n");
            return -1;
        }
        else if (entry == (void *)1){
            log_error(TYPEDEF_NAME);
            printf("%s is already defined!\n", newid->lexeme);
            return -1;
        }

        //make the tree node, and add the attribute
        tree_mknode(TYPEDEF_NAME);
        stack_pop();
        tree_add_attr(newid, 3);//TODO
        input_consume(); //consume the identifier

        struct token *t = input_peek();
        if (t->op_type == OPENBRACKET){
            input_consume();
            stack_push(DEFINE_ARRAY);
        }
        free(token);
    }
    printf("leaving typedef_name\n");//DEBUG;

    return 0;
}

//TODO 
int define_array(struct token *token)
{
    printf("Hello from define_array!\n");//DEBUG

    //needs to be a constant value, since assignments have not been made
    if ( (token->type >= C_NUM) && (token->type <= C_F)){
        struct identifier *nid = malloc(sizeof(struct identifier));
        nid->lexeme = token->lexeme;
        type_const(nid->type);
        nid->op_type = 0;
        nid->kw_name = 0;
        hash_insert(symboltable, nid);

        tree_mknode(DEFINE_ARRAY);
        stack_pop();
        input_consume();

        tree_add_attr(nid, 4);
        free(token);

        struct token *t = input_consume();
        if (t->op_type == CLOSEBRACKET){
            return 0;
        }
        else{
            log_error(DEFINE_ARRAY);
            printf("Incorrect token \"%s\", expecting \"]\".\n", t->lexeme);
            return -1;
        }
    }
    else{
        return -1;
    }
}

int statement_list(struct token *token)
{
    printf("Hello from statement_list\n");//DEBUG
    printf("tree_curr parent %p\n", tree_curr->parent);//DEBUG
    if( (token->type == OP)){
        if (token->op_type == CLOSESCOPE){
            stack_pop();
        }
        else{
            stack_push(STATEMENT);
        }
    }
    else{
        stack_push(STATEMENT);
    }
    return 0;
}

int statement(struct token *token)
{
    printf("Hello from statement\n");//DEBUG

    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    if (ifkw != NULL){ //is a keyword
        if (strncmp("goto", token->lexeme, 4) == 0){
            tree_mknode(STATEMENT);
            stack_pop();
            stack_push(JUMP_STATEMENT);
        }
        if (strncmp("begin", token->lexeme, 5) == 0){
            tree_mknode(STATEMENT);
            stack_pop();
            stack_push(LABELED_STATEMENT);
        }
    }
    else if (token->op_type == CLOSESCOPE){
        stack_pop(); //not a statement
    }
    else{
        tree_mknode(STATEMENT);
        stack_pop();
        stack_push(EXPRESSION_STATEMENT);
    }
    return 0;
}

//TODO
int labeled_statement(struct token *token)
{
    printf("hello from labeled statement\n");//DEBUG
    //need to make node
    //consume the "begin" kw (check for it first)
    //consume and add the next identifier token (check)
    //check and consume the final ':'
    input_consume(); // "begin"
    free_token(token);
    struct token *t = input_consume(); // the identifier
    struct hashentry *label = hash_retrieve(kwtable, t->lexeme);
    struct token *colon = input_consume(); //should be ':'

    if(label == NULL && colon->op_type == TERNC){ //good, not a keyword
        tree_mknode(LABELED_STATEMENT);

        struct hashentry *predefined;
        struct identifier *labelsym = malloc(sizeof(struct identifier));
        labelsym->lexeme = t->lexeme;

        predefined = hash_insert(symboltable, labelsym);
        if(predefined == NULL || predefined == (void *)1){
            log_error(LABELED_STATEMENT);
            printf("Symbol: %s has previously been defined\n", t->lexeme);
            return -1;
        }
        type_id(labelsym->type);
        labelsym->op_type = 0;

        struct hashentry *beginkw = hash_retrieve(kwtable, "begin");

        tree_add_attr(beginkw->data, 0);
        tree_add_attr(labelsym, 1);
        free(t);
        free(colon);
        stack_pop();
        return 0;
    }
    else{
        log_error(LABELED_STATEMENT);
        return -1;
    }
}

int jump_statement(struct token *token)
{
    printf("Hello from jump_statement\n");//DEBUG
    // goto label conditional
    if( strncmp("goto", token->lexeme, 4) == 0){
        tree_mknode(JUMP_STATEMENT);
        input_consume(); //consume the goto
        free_token(token);
        struct token *label = input_consume();
        struct token *conditional = input_consume();
        if (label->type == ID_KW){
            struct hashentry *ifkw = hash_retrieve(kwtable, label->lexeme);
            if (ifkw == NULL){//not a keyword, an identifier

                struct hashentry *predefined;
                struct hashentry *predefined2;

                //get symboltable entry for label
                predefined = hash_retrieve(symboltable, label->lexeme);
                if(predefined == NULL){
                    predefined = malloc(sizeof(struct hashentry));
                    predefined->data = malloc(sizeof(struct identifier));
                    predefined->data->lexeme = label->lexeme;
                    type_id(predefined->data->type);
                    //log_error(LABELED_STATEMENT);
                    //printf("Symbol: %s has not been defined!\n", label->lexeme);
                    //return -1;
                }
                //get symboltable entry for conditional
                predefined2 = hash_retrieve(symboltable, conditional->lexeme);
                if(predefined2 == NULL){
                    log_error(LABELED_STATEMENT);
                    printf("Symbol: %s has not been defined!\n", conditional->lexeme);
                    return -1;
                }

                struct hashentry *gokw = hash_retrieve(kwtable, "goto");

                tree_add_attr(gokw->data, 0);
                tree_add_attr(predefined->data, 1);
                tree_add_attr(predefined2->data, 2);

                printf("Consumed: goto %s %s\n", 
                    label->lexeme, conditional->lexeme);//DEBUG
                stack_pop();
                stack_push(TOKEN_ENDSTATEMENT);
                free(label);
                free(conditional);
                return 0;
            }
            else{
                log_error(JUMP_STATEMENT);
                free_token(label);
                free_token(conditional);
                return -1;
            }
        }
        else{
            printf("Incorrect goto label: %s\n", label->lexeme);//DEBUG
            free_token(label);
            free_token(conditional);
            log_error(JUMP_STATEMENT);
            return -1;
        }
    }
    else{
        log_error(JUMP_STATEMENT);
        return -1;
    }
}

int expression_statement(struct token *token)
{
    printf("Hello from expression statement\n");
    if (token->op_type == CLOSESCOPE){// is operator
        log_error(EXPRESSION_STATEMENT);
        return -1;
    }
    else{
        tree_mknode(EXPRESSION_STATEMENT);
        stack_pop();
        stack_push(TOKEN_ENDSTATEMENT);
        stack_push(EXPRESSION);
        return 0;
    }
}

int expression(struct token *token)
{
    printf("Hello from expression\n");
    
    if (token->op_type == EOE){  // ';'
        stack_pop();
        return 0;
    }
    else if (token->op_type == CLOSESCOPE){ // '}'
        log_error(EXPRESSION);
        return -1;
    }
    else{
        tree_mknode(EXPRESSION);
        stack_pop();
        stack_push(ASSIGNMENT_EXPRESSION);
        return 0;
    }
}

int assignment_expression(struct token *token)
{
    printf("Hello from assignment expression\n");
    if ( (token->op_type == CLOSESCOPE) ||
         (token->op_type == EOE)){
        log_error(ASSIGNMENT_EXPRESSION);
        return -1;
    }
    else{
        tree_mknode(ASSIGNMENT_EXPRESSION);
        stack_pop();
        stack_push(RVALUE);
        stack_push(ASSIGNMENT_OPERATOR);
        stack_push(LVALUE);
        return 0;
    }
}

int lvalue(struct token *token)
{
    // & operator not allowed on lhs
    printf("Hello from lvalue\n");//DEBUG
    if ((token->op_type == STAR) ||
        (token->op_type == MULTIPLY)){ //must be interpreted as star
        token->op_type = STAR;
        tree_mknode(LVALUE);
        stack_pop();

 
        struct hashentry *he = hash_retrieve(kwtable, token->lexeme);
        if (he == NULL){
            log_error(LVALUE);
            printf("disconnect between scanner's %s and parser!\n", token->lexeme);
            return -1;
        }


        tree_add_attr(he->data, 0);
        input_consume();
        stack_push(LPOSTFIX_EXPRESSION);
        free_token(token);
        return 0;
    }
    else if (token->type == ID_KW){
        //check if keyword
        struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
        if (ifkw == NULL){ // identifier
            tree_mknode(LVALUE);
            stack_pop();
            stack_push(LPOSTFIX_EXPRESSION);
            return 0;
        }
        else{
            log_error(LVALUE);
            return -1;
        }
    }
    else{
        log_error(LVALUE);
        return -1;
    }
}

int assignment_operator(struct token *token)
{
    printf("Hello from assignment operator!\n");//DEBUG
    if(token->op_type == ASSIGN){
        printf("found the assignment!\n");//DEBUG
        tree_mknode(ASSIGNMENT_OPERATOR);
        stack_pop();
 
        struct hashentry *he = hash_retrieve(kwtable, token->lexeme);
        if (he == NULL){
            log_error(ASSIGNMENT_OPERATOR);
            printf("disconnect between scanner's %s and parser!\n", token->lexeme);
            return -1;
        }


        tree_add_attr(he->data, 1);
        input_consume();


        free_token(token);
        return 0;
    }
    return -1;
}

int rvalue(struct token *token)
{
    if (token->op_type == OPENPAREN){ // '('
        tree_mknode(RVALUE);
        stack_pop();
        stack_push(CAST_EXPRESSION);
        input_consume();
        free_token(token);
        return 0;
    }
    else if ((token->op_type == CLOSESCOPE) ||
             (token->op_type == EOE)){
        log_error(RVALUE);
        return -1;
    }
    else{
        tree_mknode(RVALUE);
        stack_pop();
        stack_push(LRVALUE);
        stack_push(BINARY_OP);
        stack_push(LRVALUE);
        return 0;
    }
}

int lrvalue(struct token *token)
{
    if ((token->op_type == STAR) ||
        (token->op_type == AND) ||
        (token->op_type == MULTIPLY) ||
        (token->op_type == BWAND)){
        //is a reference operator
        tree_mknode(LRVALUE);
        stack_pop();
        stack_push(POSTFIX_EXPRESSION);
        stack_push(REFERENCE_OPERATOR);
        return 0;
    }
    else if ((token->op_type == EOE) ||
             (token->op_type == CLOSESCOPE)){
        log_error(LRVALUE);
        return -1;
    }
    else{
        tree_mknode(LRVALUE);
        stack_pop();
        stack_push(POSTFIX_EXPRESSION);
        return 0;
    }
}

int binary_op(struct token *token)
{
    switch (token->op_type){

    case LOGOR:
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(LOGICAL_OR_EXPRESSION);
        return 0;
    case LOGAND:
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(LOGICAL_AND_EXPRESSION);
        return 0;
    case BWOR:
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(INCLUSIVE_OR_EXPRESSION);
        return 0;
    case BWXOR:
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(EXCLUSIVE_OR_EXPRESSION);
        return 0;
    case BWAND:
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(AND_EXPRESSION);
        return 0;
    case EQUALS: case NOTEQUALS:
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(EQUALITY_EXPRESSION);
        return 0;
    case LT: case LE: case GT: case GE:
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(RELATIONAL_EXPRESSION);
        return 0;
    case SHIFTLEFT: case SHIFTRIGHT: 
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(SHIFT_EXPRESSION);
        return 0;
    case PLUS: case MINUS:                    // + -
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(ADDITIVE_EXPRESSION);
        return 0;
    case MULTIPLY: case DIVIDE: case MODULO:       // * / %
        tree_mknode(BINARY_OP);
        stack_pop();
        stack_push(MULTIPLICATIVE_EXPRESSION);
        return 0;
    case EOE: //direct expression
        //tree_mknode(BINARY_OP);
        //tree_add_attr(token, -1);
        stack_pop(); //pop the binary op
        stack_pop(); //pop the second lrvalue
        return 0;
    default:
        log_error(BINARY_OP);
        return -1;
    }
}

int reference_operator(struct token *token)
{
    if ((token->op_type == STAR) ||
        (token->op_type == AND) ||
        (token->op_type == MULTIPLY) ||
        (token->op_type == BWAND)){
        tree_mknode(REFERENCE_OPERATOR);

        struct hashentry *he = hash_retrieve(kwtable, token->lexeme);
        if (he == NULL){
            log_error(ASSIGNMENT_OPERATOR);
            printf("disconnect between scanner's %s and parser!\n", token->lexeme);
            return -1;
        }


        tree_add_attr(he->data, 0);
        input_consume();


        stack_pop();
        free_token(token);
        return 0;
    }
    else {
        log_error(REFERENCE_OPERATOR);
        return -1;
    }
}


int postfix_expression(struct token *token)
{

    if ((token->type >= ID_KW) && (token->type <= S_C)){
        if(token->type == ID_KW){ 
            struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
            if (ifkw != NULL){ //is a keyword
                log_error(POSTFIX_EXPRESSION);
                return -1;
            }
        }
        
        //if identifier
        if (token->type == ID_KW){ //already checked if kw
            struct hashentry *entry = hash_retrieve(symboltable, token->lexeme);
            if (entry == NULL){ //not defined
                log_error(POSTFIX_EXPRESSION);
                printf("%s has not been defined!\n", token->lexeme);
                return -1;
            }
            else{
                tree_mknode(POSTFIX_EXPRESSION);
                tree_add_attr(entry->data, 1);
                input_consume();
                free_token(token);
                stack_pop();
                stack_push(PRIMARY_EXPRESSION_MODS);
                return 0;
            }
        }
        else{ //should be some sort of constant
            struct identifier *c = malloc(sizeof(struct identifier));
            type_const(c->type);
            c->lexeme = token->lexeme;

            tree_mknode(POSTFIX_EXPRESSION);
            tree_add_attr(c, 1);
            input_consume();
            free(token);
            stack_pop();
            return 0;
        }
    }
    else{
        log_error(POSTFIX_EXPRESSION);
        return -1;
    }

}

int lpostfix_expression(struct token *token)
{
    if (token->type == ID_KW){
        struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
        if (ifkw != NULL){ //is a keyword
            log_error(LPOSTFIX_EXPRESSION);
            return -1;
        }
        else{
            struct hashentry *entry = hash_retrieve(symboltable, token->lexeme);
            if (entry == NULL){ //not defined
                log_error(POSTFIX_EXPRESSION);
                printf("%s has not been defined!\n", token->lexeme);
            }
            else{
                tree_mknode(LPOSTFIX_EXPRESSION);
                tree_add_attr(entry->data, 1);
                input_consume();
                free_token(token);
                stack_pop();
                stack_push(PRIMARY_EXPRESSION_MODS);
                return 0;
            }
        }

    }
    else{
        log_error(LPOSTFIX_EXPRESSION);
        return -1;
    }
    return -1;
}

int primary_expression_list(struct token *token)
{
    struct token *peek = input_peek();
    if (peek->op_type == COMMA){
        stack_push(PRIMARY_EXPRESSION);
        return 0;
    }
    else{
        stack_pop(); //just one primary expression max
        stack_push(PRIMARY_EXPRESSION);
        return 0;
    }
}

int primary_expression(struct token *token)
{
    if ((token->type >= ID_KW) && (token->type <= S_C)){
        if(token->type == ID_KW){ 
            struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
            if (ifkw != NULL){ //is a keyword
                log_error(PRIMARY_EXPRESSION);
                return -1;
            }
        }
 
        //if identifier
        if (token->type == ID_KW){ //already checked if kw
            struct hashentry *entry = hash_retrieve(symboltable, token->lexeme);
            if (entry == NULL){ //not defined
                log_error(PRIMARY_EXPRESSION);
                printf("%s has not been defined!\n", token->lexeme);
                return -1;
            }
            else{
                tree_mknode(PRIMARY_EXPRESSION);
                tree_add_attr(entry->data, 1);
                input_consume();
                free_token(token);
                stack_pop();
                return 0;
            }
        }
        else{ //should be some sort of constant
            struct identifier *c = malloc(sizeof(struct identifier));
            type_const(c->type);
            c->lexeme = token->lexeme;

            tree_mknode(PRIMARY_EXPRESSION);
            tree_add_attr(c, 3);
            input_consume();
            free(token);
            stack_pop();
            return 0;
        }
    }
    else{
        log_error(PRIMARY_EXPRESSION);
        printf("undefined error in parsing primary expression\n");
        return -1;
    }
}

int primary_expression_mods(struct token *token)
{
    printf("Hello from primary_expression_mods\n");
    if (token->op_type == OPENPAREN){
        tree_mknode(-1); //TODO implement '('
        input_consume();
        free_token(token);
        stack_pop();
        stack_push(TOKEN_CLOSEPAREN); //')'
        stack_push(PRIMARY_EXPRESSION_LIST);
        return -1;
    }
    else if (token->op_type == OPENBRACKET){
        tree_mknode(PRIMARY_EXPRESSION_MODS);
        input_consume(); //get the [
        free_token(token);
        stack_pop();
        struct token *t = input_consume(); //the inner part of the [x]

        struct identifier *nid = malloc(sizeof(struct identifier));
        nid->lexeme = t->lexeme;
        if (t->type == ID_KW){
            struct hashentry *he = hash_retrieve(kwtable, nid->lexeme);
            if (he != NULL){ //is a keyword (an error)
                log_error(PRIMARY_EXPRESSION_MODS);
                return -1;
            }
            else{
                he = hash_retrieve(symboltable, nid->lexeme);
                if (he == NULL){ //symbol not defined
                    log_error(PRIMARY_EXPRESSION_MODS);
                    printf("%s has not been initialized\n", nid->lexeme);
                    return -1;
                }
                else{
                    tree_add_attr(he->data, 4);
                    free_token(t);
                    input_consume();    //the last ]
                    return 0;
                }
            }
        }
        else if (t->type >= C_NUM && t->type <= C_F){
            struct identifier *id = malloc(sizeof(struct identifier));
            id->lexeme = t->lexeme;
            type_const(id->type);
            tree_add_attr(id, 4); //add it as attribute
            free(t);
            input_consume(); // the last ]
            return 0;
        }
        else{
            log_error(PRIMARY_EXPRESSION_MODS);
            printf("%s has not been initialized\n", nid->lexeme);
            return -1;
        }
    }
    else if (token->op_type == VALUEAT){
        input_consume(); // throw away '.'
        struct token *tmp = input_consume(); //get the identifier
        struct hashentry *ifkw = hash_retrieve(kwtable, tmp->lexeme);
        if (ifkw != NULL){ //error is a keyword
            log_error(PRIMARY_EXPRESSION_MODS);
            return -1;
        }
        else{
            tree_mknode(-1); //TODO implement '.'
            free_token(token);
            stack_pop();
            stack_push(PRIMARY_EXPRESSION);
            return -1;
        }
    }
    else{ //not a mod of a primary expression
        stack_pop();
        return 0;
    }
}

int logical_or_expression(struct token *token)
{
    if (token->op_type == LOGOR){
        tree_mknode(LOGICAL_OR_EXPRESSION);
        stack_pop();
        input_consume();//don't really need to save it
        free_token(token);
        return 0;
    }
    else{
        log_error(LOGICAL_OR_EXPRESSION);
        return -1;
    }
}

int logical_and_expression(struct token *token)
{
    if (token->op_type == LOGAND){
        tree_mknode(LOGICAL_AND_EXPRESSION);
        stack_pop();
        input_consume();//don't really need to save it
        free_token(token);
        return 0;
    }
    else{
        log_error(LOGICAL_AND_EXPRESSION);
        return -1;
    }
}

int inclusive_or_expression(struct token *token)
{
    if (token->op_type == BWOR){
        tree_mknode(INCLUSIVE_OR_EXPRESSION);
        stack_pop();
        input_consume();//don't really need to save it
        free_token(token);
        return 0;
    }
    else{
        log_error(INCLUSIVE_OR_EXPRESSION);
        return -1;
    }
}

int exclusive_or_expression(struct token *token)
{
    if (token->op_type == BWXOR){
        tree_mknode(EXCLUSIVE_OR_EXPRESSION);
        stack_pop();
        input_consume();//don't really need to save it
        free_token(token);
        return 0;
    }
    else{
        log_error(EXCLUSIVE_OR_EXPRESSION);
        return -1;
    }
}

int and_expression(struct token *token)
{
    if (token->op_type == BWAND){
        tree_mknode(AND_EXPRESSION);
        stack_pop();
        input_consume();//don't really need to save it
        free_token(token);
        return 0;
    }
    else{
        log_error(AND_EXPRESSION);
        return -1;
    }
}

int equality_expression(struct token *token)
{
    if ((token->op_type == EQUALS) || (token->op_type == NOTEQUALS)){
        tree_mknode(EQUALITY_EXPRESSION);
        
        //initialize new identifier and set op_type to same as token
        struct identifier *eq = malloc(sizeof(struct identifier));
        type_op(eq->type);
        eq->op_type = token->op_type;
        eq->lexeme = token->lexeme;
        tree_add_attr(eq, 3);

        input_consume();
        stack_pop();
        free(token);
        return 0;
    }
    else{
        log_error(EQUALITY_EXPRESSION);
        return -1;
    }
}

int relational_expression(struct token *token)
{
    if ((token->op_type == LT) || 
        (token->op_type == LE) ||
        (token->op_type == GT) ||
        (token->op_type == GE)){
        tree_mknode(RELATIONAL_EXPRESSION);
        
        //initialize new identifier and set op_type to same as token
        struct identifier *op = malloc(sizeof(struct identifier));
        type_op(op->type);
        op->op_type = token->op_type;
        op->lexeme = token->lexeme;
        tree_add_attr(op, 3);

        input_consume();

        stack_pop();
        free(token);
        return 0;
    }
    else{
        log_error(RELATIONAL_EXPRESSION);
        return -1;
    }
}

int shift_expression(struct token *token)
{
    if ((token->op_type == SHIFTLEFT) || (token->op_type == SHIFTRIGHT)){
        tree_mknode(SHIFT_EXPRESSION);

        //initialize new identifier and set op_type to same as token
        struct identifier *op = malloc(sizeof(struct identifier));
        type_op(op->type);
        op->op_type = token->op_type;
        op->lexeme = token->lexeme;
        tree_add_attr(op, 3);

        input_consume();

        stack_pop();
        free(token);
        return 0;
    }
    else{
        log_error(SHIFT_EXPRESSION);
        return -1;
    }
}

int additive_expression(struct token *token)
{
    printf("hello from additive_expression\n");
    if ((token->op_type == PLUS) || 
        (token->op_type == POSITIVE) ||
        (token->op_type == MINUS) ||
        (token->op_type == NEGATIVE)){
        tree_mknode(ADDITIVE_EXPRESSION);

        //initialize new identifier and set op_type to same as token
        struct identifier *op = malloc(sizeof(struct identifier));
        type_op(op->type);
        op->op_type = token->op_type;
        op->lexeme = token->lexeme;
        tree_add_attr(op, 3);

        input_consume();

        stack_pop();
        free(token);
        return 0;
    }
    else{
        log_error(ADDITIVE_EXPRESSION);
        return -1;
    }
}

int multiplicative_expression(struct token *token)
{
    printf("hello from multiplicative_expression\n");//DEBUG
    if ((token->op_type == STAR) || 
        (token->op_type == MULTIPLY) ||
        (token->op_type == DIVIDE) ||
        (token->op_type == MODULO)){
        tree_mknode(MULTIPLICATIVE_EXPRESSION);

        //initialize new identifier and set op_type to same as token
        struct identifier *op = malloc(sizeof(struct identifier));
        type_op(op->type);
        op->op_type = token->op_type;
        op->lexeme = token->lexeme;
        tree_add_attr(op, 3);

        input_consume();

        stack_pop();
        free(token);
        return 0;    
    }
    else{
        log_error(MULTIPLICATIVE_EXPRESSION);
        return -1;
    }
}

int cast_expression(struct token *token)
{
    printf("hello from cast_expression\n");//DEBUG
    //need to get 'type' ')' 'lrvalue'
    struct hashentry *ifkw = hash_retrieve(kwtable, token->lexeme);
    
    if (ifkw == NULL){ //not a keyword, error
        log_error(CAST_EXPRESSION);
        return -1;
    }
    else {
        //TODO implement actual check
        tree_mknode(CAST_EXPRESSION);
        tree_add_attr(ifkw->data, 0);
        input_consume();
        stack_pop();
        free_token(token);
        stack_push(LRVALUE);
        stack_push(TOKEN_CLOSEPAREN);
        return 0;
    }
}

int direct_expression(struct token *token)
{
    //TODO check if needed
    printf("Direct ExpressionNot Implemented\n");//DEBUG
    log_error(DIRECT_EXPRESSION);
    return -1;
}

int token_openparen(struct token *token)
{  
    printf("hello from token_openparen\n");
    if(token->op_type == OPENPAREN){
        input_consume();
        free_token(token);
        stack_pop();
        return 0;
    }
    else{
        log_error(TOKEN_OPENPAREN);
        return -1;
    }
}

int token_closeparen(struct token *token)
{
    printf("hello from token_closeparen\n");
    if(token->op_type == CLOSEPAREN){
        input_consume();
        free_token(token);
        stack_pop();
        return 0;
    }
    else{
        log_error(TOKEN_CLOSEPAREN);
        return -1;
    }
}

int token_openscope(struct token *token)
{
    printf("hello from token_openscope\n");
    if(token->op_type == OPENSCOPE){
        input_consume();
        free_token(token);
        stack_pop();
        return 0;
    }
    else{
        log_error(OPENSCOPE);
        return -1;
    }
}

int token_closescope(struct token *token)
{
    printf("hello from token_closescope\n");
    if(token->op_type == CLOSESCOPE){
        input_consume();
        free_token(token);
        stack_pop();
        return 0;
    }
    else{
        log_error(TOKEN_CLOSESCOPE);
        return -1;
    }
}

int token_endstatement(struct token *token)
{
    printf("hello from token_endstatement\n");
    if (token->op_type == EOE){
        stack_pop();
        input_consume();
        free_token(token);
    }
    else{
        log_error(TOKEN_ENDSTATEMENT);
        free_token(token);
        return -1;
    }
    return 0;
}

int error_symbol(struct token *token)
{
    printf("Hello from error_symbol\n");//DEBUG
    return -1;
}

