#include "Service.h"
#include "Customer.h"
#include "Category.h"
#include "Probability.h"
#include <cstdio>
#include <assert.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <fstream>
#include <cstring>
#include <cmath>
#include <time.h>
#include <vector>


int DEFAULTPROV;
int DEFAULTUSE;
int INITIAL_WEB = 100;
int INITIAL_STORAGE = 100;
int INITIAL_DB = 100;



time_t global_time;
struct tm *tm;

int main(int argc, char** argv){
    global_time = time(0);
    tm = localtime(&global_time);
    srand(tm->tm_sec);
    if (DEBUG){
        assert(testfunc());
    }

    DEFAULTPROV = strtol(argv[1], (char **)NULL, 10);
    DEFAULTUSE = strtol(argv[2], (char **)NULL, 10);
    double storageSafety = strtod(argv[3], (char **)NULL);
    double dbSafety = strtod(argv[4], (char **)NULL);

    char filename[255];
    FILE *writeFile;
    if(!DEBUG){
        sprintf(filename, "results/prov_%s_use_%s_s_%s_%s.json", 
                argv[1], argv[2],  argv[3],  argv[4]);
        writeFile = fopen(filename, "w");

        fprintf(writeFile, "{\"provision\":%d,\"usage\":%d,"
                "\"storageSafety\":%f,\"dbSafety\":%f,\"results\":[",
                DEFAULTPROV,
                DEFAULTUSE,
                storageSafety,
                dbSafety);
    }

    //Initialize Customers
    std::vector<Customer> Customers;
    int cust_num = INITIAL_CUSTOMER_COUNT;
    Customers.reserve(cust_num * 2);

    int i = 0;
    for(i = 0; i < cust_num; i++){
        Customers.push_back(Customer());
    }

    //Initialize Categories
    Category Web;
    Category Storage;
    Category Db;
    
    Web.setCapacity(INITIAL_WEB);
    Storage.setCapacity(INITIAL_STORAGE);
    Db.setCapacity(INITIAL_DB);

    Storage.setSafety(storageSafety);
    Db.setSafety(dbSafety);

    int time = 0;
    for(time = 0; time < SIMULATION_TIME; time++){
        Web.clear();
        Storage.clear();
        Db.clear();
        
        /** Calculate total usage and provisioning for this time step **/
        double webProv = 0, storageProv = 0, dbProv = 0;
        for(int j = 0; j < Customers.size(); j++){
            Customer frank = Customers.at(j);
            double webuse = frank.calcWebUse();
            webProv += frank.getWebProv();

            double storageuse = frank.calcStorageUse();
            storageProv += frank.getStorageProv();

            double dbuse = frank.calcDbUse();
            dbProv += frank.getDbProv();

            Web.addUsage(webuse);
            Storage.addUsage(storageuse);
            Db.addUsage(dbuse);
        }

        if (DEBUG){//print to screen
            printf("{\"customers\":%ld,\"web\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}"
            ",\"storage\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}"
            ",\"db\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}},"
            "\n",
                Customers.size(),
                webProv,
                Web.getUsage(),
                Web.getCapacity(),
                Web.getUsage()/Web.getCapacity(),
                webProv-Web.getCapacity(),
                storageProv,
                Storage.getUsage(),
                Storage.getCapacity(),
                Storage.getUsage()/Storage.getCapacity(),
                storageProv-Storage.getCapacity(),
                dbProv,
                Db.getUsage(),
                Db.getCapacity(),
                Db.getUsage()/Db.getCapacity(),
                dbProv-Db.getCapacity());
        }
        else{//print to file
            if (time < SIMULATION_TIME - 1){
                fprintf(writeFile, "{\"customers\":%ld,\"web\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}"
                ",\"storage\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}"
                ",\"db\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}},"
                "\n",
                    Customers.size(),
                    webProv,
                    Web.getUsage(),
                    Web.getCapacity(),
                    Web.getUsage()/Web.getCapacity(),
                    webProv-Web.getCapacity(),
                    storageProv,
                    Storage.getUsage(),
                    Storage.getCapacity(),
                    Storage.getUsage()/Storage.getCapacity(),
                    storageProv-Storage.getCapacity(),
                    dbProv,
                    Db.getUsage(),
                    Db.getCapacity(),
                    Db.getUsage()/Db.getCapacity(),
                    dbProv-Db.getCapacity());
            }
            else{// get rid of the stupid trailing comma
                 fprintf(writeFile, "{\"customers\":%ld,\"web\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}"
                ",\"storage\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}"
                ",\"db\":{\"provision\":%f,\"usage\":%f,\"capacity\":%f,\"percent_used\":%f,\"oversell\":%f}}"
                "\n",
                    Customers.size(),
                    webProv,
                    Web.getUsage(),
                    Web.getCapacity(),
                    Web.getUsage()/Web.getCapacity(),
                    webProv-Web.getCapacity(),
                    storageProv,
                    Storage.getUsage(),
                    Storage.getCapacity(),
                    Storage.getUsage()/Storage.getCapacity(),
                    storageProv-Storage.getCapacity(),
                    dbProv,
                    Db.getUsage(),
                    Db.getCapacity(),
                    Db.getUsage()/Db.getCapacity(),
                    dbProv-Db.getCapacity());
            }
        }



        /////// Update based on last time interval//////
        Web.updateEffect();
        Storage.updateEffect();
        Db.updateEffect();

        double webEffect = Web.getEffect();
        double storageEffect = Storage.getEffect();
        double dbEffect = Db.getEffect();
        double totalEffect = webEffect + storageEffect + dbEffect;
        int flag = 0;
        if (webEffect < 0 || storageEffect < 0 || dbEffect < 0){
            flag = 1;
        }
        totalEffect = totalEffect < -1.0 ? -1.0 : totalEffect;
        //biased to go down
        double modifier = 0;
        if (totalEffect < 0){
            modifier = totalEffect * 0.3 * normal_dist();
        } else{
            if (flag){
                modifier = 0.005 * normal_dist();
            }else{
                modifier = 0.01 * normal_dist();
            }
        }

        int cust_diff = ceil(modifier*Customers.size());
        cust_diff = abs(cust_diff);
        for (int k = 0; k < cust_diff; k++){
            if (totalEffect < 0){
                Customers.pop_back();
            }
            else{
                Customers.push_back(Customer());
            }
        }
    }
        
    if(!DEBUG){
        fprintf(writeFile, "]}");

        fclose(writeFile);
    }
    return 0;
}

int testfunc(){
    int good = 0;
    good = test_probability();

    Customer testCustomer;
    double tcw = testCustomer.calcWebUse();
    printf("testCustomer calcWebUse() = %f\n", tcw);
    tcw = testCustomer.calcStorageUse();
    printf("testCustomer calcStorageUse() = %f\n", tcw);
    tcw = testCustomer.calcDbUse();
    printf("testCustomer calcDbUse() = %f\n", tcw);

    Category testCategory;

    return good;
}

int test_probability(){
    printf("time sec: %d\n", tm->tm_sec);
    double idf = inverse_distribution_function(DEFAULTPROV);
    printf("inverse_distribution (0.5, default) = %f\n", idf);

    for (int i=0; i<10; i++){
        printf("randNormal: %f\n", normal_dist());
    }

    double uf = usage_fraction(DEFAULTPROV);
    printf("usage_fraction (default) = %f\n", uf);
    return 1;
}
