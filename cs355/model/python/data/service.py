"""
service.py defines the service set-up design under test.
a service has the following attributes:
    ebs
    db_storage
    db_io
    webservice
    loadbalancer
"""
import sys
import __main__
import fill_blanks
from fill_blanks import *

class service(object):
    """ 
    the service design under test
    """

    allowed_keys = ["ebs", "db_storage", "db_io", "webservice", "loadbalancer"]

    def __init__(self, **kw):
        for key, value in kw.items():
            if key in self.allowed_keys:
                setattr(self, key, value)
        for k in self.allowed_keys:
            if k not in self.__dict__.keys():
                setattr(self, k, getattr(fill_blanks, 'get_instance')(k, None))






if __name__ == "__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))
    u = service()
    sys.stdout.write("u:  %s\n" % u)

    g = attr_generator(u)
    for a in g:
        print a
    print "end u attr"
