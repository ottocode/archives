
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
    
    DEBUG, VERBOSE, BUILDFIRSTDB, BUILDFOLLOWDB, NEWRULECOUNTER = False, False, False, False, 0

    def __init__(self, **kwargs):
        for key in ("DEBUG", "VERBOSE", "BUILDFIRSTDB", "BUILDFOLLOWDB"):
            setattr(self, key, kwargs.get(key))

    def debug(self):
        return self.DEBUG

    def buildFirstDebug(self):
        return self.BUILDFIRSTDB

    def buildFollowDebug(self):
        return self.BUILDFOLLOWDB

    def verbose(self):
        return self.VERBOSE

    def newRuleCounter(self):
        self.NEWRULECOUNTER += 1
        return self.NEWRULECOUNTER


