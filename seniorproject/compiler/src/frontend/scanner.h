/** Scanner Module Header File
 *  ========================================================================
 *
 *  The scanner is responsible for reading in characters from a file and 
 *      returning tokens.
 *
 *  Last Modified: 2/25/14
 *  Contributor(s): Nicholas Otto
 */
#ifndef SCANNER_H
#define SCANNER_H

#include <stdlib.h>
#include <stdio.h>
#include "../utility/structures.h"

/** Open a File
 *  -----------
 *  Opens a file and assigns pointer to file_p.
 *      If file_p points to a value other than NULL, a 2 is returned.
 *      Thus, it is up to the caller to ensure that all previously opened
 *      files have been closed
 *
 *  filename:  the name of file to open
 *  args:  the file attributes with which to open
 *
 *  returns:  0 if file successfully opened, 1 otherwise.
 */
int open_file(const char *filename, const char *args);

/** Close a File
 *  ------------
 *  Closes the file pointed to by file_p.
 *      Assignes file_p to NULL.
 *      It is not an error to call close_file if file_p is already NULL
 *
 *  returns:  0 on success, 1 on error
 */
int close_file();

/** Get Remaining Characters
 *  ------------------------
 *  Determines the number of characters remaining after lb (lexeme beginning)
 *
 *  returns:  number of characters remaining.
 *              If no file is currently opened, then 0 is returned.
 */
unsigned long remaining_characters();

/** Get Next Token
 *  --------------
 *  Get the next token in the file
 *
 *  returns:  a pointer to a token structure corresponding to next character sequence in file.
 *              If no file is currently opened, then NULL is returned.
 *              If token cannot be parsed, then (void *)1 is returned.
 *              If end of file reached, (void *)2 is returned.
 */
struct token *get_next_token();

#endif
