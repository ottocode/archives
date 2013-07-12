"""
costs.py is designed to use some very broad assumptions and come up with a reasonably worst case scenario.
assumptions are (for this case) in data/fill_blanks.py

TODO: Outgoing web traffic costs
Maximum capacity we can serve with our setup choice.  
    What is the probability we will hit that capacity level?
"""

import sys
sys.path.insert(0, 'data')
import service
import charges
import client
import __main__

class assumptions(object):
    seconds_oneyear = 31536000.0
    seconds_threeyears = 3*31536000.0
    ebs_size = 1024.0       #provisioned ebs storage
    db_storage_size = 1024  #provisioned database storage
    loadbalancer_size = 1.0/1024    #1Mbps
    ebs_requests =  10000.0/1000000               #in millions / second
    database_requests = 100.0/1000000           #in millions / second



class build_costs(object):
    """
    Build the costs of running MiniCloud using just the most basic, high, assumptions.
    Does not consider usage at all, yet.
    """

    def __init__(self, setup):
        self.ebs_costs = self.ebs(self, **getattr(setup, 'ebs'))
        self.dbstorage_costs = self.db_storage(self, **getattr(setup, 'db_storage'))
        self.db_costs = self.db_io(self, **getattr(setup, 'db_io'))
        self.loadbalancer_costs = self.loadbalancer(self, **getattr(setup, 'loadbalancer'))
        self.webservice_costs = self.webservice(self, **getattr(setup, 'webservice'))
        self.total = self.build_cost(self.ebs_costs,  self.dbstorage_costs \
            , self.db_costs , self.loadbalancer_costs, self.webservice_costs)

        

    def ebs(self, *args, **kw):
        """
        calculate the ebs costs for one year vs 3 years

        return: (oneyearcosts, threeyearcosts)
        """
        onesec = assumptions.seconds_oneyear
        threesec = assumptions.seconds_threeyears
        size = assumptions.ebs_size
        requests = assumptions.ebs_requests

        onecost = onesec*( requests*kw['cost_request'] + size*kw['cost_size'])
        threecost = threesec*(requests*kw['cost_request'] + size*kw['cost_size'])
        return [onecost, threecost]

    def db_storage(self, *args, **kw):
        """
        calculate the database storage costs for one year vs 3 years
        NOTE: assumes 2 multi-av database being utilized the same.

        return: (oneyearcosts, threeyearcosts)
        """
        onesec      = assumptions.seconds_oneyear
        threesec    = assumptions.seconds_threeyears
        size        = assumptions.db_storage_size

        onecost     = onesec*(assumptions.database_requests*kw['cost_request'] + 
                2*size*kw['cost_size'])
        threecost   = threesec*(assumptions.database_requests*kw['cost_request'] 
                + 2*size*kw['cost_size'])
        return [onecost, threecost]

    def db_io(self, *args, **kw):
        """
        calculate the database usage costs for one year vs 3 years
        NOTE: assumes 2 multi-av database being utilized the same.

        return: (oneyearcosts, threeyearcosts)
        """
        onesec      = assumptions.seconds_oneyear
        threesec    = assumptions.seconds_threeyears

        onecost     = onesec*2*(kw['cost_per_second'][1])
        threecost   = threesec*2*(kw['cost_per_second'][3])
        threecost += kw['cost_t0'][3]
        onecost += kw['cost_t0'][1]
        return [onecost, threecost]

    def webservice(self, *args, **kw):
        """
        calculate the webservice usage costs for one year vs 3 years
        NOTE: assumes 2 webservices being utilized the same.



        return: (oneyearcosts, threeyearcosts)
        """
        onesec      = assumptions.seconds_oneyear
        threesec    = assumptions.seconds_threeyears

        onecost     = 2*onesec*(kw['cost_per_second'][1])
        threecost   = 2*threesec*(kw['cost_per_second'][3])
        threecost += kw['cost_t0'][3]
        onecost += kw['cost_t0'][1]
        return [onecost, threecost]

    def loadbalancer(self, *args, **kw):
        """
        calculate the load_balancer costs for one year vs 3 years

        return: (oneyearcosts, threeyearcosts)
        """
        lbuse       = assumptions.loadbalancer_size
        onesec      = assumptions.seconds_oneyear
        threesec    = assumptions.seconds_threeyears

        onecost     = onesec*kw['cost_per_second']
        threecost   = threesec*kw['cost_per_second']
        onecost     += lbuse*onesec*kw['cost_io']
        threecost   += lbuse*threesec*kw['cost_io']
        return [onecost, threecost]

    def build_cost(self, *args):
        """
        add all of the costs together
        """
        total = [0, 0]
        for item in args:
            total[0] += item[0]
            total[1] += item[1]
        return total


class build_revenues(object):
    """ 
    An estimation of the revenue amount given a service level and
    number of customers
    """

    def __init__(self, service):
        self.charge = charges.charges(service)
        self.client = client.client()
        print "charge ebs" + str(self.charge.ebs_level)
        print "client ebs" + str(self.client.ebs_level)


if __name__ == "__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))

    S = service.service()
    C = build_costs(S)
    R = build_revenues(S)
    
    
    sys.stdout.write("1 yr cost using 1 yr commitments: %s\n3 yr cost using 3 yr commitments: %s\n" % (C.total[0], C.total[1]))


