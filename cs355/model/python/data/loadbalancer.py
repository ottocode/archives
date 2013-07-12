import __main__
import sys
from fill_blanks import *

loadbalancer_default = "Default"

class loadbalancer(object):

    allowed_keys = ['instance_type']

    def __init__(self, **kw):
        for k in self.allowed_keys:
            setattr(self, k, None)
        for key, value in kw.items():
            if key in self.allowed_keys:
                setattr(self, key, value)
        parameters = choose_lbinstance(self.instance_type)
        for key, value in parameters.items():
            setattr(self, key, value)


if __name__=="__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))
    t = loadbalancer()
    print t
    for a in attr_generator(t):
        print a
