#include <stdlib.h>
#include <string.h>
#include "utility.h"
#include "structures.h"

#define EOS '\0'

char* keywords[NUMKEYWORDS] = {
"auto", "begin", "break","case","char",
"const","continue","default","do",
"double","else","enum","extern",
"float","for","goto","if",
"int","long","register","return",
"short","signed","sizeof","static",
"struct","switch","typedef","union",
"unsigned","void","volatile","while"};

//the kw and symbol table structures
struct hashentry *kwtable[PRIME];
struct hashentry *symboltable[PRIME];

void free_token(struct token *t){
    if (t != NULL){
        if (t->lexeme != NULL){
            free(t->lexeme);
        }
        free(t);
    }
}

/* Hash function from pg 436 red dragon book.
 * May be good idea to fiddle with PRIME value.
 * Hashes the character array passed in as s;
 *
 * Requires: character array to be null teminated '\0'
 * Returns: integer hashed value of s
 */
int hashpjw( char *s)
{
    char *p;
    unsigned h = 0, g;
    for( p = s; *p != EOS; p++){
        h = (h << 4) + *p;
        if ((g = h&0xf0000000)){
            h = h ^ (g >> 24);
            h = h ^ g;
        }
    }

    return h % PRIME;
}

struct hashentry * hash_insert(struct hashentry **table, struct identifier *data)
{
    struct hashentry *newentry;
    //check table and data values are initialized
    if(table == NULL || data == NULL){
        printf("invalid table or data\n");//DEBUG
        return NULL;
    }

    if (data->lexeme == NULL){
        return NULL;
    }
    else {
        struct hashentry *exists = hash_retrieve(table, data->lexeme);
        if (exists != NULL){
            return (void *)1;  //identifier with same data already entered
        }
    }
    
    long index = hashpjw(data->lexeme);

    //create the new entry
    newentry = malloc(sizeof(struct hashentry));
    newentry->data = data;
    newentry->nextentry = NULL;

    printf("inserting keyword: %s at index: %ld\n", newentry->data->lexeme, index);
    //if index open, just insert it
    if (table[index] == NULL){
        table[index] = newentry;
    }
    else{
        //if other values, insert at end of linked list
        struct hashentry *temp = table[index];
        while(temp->nextentry != NULL){
            temp = temp->nextentry;
        }
        temp->nextentry = newentry;
    }
        
    return newentry;
}

struct hashentry * hash_retrieve(struct hashentry **table, char *lexeme)
{ 
    //check table and data values are initialized
    if(table == NULL || lexeme == NULL){
        return NULL;
    }
    long index = hashpjw(lexeme);

    //if index null, return NULL
    if (table[index] == NULL){
        return NULL;
    }
    else{
        //loop through nextentry fields until found
        struct hashentry *temp = table[index];
        while (strcmp(temp->data->lexeme, lexeme) != 0){  //check id values
            if(temp->nextentry != NULL){//get next entry
                temp = temp->nextentry;
            }
            else{//none left, not found
                return NULL;
            }
        }
        //must have broken out of while loop if ids match
        return temp;
    }
}

/** Convert Enum To String
 *  -----------
 *  For debuggin purposes.
 *
 *  state: the state of the scanner
 *
 *  returns: "state" 
 */
const char* getEnumName(enum STATES state)
{
    switch(state){
        case EMPTY: return "EMPTY";         //starting
        case ID_KW: return  "ID_KW";        //ID or Keyword
        case C_NUM: return  "C_NUM";        //Number
        case C_NUMU: return  "C_NUMU";      //unsigned int
        case C_NUML: return  "C_NUML";      //long int
        case C_NUMUL: return  "C_NUMUL";    //unsigned long int
        case C_HEX0: return  "C_HEX0";      //open of hex constant
        case C_HEX1: return  "C_HEX1";      //okay hex constant
        case C_DF: return  "C_DF";          //float decimal
        case C_FE: return  "C_FE";          //float exponent
        case C_FS: return  "C_FS";          //float exponent sign
        case C_FED: return  "C_FED";        //float exponent sign digit
        case C_FF: return  "C_FF";          //float single precision
        case C_FL: return  "C_FL";          //float double precision
        case C_F: return "C_F";             //float okay
        case C_CO: return "C_CO";           //character opening
        case C_CE: return "C_CE";           //character escape
        case C_CD: return "C_CD";           //character digit
        case C_CC: return "C_CC";           //character close
        case S_O: return "S_O";             //string opening
        case S_E: return "S_E";             //string escape
        case S_D: return "S_D";             //string digit
        case S_C: return "S_C";             //string close
        case OP: return "OP";               //Operator
        case OP1: return "OP1";               //Chained operator
        case OP2: return "OP2";               //Chained 2nd operator
        default: return "UNKNOWN";
    }
}

/** Convert Stack Symbol To String
 *  ------------------------------
 *  For debuggin purposes.
 *
 *  symbol: the stack symbol
 *
 *  returns: "symbol" 
 */
const char* getStackSymbolName(enum SYMBOLS symbol)
{
    switch(symbol){
        case COMPOUND_STATEMENT: return "COMPOUND_STATEMENT";
        case DECLARATION_LIST: return "DECLARATION_LIST";
        case DECLARATION: return "DECLARATION";
        case DECLARATION_SPECIFIERS: return "DECLARATION_SPECIFIERS";
        case TYPE_QUALIFIER: return "TYPE_QUALIFIER";
        case TYPE_SPECIFIER: return "TYPE_SPECIFIER";
        case DEFINE_ARRAY: return "DEFINE_ARRAY";
        case POINTER_QUALIFIER: return "POINTER_QUALIFIER";
        case TYPEDEF_NAME: return "TYPEDEF_NAME";
        case STATEMENT_LIST: return "STATEMENT_LIST";
        case STATEMENT: return "STATEMENT";
        case LABELED_STATEMENT: return "LABELED_STATEMENT";
        case JUMP_STATEMENT: return "JUMP_STATEMENT";
        case EXPRESSION_STATEMENT: return "EXPRESSION_STATEMENT";
        case EXPRESSION: return "EXPRESSION";
        case ASSIGNMENT_EXPRESSION: return "ASSIGNMENT_EXPRESSION";
        case LVALUE: return "LVALUE";
        case ASSIGNMENT_OPERATOR: return "ASSIGNMENT_OPERATOR";
        case RVALUE : return "RVALUE";
        case LRVALUE: return "LRVALUE";
        case BINARY_OP: return "BINARY_OP";
        case REFERENCE_OPERATOR: return "REFERENCE_OPERATOR";
        case POSTFIX_EXPRESSION: return "POSTFIX_EXPRESSION";
        case LPOSTFIX_EXPRESSION: return "LPOSTFIX_EXPRESSION";
        case PRIMARY_EXPRESSION_LIST: return "PRIMARY_EXPRESSION_LIST";
        case PRIMARY_EXPRESSION: return "PRIMARY_EXPRESSION";
        case PRIMARY_EXPRESSION_MODS: return "PRIMARY_EXPRESSION_MODS";
        case LOGICAL_OR_EXPRESSION: return "LOGICAL_OR_EXPRESSION";
        case LOGICAL_AND_EXPRESSION: return "LOGICAL_AND_EXPRESSION";
        case INCLUSIVE_OR_EXPRESSION: return "INCLUSIVE_OR_EXPRESSION";
        case EXCLUSIVE_OR_EXPRESSION: return "EXCLUSIVE_OR_EXPRESSION";
        case AND_EXPRESSION: return "AND_EXPRESSION";
        case EQUALITY_EXPRESSION: return "EQUALITY_EXPRESSION";
        case RELATIONAL_EXPRESSION: return "RELATIONAL_EXPRESSION";
        case SHIFT_EXPRESSION: return "SHIFT_EXPRESSION";
        case ADDITIVE_EXPRESSION: return "ADDITIVE_EXPRESSION";
        case MULTIPLICATIVE_EXPRESSION: return "MULTIPLICATIVE_EXPRESSION";
        case CAST_EXPRESSION: return "CAST_EXPRESSION";
        case DIRECT_EXPRESSION : return "DIRECT_EXPRESSION";
        case TOKEN_OPENSCOPE: return "TOKEN_OPENSCOPE";
        case TOKEN_CLOSESCOPE: return "TOKEN_CLOSESCOPE";
        case TOKEN_ENDSTATEMENT: return "TOKEN_ENDSTATEMENT";
        case TOKEN_OPENPAREN: return "TOKEN_OPENPAREN";
        case TOKEN_CLOSEPAREN: return "TOKEN_CLOSEPAREN";
        case TOKEN_OPENBRACKET: return "TOKEN_OPENBRACKET";
        case TOKEN_CLOSEBRACKET: return "TOKEN_CLOSEBRACKET";
        case ERROR_SYMBOL: return "ERROR_SYMBOL";
        default: return "UNKNOWN!";
    }
}
