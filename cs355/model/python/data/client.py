"""
client.py defines what a client is for the simulation
clients have the following attributes:
    creationtime in seconds
    ebs_level           in GB
    db_storage_level    in GB
    webservice_level    in MHz
    load_balance_rate   in GB/sec
    ebs_rate            in io/sec
    database_rate       in requests/sec
"""
import sys
import __main__
import fill_blanks_client
from fill_blanks_client import attr_generator

class client(object):
    """ A basic client
    """

    allowed_keys = ["creationtime", "ebs_level", 
            "db_storage_level", "webservice_level",
            "load_balance_rate", "ebs_rate", "database_rate"]

    def __init__(self, **kw):
        """ initialize a client.  If upon creation valid parameters were passed,
        set the class values to the value of those parameters
        """
        for key, value in kw.items():
            if key in self.allowed_keys:
                setattr(self, key, value)
        for k in self.allowed_keys:
            if k not in self.__dict__.keys():
                if k is "creationtime":
                    setattr(self, k, 0)
                else:
                    funcname = 'choose_' + k
                    setattr(self, k, getattr(fill_blanks_client, funcname)(None))


if __name__=="__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))
    c = client()
    g = attr_generator(c)
    for a in g:
        print a

    print c.ebs_level

