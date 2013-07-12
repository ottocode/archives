"""
fill_blanks.py contains the definitions for the various money costing aspects of the service.

All of the options have the following fields:
    cost_t0         the cost at time 0
    cost_per_second
    cost_io         the cost per GB*sec
    cost_request    cost per request
    cost_size       cost per GB*sec
    name
"""

import __main__
import sys

### aws.amazon.com/ec2/pricing


def attr_generator(obj):
    for key, value in obj.__dict__.items():
        yield (key, value)

webservice_options = {  'Default' :
                       {'cost_t0'          : {1 : 3156, 3: 4792},
                        'cost_per_second'  : {1 : 0.272/3600, 3: 0.212/3600},
                        'cost_io'          : None,
                        'cost_request'     : None,
                        'cost_size'        : None,
                        'name'             : "Quadruple Extra Large"},
                 'Quadruple Extra Large' :
                       {'cost_t0'          : {1 : 3156, 3: 4792},
                        'cost_per_second'  : {1 : 0.272/3600, 3: 0.212/3600},
                        'cost_io'          : None,
                        'cost_request'     : None,
                        'cost_size'        : None,
                        'name'             : "Quadruple Extra Large"},
                'Double Extra Large' :
                       {'cost_t0'          : {1 : 1578, 3: 2396},
                        'cost_per_second'  : {1 : 0.136/3600, 3: 0.106/3600},
                        'cost_io'          : None,
                        'cost_request'     : None,
                        'cost_size'        : None,
                        'name'             : "Double Extra Large"},
                'Extra Large' :
                       {'cost_t0'          : {1 : 789, 3: 1198},
                        'cost_per_second'  : {1 : 0.068/3600, 3: 0.053/3600},
                        'cost_io'          : None,
                        'cost_request'     : None,
                        'cost_size'        : None,
                        'name'             : "Extra Large"}
                }


database_options = {
        'Default' :
            {'cost_t0'              : {1 : 8240, 3 : 12400},
                'cost_per_second'  : {1 : 1.241/3600, 3 : 0.870/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Multi AZ Quadruple Extra Large HM"},
        'Multi AZ Quadruple Extra Large HM' :
            {'cost_t0'              : {1 : 8240, 3 : 12400},
                'cost_per_second'  : {1 : 1.241/3600, 3 : 0.870/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Multi AZ Quadruple Extra Large HM"},
        'Multi AZ Double Extra Large HM' :
            {'cost_t0'              : {1 : 4120, 3 : 6200},
                'cost_per_second'  : {1 : 0.6/3600, 3 : 0.434/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Multi AZ Double Extra Large HM"},
        'Multi AZ Extra Large HM' :
            {'cost_t0'              : {1 : 2060, 3 : 3100},
                'cost_per_second'  : {1 : 0.3/3600, 3 : 0.22/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Multi AZ Extra Large HM"},
        'Multi AZ Extra Large' :
            {'cost_t0'              : {1 : 3120, 3 : 4800},
                'cost_per_second'  : {1 : 0.440/3600, 3 : 0.326/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Multi AZ Extra Large"},
        'Multi AZ Large' :
            {'cost_t0'              : {1 : 1560, 3 : 2400},
                'cost_per_second'  : {1 : 0.220/3600, 3 : 0.162/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Multi AZ Large"},
        'Standard Quadruple Extra Large HM' :
            {'cost_t0'              : {1 : 4120, 3 : 6200},
                'cost_per_second'  : {1 : 0.600/3600, 3 : 0.435/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Standard Quadruple Extra Large HM"},
        'Standard Double Extra Large HM' :
            {'cost_t0'              : {1 : 2060, 3 : 3100},
                'cost_per_second'  : {1 : 0.3/3600, 3 : 0.217/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Standard Double Extra Large HM"},
        'Standard Extra Large HM' :
            {'cost_t0'              : {1 : 1030, 3 : 1550},
                'cost_per_second'  : {1 : 0.15/3600, 3 : 0.11/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Standard Extra Large HM"},
        'Standard Extra Large' :
            {'cost_t0'              : {1 : 1560, 3 : 2400},
                'cost_per_second'  : {1 : 0.220/3600, 3 : 0.163/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Standard Extra Large"},
        'Standard Large' :
            {'cost_t0'              : {1 : 780, 3 : 1200},
                'cost_per_second'  : {1 : 0.11/3600, 3 : 0.081/3600},
                'cost_io'          : None,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Standard Large"},
        }

loadbalancer_options = {
        'Default' :
            {'cost_t0'              : None,
                'cost_per_second'  : 0.025/3600,
                'cost_io'          : 0.008,
                'cost_request'     : None,
                'cost_size'        : None,
                'name'             : "Default Load Balancer"}
            }

ebs_options = {
        'Default' :
            {'cost_t0'              : None,
                'cost_per_second'  : None,
                'cost_io'          : None,
                'cost_size'        : 0.1/(30*24*60*60),
                'cost_request'     : 0.1/1000000,
                'name'             : "Default Elastic Block Storage"}
            }

dbstorage_options = {
        'Default' :
            {'cost_t0'              : None,
                'cost_per_second'  : None,
                'cost_io'          : None,
                'cost_request'     : 0.1/1000000,
                'cost_size'        : 0.2/(30*24*60*60),
                'name'             : "Default Database Storage"}
            }

def get_instance(category, which_one):
    if category is 'ebs':
        return choose_ebsinstance(which_one)
    if category is 'db_storage':
        return choose_dbstorageinstance(which_one)
    if category is 'db_io':
        return choose_dbinstance(which_one)
    if category is 'webservice':
        return choose_wsinstance(which_one)
    if category is 'loadbalancer':
        return choose_lbinstance(which_one)


def choose_wsinstance(name):
    if name in webservice_options.keys():
        return webservice_options[name]
    else:
        return webservice_options['Default']

def choose_dbinstance(name):
    """ get the appropriate (name) database description
    if that description is not available, use default
    """
    if name in database_options.keys():
        return database_options[name]
    else:
        return database_options['Default']

def choose_lbinstance(name):
    """ get the appropriate (name) load balancer description
    if that description is not available, use default
    """
    if name in loadbalancer_options.keys():
        return loadbalancer_options[name]
    else:
        return loadbalancer_options['Default']

def choose_ebsinstance(name):
    """ get the appropriate (name) ebs description
    if that description is not available, use default
    """
    if name in ebs_options.keys():
        return ebs_options[name]
    else:
        return ebs_options['Default']

def choose_dbstorageinstance(name):
    """ get the appropriate (name) database storage description
    if that description is not available, use default
    """
    if name in dbstorage_options.keys():
        return dbstorage_options[name]
    else:
        return dbstorage_options['Default']

if __name__=="__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))
    for key, value in webservice_options.items():
        print choose_wsinstance(key)

    print choose_wsinstance('asfasdf')
    print choose_dbinstance(None)
    print choose_lbinstance(None)
    print choose_ebsinstance(None)
    print choose_dbstorageinstance(None)
