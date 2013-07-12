"""
Randomly generate the various values (not yet implemented), such as generating the type of ebs_level for a user.
Right now it only returns defaults.

Also defines what the various levels of client usage are
    ebs_level is in GB
    db_storage_level is in GB
    database_rate is in requests per second 
    webservice_level_options is in {MGhz, GB}
"""

import __main__
import sys

ebs_level_options = {
        "Default" : 50
        }
db_storage_level_options = {
        "Default" : 50
        }
database_rate_options = {
        "Default" : 1000000.0/(24*3600) #high, 1mill/day
        }
webservice_level_options = {
        "Default" : 300     # in MGhz
        }
load_balance_rate_options = {
        "Default" : 1.0/(24*3600) #super high 1GB/day
        }
ebs_rate_options = {
        "Default" : 1000000.0/(24*3600) #super high 1mil/day
        }


def get_ebs_level_options(name):
    return ebs_level_options["Default"]
def get_db_storage_level_options(name):
    return db_storage_level_options["Default"]
def get_database_rate_options(name):
    return database_rate_options["Default"]
def get_webservice_level_options(name):
    return webservice_level_options["Default"]
def get_load_balance_rate_options(name):
    return load_balance_rate_options["Default"]
def get_ebs_rate_options(name):
    return ebs_rate_options["Default"]


if __name__=="__main__":
    sys.stdout.write("begin testing %s\n" % str(__main__.__file__))
    print get_ebs_level_options("name")
    print get_db_storage_level_options("name")
    print get_database_rate_options("name")
    print get_webservice_level_options("name")
    print get_load_balance_rate_options("name")
    print get_ebs_rate_options("name")
