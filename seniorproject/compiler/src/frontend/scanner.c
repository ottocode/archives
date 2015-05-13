/** Scanner Module
 *  ========================================================================
 *
 *  The scanner is responsible for reading in characters from a file and 
 *      returning tokens.
 *
 *  Last Modified: 2/25/14
 *  Contributor(s): Nicholas Otto
 */
#include "scanner.h"
#include <string.h>

#define SCANBUFMIN 64
#define HALFBUF SCANBUFMIN/2
#define incr(c)  {c++; if((c-buf) > SCANBUFMIN) c = buf; }

#define ischar(c) ( (c>='a' && c <= 'z') || (c>='A' && c<='Z') || (c=='_'))
#define isdigit(c) ( (c >= '0' && c <= '9') ) 
#define ishexdigit(c) ( isdigit(c) ||  (c>='a' && c <= 'f') || (c>='A' && c<='F') )
#define isalphanum(c) ( ischar(c) || isdigit(c) )
#define isspace(c) ( (c == ' ') || (c == '\t') )
#define ischaracter(c) ( (c >= 10) && (c <= 126))  //TODO fix

FILE *file_p;

char *lb, *fp, *le; //lexeme beginning, forward pointer, lexeme end
char *buf;          //pointer to character buf reading from source file
long file_length;
long char_seen;     //number of characters seen by scanner
char prev_op;   //keeps track of previous operator seen (things like >>=)
char lowersafe;
char uppersafe;




/** Initialize Scanner Variables
 *  ----------------------------
 *  Initialize the variables lb, fp, le and buf.
 *      If length of file < SCANBUFMIN, initialize for entire filelength
 *      Assumes file_p has just been initialized
 *
 *  returns: 0 on success, 1 on failure
 */
long init_scanner()
{
    long firstread = 0;             //character read in first read
    fseek(file_p, 0, SEEK_END);
    file_length = ftell(file_p);
    char_seen = 0;
    rewind(file_p);

    
    buf = malloc(SCANBUFMIN);

    if(buf == NULL){
        return 4;
    }
    
    firstread = fread(buf, 1, HALFBUF, file_p);
    lb = fp = le = buf;
    uppersafe = 1;
    lowersafe = 1;

    return firstread;

}

/** Is Character a C Operator
 *  -------------------------
 *  C operators are scattered throughout ASCII table, no simple check
 *
 *  c: the character in question
 *
 *  returns: 1 if character is an operator
 *          0 if charcter is not an operator
 */
int isoperator(char c)
{
    switch(c){
        case '(':  case ')':  case '{':  case '}':  case '[':  case ']': 
        case '>':  case '<':  case '.':  case '!':  case '+':  case '-': 
        case '*':  case '/':  case '%':  case '^':  case '~':  case '&': 
        case '|':  case ',':  case ';': case '?':   case ':':  case '=':
            return 1;
        default: return 0;
    }
}

/** Check if Part of Operator Chain 
 *  -------------------------------
 *  Some operators can go for up to 3 characters, check if next operator part of
 *      such a chain
 *
 *  c: the character in question
 *
 *  returns: 1 chain can be continued with c
 *          0 otherwise
 */
int chainop(char c)
{
    if( (isoperator(c) == 0) ){ return 0;}  //first make sure it is an operator
    switch(prev_op){
        case '(': case ')': case '[': case ']': case '{': case '}': 
        case ';': case '~': case '.': case '?': case ':': case ',':
            return 0;       //these never chain
            break;
        default:
            break;
    }
    if (c=='='){ return 1;}
    
    switch(prev_op){
        case '+':
            if (c=='+'){ return 1;} break;
        case '-':
            if (c=='-'){ return 1;}
            else if (c=='>'){ return 1;}    break;
        case '<':
            if (c=='<'){ return 1;} break;
        case '>':
            if (c=='>'){ return 1;} break;
        case '&':
            if (c=='&'){ return 1;} break;
        case '|':
            if (c=='|'){ return 1;} break;
        default: 
            return 0;   break;
    }
    return 0;
}
 

/** Determine specific operator type
 *  --------------------------------
 *  Using the token lexeme, determine exate operator type
 *
 *  token: The token object with the lexeme
 *  
 *  returns: the ENUM value for the operator.  Some operators like plus and
 *      and positive will not be precise
 */
int match_operator_type(struct token *Token)
{
    if( strcmp(Token->lexeme, "(") == 0 ){
        return OPENPAREN;
    }
    else if( strcmp(Token->lexeme, ")") == 0 ){
        return CLOSEPAREN;
    }
    else if( strcmp(Token->lexeme, "[") == 0 ){
        return OPENBRACKET;
    }
    else if( strcmp(Token->lexeme, "]") == 0 ){
        return CLOSEBRACKET;
    }
    else if( strcmp(Token->lexeme, "->") == 0 ){
        return DEREFERENCEVALUEAT;
    }
    else if( strcmp(Token->lexeme, ".") == 0 ){
        return VALUEAT;
    }
    else if( strcmp(Token->lexeme, "!") == 0 ){
        return BANG;
    }
    else if( strcmp(Token->lexeme, "~") == 0 ){
        return FLIP;
    }
    else if( strcmp(Token->lexeme, "++") == 0 ){
        return INCREMENT;
    }
    else if( strcmp(Token->lexeme, "--") == 0 ){
        return DECREMENT;
    }
    else if( strcmp(Token->lexeme, "+") == 0 ){
        return PLUS;
    }
    else if( strcmp(Token->lexeme, "-") == 0 ){
        return MINUS;
    }
    else if( strcmp(Token->lexeme, "*") == 0 ){
        return STAR;
    }
    else if( strcmp(Token->lexeme, "&") == 0 ){
        return AND;
    }
    else if( strcmp(Token->lexeme, "sizeof") == 0 ){
        return SIZE;
    }
    else if( strcmp(Token->lexeme, "/") == 0 ){
        return DIVIDE;
    }
    else if( strcmp(Token->lexeme, "%") == 0 ){
        return MODULO;
    }
    else if( strcmp(Token->lexeme, "<<") == 0 ){
        return SHIFTLEFT;
    }
    else if( strcmp(Token->lexeme, ">>") == 0 ){
        return SHIFTRIGHT;
    }
    else if( strcmp(Token->lexeme, "<") == 0 ){
        return LT;
    }
    else if( strcmp(Token->lexeme, ">") == 0 ){
        return GT;
    }
    else if( strcmp(Token->lexeme, "<=") == 0 ){
        return LE;
    }
    else if( strcmp(Token->lexeme, ">=") == 0 ){
        return GE;
    }
    else if( strcmp(Token->lexeme, "==") == 0 ){
        return EQUALS;
    }
    else if( strcmp(Token->lexeme, "!=") == 0 ){
        return NOTEQUALS;
    }
    else if( strcmp(Token->lexeme, "^") == 0 ){
        return BWXOR;
    }
    else if( strcmp(Token->lexeme, "&&") == 0 ){
        return LOGAND;
    }
    else if( strcmp(Token->lexeme, "||") == 0 ){
        return LOGOR;
    }
    else if( strcmp(Token->lexeme, "?") == 0 ){
        return TERNQ;
    }
    else if( strcmp(Token->lexeme, ":") == 0 ){
        return TERNC;
    }
    else if( strcmp(Token->lexeme, "=") == 0 ){
        return ASSIGN;
    }
    else if( strcmp(Token->lexeme, "+=") == 0 ){
        return PASSIGN;
    }
    else if( strcmp(Token->lexeme, "-=") == 0 ){
        return SASSIGN;
    }
    else if( strcmp(Token->lexeme, "*=") == 0 ){
        return MASSIGN;
    }
    else if( strcmp(Token->lexeme, "/=") == 0 ){
        return DASSIGN;
    }
    else if( strcmp(Token->lexeme, "%=") == 0 ){
        return MODASSIGN;
    }
    else if( strcmp(Token->lexeme, "&=") == 0 ){
        return AASSIGN;
    }
    else if( strcmp(Token->lexeme, "^=") == 0 ){
        return XASSIGN;
    }
    else if( strcmp(Token->lexeme, "|=") == 0 ){
        return OASSIGN;
    }
    else if( strcmp(Token->lexeme, "<<=") == 0 ){
        return SLASSIGN;
    }
    else if( strcmp(Token->lexeme, ">>=") == 0 ){
        return SRASSIGN;
    }
    else if( strcmp(Token->lexeme, ",") == 0 ){
        return COMMA;
    }
    else if( strcmp(Token->lexeme, "{") == 0 ){
        return OPENSCOPE;
    }
    else if( strcmp(Token->lexeme, "}") == 0 ){
        return CLOSESCOPE;
    }
    else if( strcmp(Token->lexeme, ";") == 0 ){
        return EOE;
    }
    else
        return 99;
}

/** Update the State of Scanner
 *  ----------------------------
 *  Based on current state, update scanner state depending on character just read
 *
 *  currstate: the current state of the scanner
 *  c: the character just read
 *
 *  returns: 0 if new sate has path to accept state
 *          1 if new state is accepting
 *          -1 if new state is unrecognized
 */
int update_scanner_state(unsigned int *currstate, char c)
{
    int retval = -1;
    switch(*currstate){
        case EMPTY:                         //never seen char
            if( ischar(c) ){                //found character
                *currstate = ID_KW; retval = 1;
            }
            else if( isdigit(c) ){       //digit
                *currstate = C_NUM; retval = 1;
            }
            else if( c == '\'') {*currstate = C_CO; retval = 0;}
            else if( c == '\"') {*currstate = S_O; retval = 0;}
            else if( isoperator(c) ) {*currstate = OP; prev_op = c; retval = 1;}
            else{ /*TODO*/ }
            break;
        case ID_KW:                         //id or keyword
            if( isalphanum(c) ){ retval = 1;}
            else{ retval = -1; }
            break;
        case C_NUM:                         //numerical constant
            if( isdigit(c) ){
                retval = 1;                 //don't chage state
            }
            else if( (c == 'x') || (c == 'X') ){
                *currstate = C_HEX0; retval = 0;
            }
            else if( (c == 'u') || (c == 'U') ){
                *currstate = C_NUMU; retval = 1;
            }
            else if( (c == 'l') || (c == 'L') ){
                *currstate = C_NUML; retval = 1;
            }
            else if( (c == '.') ){
                *currstate = C_DF; retval = 0;
            }
            else{ retval = -1; }
            break;
        case C_NUMU: //unsigned integer
            if( (c == 'l') || (c == 'L') ){
                *currstate = C_NUMUL; retval = 1;  //change to long
            }
            else{ retval = -1; }    //anything else is a no
            break;
        case C_NUML: case C_NUMUL:  //long  or unsigned long integer
            retval = -1;            //doesn't matter what you get
            break;
        case C_HEX0: case C_HEX1:   //hex constant 0x
            if( ishexdigit(c) ){
                *currstate = C_HEX1; retval = 1;
            }
            else{ retval = -1;}
            break;
        case C_DF:                          //decimal or float
            if( isdigit(c) ){
                *currstate = C_F; retval = 1;
            }
            else if( (c == 'e') || (c == 'E')){  //exponent stuff coming
                *currstate = C_FE; retval = 0;
            }
            else if( (c == 'f') || (c == 'F')){  //single precision
                *currstate = C_FF; retval = 1;
            }
            else if( (c == 'l') || (c == 'L')){  //double precision
                *currstate = C_FL; retval = 1;
            }
            else{ retval = -1; }
            break;
        case C_FE:
            if( isdigit(c) ){
                *currstate = C_FED; retval = 1;
            }
            else if( (c == '+') || (c == '-')){
                *currstate = C_FS; retval = 0;
            }
            else{ retval = -1;}
            break;
        case C_FS:
            if( isdigit(c) ){
                *currstate = C_FED; retval = 1;
            }
            else{ retval = -1;}
            break;
        case C_FED:
            if( isdigit(c)){
                retval = 1;
            }
            else if( (c == 'f') || (c == 'F')){  //single precision
                *currstate = C_FF; retval = 1;
            }
            else if( (c == 'l') || (c == 'L')){  //double precision
                *currstate = C_FL; retval = 1;
            }
            else{ retval = -1;}
            break;
        case C_FF: case C_FL:
            retval = -1;        //end of valid input
            break;
        case C_F:                           //float
            if( isdigit(c) ){
                retval = 1;
            }
            else if( (c == 'e') || (c == 'E')){  //exponent stuff coming
                *currstate = C_FE; retval = 0;
            }
            else if( (c == 'f') || (c == 'F')){  //single precision
                *currstate = C_FF; retval = 1;
            }
            else if( (c == 'l') || (c == 'L')){  //double precision
                *currstate = C_FL; retval = 1;
            }
            else{ retval = -1;}
            break;
        case C_CO: 
            if( (c == '\\')) {*currstate = C_CE; retval = 0;}
            else if( ischaracter(c) ){ *currstate = C_CD; retval = 0;}
            else{ retval = -1;}
            break;
        case C_CE:
            if( ischaracter(c) ){*currstate = C_CD; retval = 0;}
            else{ retval = -1;}
            break;
        case C_CD: 
            if( (c == '\'') ){*currstate = C_CC; retval = 1;}
            else{ retval = -1;}
            break;
        case C_CC:
            retval = -1;
            break;
        case S_O: 
            if( (c == '\\')) {*currstate = S_E; retval = 0;}
            else if( ischaracter(c) ){ *currstate = S_D; retval = 0;}
            else if( (c == '\"') ) {*currstate = S_C; retval = 1;}
            else{ retval = -1;}
            break;
        case S_E:
            if( ischaracter(c) ){*currstate = S_D; retval = 0;}
            else{ retval = -1;}
            break;
        case S_D: 
            if( (c == '\"') ){*currstate = S_C; retval = 1;}
            else if( (c == '\\')) {*currstate = S_E; retval = 0;}
            else if( ischaracter(c) ){ *currstate = S_D; retval = 0;}
            else{ retval = -1;}
            break;
        case S_C:
            retval = -1; break;
        case OP:
            if( chainop(c) ){ *currstate = OP1; prev_op = c; retval = 1;}
            else{ prev_op = 0; retval = -1;}
            break;
        case OP1:
            if( ((prev_op == '<') || (prev_op == '>') ) && (c == '=') ){  //only viable options
                *currstate = OP2; prev_op = c; retval = 1;}
            else{ prev_op = 0; retval = -1;}
            break;
        case OP2:
            prev_op = 0; retval = -1; break;
        default:
            *currstate = -1; retval = -1;
            break;
    }

    return retval;
}

/** Create Token
 *  ----------------------------
 *  Create the next token using buf and lexeme pointers
 *      Caller is responsible for freeing token->lexeme and token
 *
 *  final_accept: the final accepting state of the scanner
 *
 *  returns: pointer to new token if one can be created
 *          1 if new state is accepting
 *          -1 if new state is unrecognized
 */
struct token * create_token(int final_accept)
{
    long i = 0;
    struct token *newtoken;
    unsigned int lexeme_length;
    long start;
    
    if(final_accept == 0){
        return NULL;
    }

    /* create a new token */
    newtoken = malloc(sizeof(struct token));

    if(lb < le){
        lexeme_length = le-lb;
    }
    else{
        lexeme_length = (buf+SCANBUFMIN - lb) + (le-buf);
    }
    newtoken->lexeme_length = lexeme_length;

    /*add the lexeme itself */
    newtoken->lexeme = malloc(sizeof(char) * (lexeme_length + 1));


    start = lb-buf;
    for(; i < lexeme_length; i++){
        (newtoken->lexeme)[i] = buf[(start + i) % SCANBUFMIN];
    }
    (newtoken->lexeme)[i] = '\0';

    /* if operator, be more specific about the type */
    if((final_accept == OP) || (final_accept == OP1) || (final_accept == OP2)){
        newtoken->op_type = match_operator_type(newtoken);
    }
    else{
        newtoken->op_type = -1;
    }
    newtoken->type = final_accept;

    char_seen += lexeme_length;

    return newtoken;
}


/** Open a File
 *  -----------
 *  Opens a file and assigns pointer to file_p.
 *      If file_p points to a value other than NULL, a 2 is returned.
 *      Thus, it is up to the caller to ensure that all previously opened
 *      files have been closed
 *
 *  filename: the name of file to open
 *  args: the file attributes with which to open
 *
 *  returns: 0 if file successfully opened, 1 otherwise.
 */
int open_file(const char *filename, const char *args)
{
    int retval = 0;

    if(file_p != NULL){ // ensure filepointer started as null
        return 1;
    }

    file_p = fopen(filename, args);

    if(file_p == NULL){
        return 2;
    }

    if( (retval = init_scanner()) ){
        return retval;
    }

    return 0;
}


/** Close a File
 *  ------------
 *  Closes the file pointed to by file_p.
 *      Assignes file_p to NULL.
 *      It is not an error to call close_file if file_p is already NULL
 *      Resets buf, lb, and fp
 *
 *  returns: 0 on success, >0 on error
 */
int close_file()
{
    int retval = 0;
    if(file_p == NULL){}
    else{
        retval = fclose(file_p);
        free(buf);
        lb = NULL; fp = NULL; le = NULL;
    }

    file_p = NULL;
    return retval;
}


/** Get Remaining Characters
 *  ------------------------
 *  Determines the number of characters remaining after lb (lexeme beginning)
 *
 *  returns: number of characters remaining.
 *              If no file is currently opened, then 0 is returned.
 */
unsigned long remaining_characters()
{

    if(file_p == NULL){
        return 0;
    }

    return file_length - ftell(file_p);
}


/** Get Next Token
 *  --------------
 *  Get the next token in the file
 *
 *  returns: a pointer to a token structure corresponding to next character sequence in file.
 *              If no file is currently opened, then NULL is returned.
 *              If token cannot be parsed, then (void *)1 is returned.
 *              If end of file reached, (void *)2 is returned.
 */
struct token *get_next_token()
{
    struct token *nexttoken;    // crafting this token
    unsigned int state, final_state = 0;        // state of scanner
    char *c;                    // character to read
    int updatecheck;            // determines if le should be updated, or found token
    char *oldlb;

    nexttoken = NULL;
    state = EMPTY;

    //printf("Getting next token\n"); //DEBUG
    //printf("lb = %p, fp = %p, buf = %p\n",lb, fp, buf);   //DEBUG

    if(fp == NULL){
        return NULL;
    }

    while(nexttoken == NULL){
        //check if fp close to halfbuf
        if( fp == buf + HALFBUF ){
            if( (lb <= (buf + HALFBUF)) ){
                //buf ... lb...fp..HALFBUF ==== read more in upper half
                if(uppersafe){
                    //printf("filling upper half\n");//DEBUG
                    uppersafe = 0;
                    fread(buf+HALFBUF, 1, HALFBUF, file_p);
                }
                else{}
            }
            else{
                //buf .....fp..HALFBUF...lb ==== buffer not big enough
                //error case
                printf("\nUnhandled error case, scanner.c: get_next_token 1\n");
                printf("buf: %p, bufmax: %p, lb: %p, fp: %p\n", buf, buf+SCANBUFMIN, lb, fp); //DEBUG
                return NULL;
            }
        }
        //check if fp close to scanbufmin
        if( fp == buf + SCANBUFMIN ){
            if( (lb > (buf + HALFBUF)) ){
                //buf ... HALFBUF.. lb...fp...SCANBUFMIN ==== read more in lower half
                if(lowersafe){
                    //printf("filling lower half\n");//DEBUG
                    lowersafe = 0;
                    fread(buf, 1, HALFBUF, file_p);
                    fp = buf;
                }
                else{}
            }
            else{
                //buf .....lb..HALFBUF...fp ==== buffer not big enough
                //error case
                printf("\nUnhandled error case, scanner.c: get_next_token 2\n");
                printf("buf: %p, bufmax: %p, lb: %p, fp: %p\n", buf, buf+SCANBUFMIN, lb, fp); //DEBUG
                return NULL;
            }
        }
        
        /* DEBUG
        printf("char_seen: %ld\n", char_seen);
        sleep(1);
        */

        //TODO reached end of file
        if(char_seen == file_length){
            return (void *)2;
            break; //last char should be EOF, not part of lexeme
        }

        c = fp;
        //printf("Character: %c\n", *c); //DEBUG
        updatecheck = update_scanner_state(&state, *c);

        if(updatecheck == 1){
            //found longer accept state, need to update lexeme end (le)
            final_state = state;
            incr(fp);       //safe to update forward pointer
            le = fp;    //update lexeme end
        }
        else if( updatecheck == 0){
            //still in unaccepting state, but hope remains
            incr(fp);       //don't update lexeme end
        }
        else if( updatecheck == -1){
            //in fail state, need to rewind if possible
            nexttoken = create_token(final_state);   //create the token
            state = EMPTY;

            if(lb == le){ //skip character c (either space or unrecognized)
                //printf("lb = '%c'\n", *lb);//DEBUG
                oldlb = lb;
                incr(lb); incr(le); char_seen++;
                fp = lb;
                if( (oldlb <= buf+HALFBUF) && (lb > buf+HALFBUF)){
                    uppersafe = 1;
                }
                else if( (oldlb > lb)){
                    lowersafe = 1;
                }
            }
            else{
                //update pointers to lexeme end
                oldlb = lb;
                lb = le;
                fp = lb;
                if( (oldlb <= buf+HALFBUF) && (lb > buf+HALFBUF)){
                    uppersafe = 1;
                }
                else if( (oldlb > lb)){
                    lowersafe = 1;
                }
            }
        }
        
    }

    return nexttoken;
}


