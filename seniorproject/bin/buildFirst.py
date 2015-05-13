### Build First Set
 #  ========================================================================
 #
 #  Build the "FIRST" set according to red-dragon book, pg 189 algorithm
 #  The FIRST set is actually a python dictionary object with the form:
 #      FIRST = { symbol0 : {terminal0, terminal1, ...},
 #                symbol1 : {terminal0, terminal1, ...},
 #                ... }
 #  where the values of the keys are sets (not lists, tuples or hash tables).
 #
 #  The input grammar should come from convertgrammar.py and be in that form.
 #
 #  Last Modified: 3/24/14
 #  Contributor(s): Nicholas Otto
 ##

### Print the FIRST object
 #  -------------------------
 #  Print the FIRST dictionary object
 #
 #  firstobj: The FIRST dictionary object to print
 #
 ##
def printFIRST(firstobj):
    for key in firstobj.keys():
        print "%s, %s" % (key, firstobj[key])

### Assemble FIRST Dictionary
 #  -------------------------
 #  Build the FIRST dictionary object
 #
 #  params: The global parameter class object
 #  grammar: The grammar from which to build the FIRST dictionary
 #
 #  returns: A dictionary containing the FIRST set as defined in the
 #      red-dragon book page 189
 ##
def assembleFirst(params, grammar):
    FIRST = {}
    i = len(grammar) - 1 # loop from back to front to avoid recursion
    while i >= 0:
        N = grammar[i]
        first_set = None

        if N[0] in FIRST.keys():
            first_set = FIRST[N[0]]
        else:
            first_set = set()

        first_set = buildFirst(params, N, first_set, FIRST)

        FIRST[N[0]] = first_set # update the dictionary
        if params.buildFirstDebug():
            print "FIRST dictionary:  %s" % FIRST

        i -= 1

    return FIRST


### Build the FIRST(X) Set
 #  ----------------------
 #  Build the FIRST set for non-terminal 'X'
 #
 #  params: The global parameter class object
 #  prod_list: The production for 'X' (grammar[i] where 
 #      grammar[i][0] = 'X'
 #  first_set: The current FIRST(X) set of terminals
 #  FIRST: The FIRST dictionary object
 #
 #  returns: A set containing FIRST(X) terminals
 ##
def buildFirst(params, prod_list, first_set, FIRST):
    i = 1
    while i < len(prod_list):
        if isTerminal(params, prod_list[i][0] ):
            first_set.add( prod_list[i][0] )
        else:
            j = 0
            while j < len( prod_list[i] ):
                if params.buildFirstDebug():
                    print "prod_list is %s" % prod_list
                other_first = FIRST[prod_list[i][j]]
                if params.buildFirstDebug():
                    print "other_first is %s" % other_first
                first_set = first_set.union( other_first )
                if '/' in other_first:
                    j += 1
                else:
                    break
        i+=1
    return first_set


### Check if Terminal
 #  ----------------------
 #  Check if symbol is a terminal or non-terminal symbol
 #  Currently, terminals begin with '/' and have at least one other
 #      character.  For these purposes, '/' (the empty terminal) is not
 #      considered a terminal character
 #
 #  params: The global parameter class object
 #  symbol: The symbol
 #
 #  returns: 'True' if a non-empty terminal, 'False' otherwise
 ##
def isTerminal(params, symbol):
    if params.buildFirstDebug():
        print "smybol is %s" % symbol
    if len(symbol) >= 2 and symbol[0] == '/':
        return True
    else:
        return False

if __name__ == "__main__":
    pass
