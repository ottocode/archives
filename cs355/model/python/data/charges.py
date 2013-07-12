"""
charges.py lists the charges we make to the user for various services
    ebs_level           per GB
    db_storage_level    per GB
    webservice_level    per MHz
    load_balance_rate   per GB/sec
    ebs_rate            per io/sec
    database_rate       per requests/sec
"""
import sys
import __main__
import fill_blanks_charges
import service
from fill_blanks_client import attr_generator

class charges(object):
    """
    Class describing charging scheme
    """

    allowed_keys = ["ebs_level", 
            "db_storage_level", "webservice_level",
            "load_balance_rate", "ebs_rate", "database_rate"]

    def __init__(self, service, *args, **kw):
        """ initialize a charge.  If upon creation valid parameters were passed,
        set the class values to the value of those parameters.
        If no parameter passed, assume not charging.
        """
        for key, value in kw.items():
            if key in self.allowed_keys:
                setattr(self, key, value)
        if 'default' in args:
            for k in self.allowed_keys:
                setattr(self, k, getattr(fill_blanks_charges, 'get_default_charge')(service, k))
        for k in self.allowed_keys:
            if k not in self.__dict__.keys():
                setattr(self, k, getattr(fill_blanks_charges, 'get_default_charge')(service, k))


if __name__=="__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))
    s = service.service()
    c = charges(s, **{'ebs_level' : 344})
    g = attr_generator(c)
    for a in g:
        print a

    print c.ebs_level
    print 'now try this'
    f = charges('default')
    g = attr_generator(f)
    for a in g:
        print a
