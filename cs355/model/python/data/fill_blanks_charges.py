"""
Contains the levels to charge for each container
Based off how much we pay for each, in fill_blanks
"""
import sys
import __main__
from fill_blanks import *

def database_rate(service, which):
    if which is 'default':
        return dbstorage_options['Default']['cost_request']
    else:
        return None #should cause an exception

def db_storage_level(service, which):
    if which is 'default':
        return dbstorage_options['Default']['cost_size']
    else:
        return None #should cause an exception

def ebs_rate(service, which):
    if which is 'default':
        return ebs_options['Default']['cost_request']
    else:
        return None #should cause an exception

def ebs_level(service, which):
    if which is 'default':
        return ebs_options['Default']['cost_size']
    else:
        return None #should cause an exception

def load_balance_rate(service, which):
    if which is 'default':
        return loadbalancer_options['Default']['cost_io']
    else:
        return None #should cause an exception
def webservice_level(service, which):
    if which is 'default':
        """ dividing by 104 since Quadruple has 26 cmpt units =approx 31 GHz"""
        return (webservice_options['Default']['cost_per_second'][3])/104.0
    else:
        return None #should cause an exception

def get_default_charge(service, charge_type):
    print charge_type
    return getattr(sys.modules[__name__], charge_type)(service, 'default')


if __name__=="__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))

