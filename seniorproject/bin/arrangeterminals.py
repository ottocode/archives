### Arrange terminals of grammar
 #  ========================================================================
 #
 #  Convert my text-representation of the grammer into a data-structure that
 #      can be used in a program
 #
 #  The format will be:
 #      G = [[symbol0, [p0], [p1], [p2]],
 #           [symbol1, [p0], [p1], [p2]],
 #           ...]
 #
 #
 #  Last Modified: 3/19/14
 #  Contributor(s): Nicholas Otto
 ##

### Create Production
 #  -----------------
 #  From a string, create a production for a symbol.
 #  Productions are represented as [symbol0, symbol1, ...]
 #  Terminals are symbols, but represented as 'terminal'
 #
 #  params: a class containing the global parameters
 #  line: the line containing the production
 #
 #  returns: A list containing the production
 ##
def createProduction(params, line):
    if params.debug():
        print "Inside createProduction"
    
    production = line.split()
    if params.debug():
        print "string split is:" + str(production)
    for i in range(0, len(production)):
        if production[i][0] == '/':
            pass#production[i] = production[i][1:]
    return production


### Create Grammar Line
 #  -------------------
 #  Build an entry in the grammar.
 #  Entries are of the form:
 #      [symbol, [production0], [production1], ...]
 #
 #  params: a class containing the global parameters
 #  filep: a pointer to a file object to read in the grammar line
 #
 #  returns: A list containing a grammar entry,
 #          None if no more entries can be read or error.
 ##
def createGrammarLine(params, filep):
    if params.debug():
        print "Inside createGrammarLine"
    newRule = []
    line = filep.readline().strip()

    if len(line) > 0:
        newRule.append(line)  #add symbol
        line = filep.readline().strip()
        while len(line) > 0:  #stop when finished with all productions
            nextProd = createProduction(params, line)
            newRule.append(nextProd) #add production
            line = filep.readline().strip()
        return newRule

### Arrange Terminals
 #  -----------------
 #  Arrange the terminals of a grammar from text file
 #  Terminals in text file are formatted the following way:
 # symbol0
 #      symbol symbol
 #      symbol
 #      /terminal
 #
 #      where the first '/' is not significant when determining a terminal
 #  All terminals and symbols extend from the first character (except the '/' in
 #      the case of terminals) to the first whitespace
 #
 #  params: a class containing the global parameters
 #  filep: The file pointer to the text file containing the grammar in text form
 #
 #  returns: The grammar in the form:
 #      G = [[symbol0, [p0], [p1], [p2]],
 #           [symbol1, [p0], [p1], [p2]],
 #           ...]
 ##
def arrangeTerminals(params, filep):
    if params.debug():
        print "Inside arrange terminals"

    grammar = []
    newRule = createGrammarLine(params, filep)
    while newRule:
        if params.verbose():
            print "Adding rule:"
            print "\t"  + str(newRule)
        grammar.append(newRule)
        newRule = createGrammarLine(params, filep)

    return grammar


if __name__ == "__main__":
    print "Testing arrangeterminals"


### Function Title 
 #  --------------
 #  Description of function
 #
 #  parameter1: description of parameter
 #
 #  returns: what it returns
 ##


