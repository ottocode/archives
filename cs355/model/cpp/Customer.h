
#ifndef CUSTOMER_H
#define CUSTOMER_H

class Customer {
    private:
        double webprov;
        double storageprov;
        double dbprov;
        int webusage;
        int storageusage;
        int dbusage;

    public:
        Customer(); //default constructor

        /* Constructor with initial values */
        Customer(int nWebProv,  
            int nStorageProv,
            int nDbProv,
            int nWebUse,
            int nStorageUse,
            int nDbUse);

        void setWebProv(int nProvision);
        void setStorageProv(int nProvision);
        void setDbProv(int nProvision);

        double getWebProv();
        double getStorageProv();
        double getDbProv();

        void setWebUse(int nProvision);
        void setStorageUse(int nProvision);
        void setDbUse(int nProvision);

        int getWebUse();
        int getStorageUse();
        int getDbUse();

        double calcWebUse();
        double calcStorageUse();
        double calcDbUse();

};

#endif
