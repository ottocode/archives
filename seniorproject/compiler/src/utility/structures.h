#ifndef STRUCTURES_H
#define STRUCTURES_H

#define Symbol int
#define PRIME 65599
#define NUMKEYWORDS 32
#define NOTIMPLEMENTED -1

/* Macros to make setting the bitfields for identifiers more natural */
#define type_id(A) A.identifier = 1; A.keyword = 0; A.op = 0; A.constant = 0; A.begin = 0; A.cast = 0; A.goto_op = 0;
#define type_kw(A) A.identifier = 0; A.keyword = 1; A.op = 0; A.constant = 0; A.begin = 0; A.cast = 0; A.goto_op = 0;
#define type_op(A) A.identifier = 0; A.keyword = 0; A.op = 1; A.constant = 0; A.begin = 0; A.cast = 0; A.goto_op = 0;
#define type_const(A) A.identifier = 0; A.keyword = 0; A.op = 0; A.constant = 1; A.begin = 0; A.cast = 0; A.goto_op = 0;
#define type_begin(A) A.identifier = 0; A.keyword = 0; A.op = 0; A.constant = 0; A.begin = 1; A.cast = 0; A.goto_op = 0;
#define type_cast(A) A.identifier = 0; A.keyword = 0; A.op = 0; A.constant = 0; A.begin = 0; A.cast = 1; A.goto_op = 0;
#define type_goto(A) A.identifier = 0; A.keyword = 0; A.op = 0; A.constant = 0; A.begin = 0; A.cast = 0; A.goto_op = 1;

enum {IINTEGRAL = 1, FLOATING};

enum SYMBOLS{COMPOUND_STATEMENT=1, DECLARATION_LIST, DECLARATION,
    DECLARATION_SPECIFIERS, TYPE_QUALIFIER, TYPE_SPECIFIER,
    POINTER_QUALIFIER, TYPEDEF_NAME,
    DEFINE_ARRAY,
    STATEMENT_LIST, STATEMENT,
    LABELED_STATEMENT, JUMP_STATEMENT, EXPRESSION_STATEMENT,
    EXPRESSION, ASSIGNMENT_EXPRESSION,
    LVALUE, ASSIGNMENT_OPERATOR, RVALUE, LRVALUE, BINARY_OP,
    REFERENCE_OPERATOR, POSTFIX_EXPRESSION, LPOSTFIX_EXPRESSION,
    PRIMARY_EXPRESSION_LIST, PRIMARY_EXPRESSION, PRIMARY_EXPRESSION_MODS,
    LOGICAL_OR_EXPRESSION, LOGICAL_AND_EXPRESSION,
    INCLUSIVE_OR_EXPRESSION, EXCLUSIVE_OR_EXPRESSION, AND_EXPRESSION,
    EQUALITY_EXPRESSION, RELATIONAL_EXPRESSION, SHIFT_EXPRESSION,
    ADDITIVE_EXPRESSION, MULTIPLICATIVE_EXPRESSION,
    CAST_EXPRESSION, DIRECT_EXPRESSION, 
    TOKEN_OPENSCOPE, TOKEN_CLOSESCOPE,
    TOKEN_ENDSTATEMENT,
    TOKEN_OPENPAREN, TOKEN_CLOSEPAREN,
    TOKEN_OPENBRACKET, TOKEN_CLOSEBRACKET,
    ERROR_SYMBOL};


enum KWCLASS{KW_TYPEQUALIFIER=1, KW_TYPESPECIFIER,
            KW_REFERENCEOPERATOR, KW_PRIMARYEXPRESSION,
            KW_JUMPLABEL};

enum  STATES{EMPTY, ID_KW, 
            C_NUM, C_NUMU, C_NUML, C_NUMUL, 
            C_HEX0, C_HEX1, 
            C_DF, C_FE, C_FS, C_FED, C_FF, C_FL, C_F,
            C_CO, C_CE, C_CD, C_CC,
            S_O, S_E, S_D, S_C,
            OP, OP1, OP2};

enum OPERATORS{OPENPAREN, CLOSEPAREN,       // (  )
            OPENBRACKET, CLOSEBRACKET,      // [  ]
            DEREFERENCEVALUEAT, VALUEAT,    // ->  .
            BANG, FLIP,                     // ! ~
            INCREMENT, DECREMENT,            // ++ --
            POSITIVE, NEGATIVE,             // + -
            STAR, AND,                      // * &
            SIZE,                           // sizeof
            MULTIPLY, DIVIDE, MODULO,       // * / %
            PLUS, MINUS,                    // + -
            SHIFTLEFT, SHIFTRIGHT,          // << >>
            LT, LE, GT, GE,                 // < <= > >=
            EQUALS, NOTEQUALS,              // == !=
            BWAND, BWXOR, BWOR,             // & ^ |
            LOGAND, LOGOR,                  // && ||
            TERNQ, TERNC,                   // ? :
            ASSIGN, PASSIGN, SASSIGN,       // = += -=
            MASSIGN, DASSIGN, MODASSIGN,    // *= /= %=
            AASSIGN, XASSIGN, OASSIGN,      // &= ^= |=
            SLASSIGN, SRASSIGN,             // <<= >>=
            COMMA,                          // ,
            OPENSCOPE, CLOSESCOPE, EOE      // { } ;
};


/* token structure representing a token of input
 */
struct token{
    int type;       //token type (keyword, identifier, constant, stringliteral, etc)
    int op_type;

    int file_num;   //the file where token is found
    long line_num;  //the line number where token occurrs
    unsigned int lexeme_length;  //the length of lexeme
    

    char *lexeme;    //the actual token
};

/** Data held by the nodes of the parse tree.
 *
 */
struct node_attributes{
    int data;
};

/** Parse tree node structure.
 *
 */
struct tree_node {
    struct tree_node *parent;
    struct tree_node *first_child;
    struct tree_node *last_child;
    struct tree_node *right_sibling;

    struct node_attributes *data;   //TODO see if can be removed
    int node_type;

    struct {
        struct identifier *x;
        struct identifier *eq;
        struct identifier *a;
        struct identifier *op;
        struct identifier *b;
    } attributes;

};

/** Parsing Stack data-structure
 * 
 */
struct stack_item {
    int symbol;
    struct tree_node *tree_pos;
    struct stack_item *next_stack_item;
};

/** Input queue structure idea
 * 
 */
struct input_item {
    struct token *Token;
    struct input_item *next_input;
};

/** Identifier token
 *  Kewords have id < 100, otherwise id > 100
 */
struct identifier {
    long id;
    
    struct {
        unsigned int keyword : 1;
        unsigned int identifier : 1;
        unsigned int  op : 1;
        unsigned int  constant : 1;
        unsigned int  begin : 1;
        unsigned int  cast : 1;
        unsigned int  goto_op : 1;
    }type;
    int op_type; //from enum OPERATORS
    int kw_name; //from enum //TODO

    char pointer;       //0 for non-pointers
    char type_specifier; // int, float, etc
    char type_qualifier; // not implemented

    struct identifier *offset;
    unsigned long offset_length;
    

    char *lexeme;
};
    

/** Hash entry for symbol table
 *  Not a generalized hash table
 */
struct hashentry{
    struct identifier *data;
    struct hashentry *nextentry;
};

#endif
