/** File Title
 *  ========================================================================
 *
 *  Overall description of file
 *
 *
 *  Last Modified: 4/14/14
 *  Contributor(s): Nicholas Otto
 */
#include "initializeNOCC.h"

/** Build KW table
 *  --------------
 *  Pre-insert the keywords into the kwtable
 *
 *  Uses NUMKEYWORDS and hashinsert from utility to add entries from 
 *      char *keywords[] into the struct hashentry *kwtable
 */
void initialize_kwtable()
{

    struct identifier *newkw;

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "auto";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "begin";
    newkw->id = KW_JUMPLABEL;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "break";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "case";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "char";
    newkw->id = KW_TYPESPECIFIER;
    //newkw->type_specifier = INTEGRAL;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "const";
    newkw->id = KW_TYPEQUALIFIER;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "continue";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "default";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "do";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "double";
    newkw->id = KW_TYPESPECIFIER;
    //newkw->type_specifier = FLOATING;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "else";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "enum";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "extern";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "float";
    newkw->id = KW_TYPESPECIFIER;
    //newkw->type_specifier = FLOATING;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "for";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "goto";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "if";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "int";
    newkw->id = KW_TYPESPECIFIER;
    //newkw->type_specifier = INTEGRAL;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "long";
    newkw->id = KW_TYPESPECIFIER;
    //newkw->type_specifier = INTEGRAL;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "register";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "return";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "short";
    newkw->id = KW_TYPESPECIFIER;
    //newkw->type_specifier = INTEGRAL;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "signed";
    newkw->id = KW_TYPESPECIFIER;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "sizeof";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "static";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "struct";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "switch";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "typedef";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "union";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "unsigned";
    newkw->id = KW_TYPESPECIFIER;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "void";
    newkw->id = KW_TYPESPECIFIER;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "volatile";
    newkw->id = KW_TYPEQUALIFIER;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "while";
    newkw->id = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "*";
    newkw->id = 0;
    newkw->type.keyword = 1;
    newkw->type.identifier = 0;
    newkw->type.op = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "&";
    newkw->id = 0;
    newkw->type.keyword = 1;
    newkw->type.identifier = 0;
    newkw->type.op = 0;
    hash_insert(kwtable, newkw);

    newkw = malloc(sizeof(struct identifier));
    newkw->lexeme = "=";
    newkw->id = 0;
    newkw->type.keyword = 1;
    newkw->type.identifier = 0;
    newkw->type.op = 0;
    hash_insert(kwtable, newkw);

}

/** Recursively frees ALL entries at/after a hashentry */
void free_hashentry(struct hashentry *entry)
{

    if(entry != NULL){
        struct hashentry *next = entry->nextentry;
        if (next != NULL){
            free_hashentry(next);
        }
        if (entry->data != NULL){
            free(entry->data);
        }
        free(entry);
    }
}

void free_kwtable()
{
    //free all entries in hashentry *kwtable[PRIME]
    int i;
    for (i=0; i<PRIME; i++){
        struct hashentry *tmp = kwtable[i];
        free_hashentry(tmp);
    }

}
void test_kwtable(){
    int i;
    for(i = 0; i < NUMKEYWORDS; i++){
        struct hashentry *temp = hash_retrieve(kwtable, keywords[i]);
        if( temp == NULL ){
            printf("ERROR, not all keywords entered into table!\n");
        }
        else{
            printf("%s keyword found in table.\n", temp->data->lexeme);
        }
    }
}
