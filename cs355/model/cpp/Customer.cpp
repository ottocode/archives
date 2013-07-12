#include "Customer.h"
#include "Service.h"
#include "Probability.h"
#include <stdio.h>

Customer::Customer(){
    setWebProv(DEFAULTPROV);
    setStorageProv(DEFAULTPROV);
    setDbProv(DEFAULTPROV);
    setWebUse(DEFAULTUSE);
    setStorageUse(DEFAULTUSE);
    setDbUse(DEFAULTUSE);
}

Customer::Customer(int nWebProv, 
        int nStorageProv,
        int nDbProv,
        int nWebUse,
        int nStorageUse,
        int nDbUse){
    setWebProv(nWebProv);
    setStorageProv(nStorageProv);
    setDbProv(nDbProv);
    setWebUse(nWebUse);
    setStorageUse(nStorageUse);
    setDbUse(nDbUse);
}


void Customer::setWebProv(int nProvision){
    webprov = usage_fraction(nProvision);
}

void Customer::setStorageProv(int nProvision){
    storageprov = usage_fraction(nProvision);
}

void Customer::setDbProv(int nProvision){
    dbprov = usage_fraction(nProvision);
}

double Customer::getWebProv(){
    return webprov;
}

double Customer::getStorageProv(){
    return storageprov;
}

double Customer::getDbProv(){
    return dbprov;
}

void Customer::setWebUse(int provision){
    webusage = provision;
}

void Customer::setStorageUse(int provision){
    storageusage = provision;
}

void Customer::setDbUse(int provision){
    dbusage = provision;
}

int Customer::getWebUse(){
    return webusage;
}

int Customer::getStorageUse(){
    return storageusage;
}

int Customer::getDbUse(){
    return dbusage;
}

double Customer::calcWebUse(){
    return getWebProv() * usage_fraction(getWebUse());
}

double Customer::calcStorageUse(){
    return getStorageProv() * usage_fraction(storageusage);
}

double Customer::calcDbUse(){
    return getDbProv() * usage_fraction(dbusage);
}
