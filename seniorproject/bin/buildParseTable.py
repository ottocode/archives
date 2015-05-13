### Build the Parse Table
 #  ========================================================================
 #
 #  Builds the parse table for a grammar.
 #  Parse table will be of the form:
 #      TODO: TBD
 #
 #  Glues together the pieces from convertgrammar.py, arrangeterminals,py,
 #      buildFirst.py, and buildFollow.py
 #
 #  Requires:   convertgrammar.py
 #              buildFirst.py
 #              buildFollow.py
 #              structures.py
 #
 #  Last Modified: 3/24/14
 #  Contributor(s): Nicholas Otto
 ##

from convertgrammar import convertGrammar, printGrammar
from buildFirst import assembleFirst, printFIRST
from buildFollow import assembleFollow, printFOLLOW
from structures import globalParams
import sys

### Build Parse Table
 #  -----------------
 #  Build the parse table for a grammar
 #
 #  parameter1: description of parameter
 #
 #  returns: what it returns
 ##

if __name__ == "__main__":

    grammarfile = sys.argv[1]

    
    globalP = globalParams(DEBUG=False, VERBOSE=False, BUILDFIRSTDB=False, BUILDFOLLOWDB=True)

    grammar = convertGrammar(grammarfile, globalP)
    printGrammar(grammar)

    firstobj = assembleFirst(globalP, grammar)
    printFIRST(firstobj)

    assembleFollow(globalP, grammar, firstobj)
