import json
from pprint import pprint
import operator

parameters = [2, 4, 6, 8]
safeties = [0, 0.05, 0.1, 0.15, 0.2, 0.25]
thegood = []
MAX_PROBLEMS = 30

def play(data):
    for entry in data['results']:
        print entry['customers']

def my_total_filter(data):
    webover = 0
    storeover = 0
    utilization = 0
    multiplier = 0
    for entry in data['results']:
        if entry['web']['percent_used'] > 1.1:
            webover += 1
        if entry['storage']['percent_used'] > 1.0:
            storeover += 1
        elif entry['db']['percent_used'] > 1.0:
            storeover += 1
        curr_util = get_total_utilization(entry)
        curr_multiplier = get_total_multiplier(entry)
        utilization += curr_util
        multiplier += curr_multiplier
    utilization = utilization / (3 * len(data['results']))
    multiplier = multiplier / (3 * len(data['results']))
    return storeover, webover, utilization, multiplier, data['results'][len(data['results'])-1]['customers'] - data['results'][0]['customers']


def no_web_filter(data):
    over = 0
    for entry in data['results']:
        if entry['storage']['percent_used'] > 1.0:
            over += 1
        elif entry['db']['percent_used'] > 1.0:
            over += 1
    return over



def get_total_utilization(entry):
    util = 0
    util += entry['web']['percent_used']
    util += entry['storage']['percent_used']
    util += entry['db']['percent_used']
    return util

def get_total_multiplier(entry):
    mult = 0
    mult += (entry['web']['provision'] / entry['web']['capacity'])
    mult += (entry['storage']['provision'] / entry['storage']['capacity'])
    mult += (entry['db']['provision'] / entry['db']['capacity'])
    return mult 


def parameter_filter(prov, usage, useS, dbS):
    #if useS <= 0.1 or dbS <= 0.1:
    #    return True
    return False

def data_filter(soverages, woverages, data, util, mult, custDiff):
    #if soverages > 0:
    #    return True
    return False



if __name__=="__main__":
    data = None
    fw = open("results/aoutput.csv", 'w')
    for i in parameters:
        for j in parameters:
            for k in safeties:
                for l in safeties:
                    if parameter_filter(i, j, k, l):
                        continue
                    filename = "results/prov_%s_use_%s_s_%s_%s.json" % (str(i), str(j), str(k), str(l))
                    f = open(filename, 'r')
                    #print filename
                    with open(filename) as data_file:
                        data = json.load(data_file)
                    soverages, woverages, util, mult, custDiff= my_total_filter(data)
                    if data_filter(soverages, woverages, data, util, mult, custDiff):
                        continue
                    if soverages < MAX_PROBLEMS and woverages < MAX_PROBLEMS:
                        identifier = "%s_%s_%s_%s" % (str(i), str(j), str(k), str(l))
                        csvline = "%s,%s,%s\n" % (str(util), str(mult), identifier)
                        fw.write(csvline)
                        thegood.append([filename, soverages, woverages, util, mult, custDiff])
                        thegood.sort(key=operator.itemgetter(3), reverse=True)
                        thegood.sort(key=operator.itemgetter(4), reverse=True)
                        thegood.sort(key=operator.itemgetter(1,2))
                    #pprint(data)
                    f.close()

    fw.close()
    print thegood
    print len(thegood)
