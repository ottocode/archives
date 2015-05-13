### Build Follow Set
 #  ========================================================================
 #
 #  Build the "Follow" set according to red-dragon book, pg 189 algorithm
 #  The FOLLOW set is actually a python dictionary object with the form:
 #      FOLLOW = { symbol0 : {terminal0, terminal1, ...},
 #                symbol1 : {terminal0, terminal1, ...},
 #                ... }
 #  where the values of the keys are sets (not lists, tuples or hash tables).
 #
 #  The input grammar should come from convertgrammar.py and be in that form.
 #  The FOLLOW set comes from buildFirst
 #
 #  Last Modified: 3/25/14
 #  Contributor(s): Nicholas Otto
 ##

### Print the FOLLOW object
 #  -------------------------
 #  Print the FOLLOW dictionary object
 #
 #  followobj: The FOLLOW dictionary object to print
 #
 ##
def printFOLLOW(followobj):
    for key in followobj.keys():
        print "%s, %s" % (key, followobj[key])

### Assemble FOLLOW Dictionary
 #  -------------------------
 #  Build the FOLLOW dictionary object
 #
 #  params: The global parameter class object
 #  grammar: The grammar from which to build the FOLLOW dictionary
 #  firstset: The first set created by buildFirst.py
 #
 #  returns: A dictionary containing the FOLLOW set as defined in the
 #      red-dragon book page 189
 ##
def assembleFollow(params, grammar, firstset):
    if params.buildFollowDebug():
        print "\nBuilding FOLLOW dictionary\n"
    FOLLOW = {}
    i = len(grammar) - 1 # loop from back to front to avoid recursion
    while i >= 0:
        N = grammar[i]
        follow_set = None

        if N[0] in FOLLOW.keys():
            follow_set = FOLLOW[N[0]]
        else:
            follow_set = set()

        follow_set = buildFollow(params, N, follow_set, FOLLOW, firstset)

        FOLLOW[N[0]] = follow_set # update the dictionary
        if params.buildFollowDebug():
            print "FOLLOW dictionary:  %s\n" % FOLLOW
        i -= 1

    return FOLLOW


### Build the FOLLOW(X) Set
 #  ----------------------
 #  Build the FOLLOW set for non-terminal 'X'
 #
 #  params: The global parameter class object
 #  prod_list: The production for 'X' (grammar[i] where 
 #      grammar[i][0] = 'X'
 #  follow_set: The current FOLLOW(X) set of terminals
 #  FOLLOW: The FOLLOW dictionary object
 #  firstset: The first set created by buildFirst.py
 #
 #  returns: A set containing FOLLOW(X) terminals
 ##
def buildFollow(params, prod_list, follow_set, FOLLOW, firstset):
    i = 1
    emptyset = set(['/'])
    while i < len(prod_list):
        if len(prod_list[i]) < 2:   # only one symbol
            if params.buildFollowDebug():
                print "one symbol for production %s -> %s" % (prod_list[0], prod_list[i])
        else:
            if params.buildFollowDebug():
                print "updating a Follow set"
            # rule 2
            j = len(prod_list[i]) - 1   # loop backwards through the productions
            while j > 0:
                if isTerminal(params, prod_list[i][j]):
                    pass
            # rule 3
        i += 1
    return follow_set


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
