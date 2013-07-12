import __main__
import sys
from random_gen import *

def attr_generator(obj):
    for key, value in obj.__dict__.items():
        yield (key, value)

def choose_ebs_level(name):
    return get_ebs_level_options(name)
    
def choose_db_storage_level(name):
    return get_db_storage_level_options(name)
    
def choose_database_rate(name):
    return get_database_rate_options(name)
    
def choose_webservice_level(name):
    return get_webservice_level_options(name)
    
def choose_load_balance_rate(name):
    return get_load_balance_rate_options(name)
    
def choose_ebs_rate(name):
    return get_ebs_rate_options(name)

if __name__=="__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))
    print choose_ebs_level("name")
    print choose_db_storage_level("name")
    print choose_database_rate("name")
    print choose_webservice_level("name")
    print choose_load_balance_rate("name")
    print choose_ebs_rate("name")
 
