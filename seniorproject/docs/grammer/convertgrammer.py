### Convert Grammer
 #  ========================================================================
 #
 #  Convert the grammer specified by K&R into a usable python-y version
 #      with all left-recursion eliminated.
 #  The resulting form will be:
 #      G = [[symbol0, [p0], [p1], [p2]],
 #           [symbol1, [p0], [p1], [p2]],
 #           ...]
 #
 #  Requires: arrangeterminals.py
 #
 #  Last Modified: 3/19/14
 #  Contributor(s): Nicholas Otto
 ##

from arrangeterminals import arrangeTerminals
from copy import deepcopy

##### Class Definitions #####

### Global Parameter Structure
 #  ==========================
 #
 #  Rather than just having completely global variables, this class will hold
 #      the global values that may be of interest to many different functions
 #      in the program
 #
 #  Attributes:
 #      DEBUG - if debugging statements should be turned on
 #      VERBOSE - if more output statements should be turned on
 #
class globalParams():
    
    DEBUG, VERBOSE, NEWRULECOUNTER = False, False, 0

    def __init__(self, **kwargs):
        for key in ("DEBUG", "VERBOSE"):
            setattr(self, key, kwargs.get(key))

    def debug(self):
        return self.DEBUG

    def verbose(self):
        return self.VERBOSE

    def newRuleCounter(self):
        self.NEWRULECOUNTER += 1
        return self.NEWRULECOUNTER

##### Function Definitions #####

### Print Grammar 
 #  --------------
 #  Print the Grammar created
 #
 #  grammar: The grammar to be printed
 #
 #  returns: nothing
 ##
def printGrammar(grammar):
    for i in range(0, len(grammar)):
        print str(grammar[i][0])
        for j in range(1, len(grammar[i])):
            if grammar[i][j] == None:
                print "Error"
                print grammar[i]
                exit()
            print "\t"  +  ' '.join(grammar[i][j])
    


### Open a file
 #  ---------------------------
 #  Returns an open file object
 #
 #  filename: the name of the file to open
 #
 #  returns: a file object if filename represents a valid file name
 ##
def openfile( filename ):
    try:
        f = open(filename, 'r')
        return f
    except:
        print "could not open the file %s" % filename
        return None


### Eliminate Immidiate Left Recursion 
 #  ----------------------------------
 #  Removes the "obvious" left recursion of the form: A-> Aa | B into
 #      A  -> BA'
 #      A' -> aA' | ''
 #
 #  params: a class containing the global parameters
 #  grammar: The grammar being modified
 #  rule: the indicies which to detect left recursion
 #
 #  returns: nothing
 ##
def eImmediateLR(params, grammar, rule):
    prod = deepcopy(grammar[rule])
    l = 1
    while l < len(prod):
        if prod[0] != prod[l][0]:
            l+=1
        else:
            newS = prod[0] + str(params.newRuleCounter())
            if len(prod[l]) < 2:
                print "error"
                exit()
            r = deepcopy(prod[l][1:]) #left recursion part minus first symbol
            m = 1
            for m in range(1,  len(prod)):
                if m == l:
                    pass
                else:
                    prod[m].append(newS)
            del(prod[l])
            r.append(newS)
            newP = [newS, r, ['']]
            grammar.append(newP)
    grammar[rule] = prod

### Eliminate Left Recursion 
 #  ------------------------
 #  Using the algorithm described in the red dragon book on page 177, eliminate
 #      the left recursion from the grammar.
 #  The obvious left recursion was already eliminated by hand, but to ensure
 #      no other problems arise, I thought it was necessary to implement the
 #      full algorithm.
 #
 #  params: a class containing the global parameters
 #  grammar: The grammar to be modified.  This grammar should already have been
 #              converted using arrangeterminals to be of the form:
 #              G = [[symbol0, [p0], [p1], [p2]],
 #                  [symbol1, [p0], [p1], [p2]],
 #                  ...]
 #
 #  returns: the grammar
 ##
def eliminateLeftRecursion(params, grammar):
    if params.debug():
        print "\nStarting eliminateLeftRecursion"

    for i in range(0, len(grammar)):
        for j in range(0, i-1):
            ruleCopy = [grammar[i][0]]
            for p in range (1, len(grammar[i])): #for each production of ith rule
                if grammar[i][p][0] == grammar[j][0]: #if start same as prev symbol
                    if params.verbose():
                        print "\nFound left recursion on rule for " + \
                                str(grammar[i][0]) + " and " + str(grammar[j][0])
                    for n in range(1, len(grammar[j])):
                        temp = deepcopy(grammar[j][n])
                        if len(grammar[i][p]) > 1:
                            temp.append(grammar[i][p][1:][0])
                        if temp not in ruleCopy: #only if not already a rule
                            ruleCopy.append(temp)
                else:
                    ruleCopy.append(grammar[i][p])
            if grammar[i] != ruleCopy:
                if params.verbose():
                    print "replacing rule " + str(grammar[i]) + " for " + str(ruleCopy)
                grammar[i] = ruleCopy
        eImmediateLR(params, grammar, i)
    return grammar

if __name__ == "__main__":
    filep = openfile("clgrammer")

    globalP = globalParams(DEBUG=False, VERBOSE=False)
    
    if filep:
        grammar = arrangeTerminals(globalP, filep )
        grammar = eliminateLeftRecursion(globalP, grammar)
        printGrammar(grammar)
        print "closing file"
        filep.close()
 

### Function Title 
 #  --------------
 #  Description of function
 #
 #  parameter1: description of parameter
 #
 #  returns: what it returns
 ##
