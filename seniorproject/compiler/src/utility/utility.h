#ifndef UTILITY_H
#define UTILITY_H

#include "structures.h"
#include <stdio.h>

/** Free token AND token->lexeme
 */
void free_token(struct token *t);

/* Hash function from pg 436 red dragon book
 */
int hashpjw( char *s);

/** Insert into hash table
 *  ----------------------
 *  Insert data into a the hashtable provided
 *
 *  table: pointer to the first entry in the hashtable (index 0)
 *  data: pointer to the data to insert
 *
 *  returns:    the pointer to the new hashentry if successful, 
 *              (void *)1 if data->lexeme already in table (does not overwrite)
 *              NULL otherwise
 */
struct hashentry * hash_insert(struct hashentry **table, struct identifier *data);

/** Retrieve entry from hash table
 *  ------------------------------
 *  Looks for data which matches the lexeme
 *
 *  table: pointer to the first entry in the hashtable (index 0)
 *  lexeme: the character string specifying the token
 *
 *  returns: pointer to hashentry if found, null otherwise
 */
struct hashentry * hash_retrieve(struct hashentry **table, char *lexeme);

extern char* keywords[32];
extern struct hashentry *kwtable[PRIME];
extern struct hashentry *symboltable[PRIME];

/** Convert Enum To String
 *  -----------
 *  For debuggin purposes.
 *
 *  state: the state of the scanner
 *
 *  returns: "state" 
 */
const char* getEnumName(enum STATES state);

/** Convert Stack Symbol To String
 *  ------------------------------
 *  For debuggin purposes.
 *
 *  symbol: the stack symbol
 *
 *  returns: "symbol" 
 */
const char* getStackSymbolName(enum SYMBOLS symbol);
#endif
