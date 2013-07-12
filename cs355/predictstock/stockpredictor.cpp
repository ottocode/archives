/** stockpredictor.cpp
 * This is a simple stock predictor using lognormal distributions.  
 * It certainly won't be accurate, but is for instructive purposes.
 *
 * Author:  Nicholas Otto - and some serious StackOverflow lookups :)
 */

#include <cstdio>
#include <iostream>
#include <sstream>
#include <fstream>
#include <cstring>
#include <cmath>
#include <ctime>
#include <curl/curl.h>
#include <stdlib.h>


using namespace std;
CURL *curl;
CURLcode res;
string test = "hello";
string base = "http://ichart.finance.yahoo.com/table.csv?";
string s = "s=NOC";                            //TICKER
string d = "&d=2";                              //toMonth-1
string e = "&e=6";                             //to Day
string f = "&f=2013";                           //to Year
string g = "&g=d";                              //d=day, m=month, y=yearly
string a = "&a=0";                              //fromMonth-1
string b = "&b=12";                             //from Day
string c = "&c=2012";                           //from Year
string tail = "&ignore=.csv";
string holder[] = {base, s, d, e, f, g, a, b, c, tail};

size_t write_data(char *ptr,
        size_t size,
        size_t nmemb,
        void *userdata){

    std::ostringstream *stream = (std::ostringstream*)userdata;
    size_t count = size * nmemb;
    stream->write(ptr, count);
    return count;
}

double genRandNormal(double mu, double sigma){
    double randnum = 0;
    for (int i=0; i< 12; i++){
        randnum += 1.0*rand()/RAND_MAX;
    }
    double k = randnum - 6;
    return mu + k*sigma;
}


int main(){
    string combine;
    FILE *fp;
    int year, month, day;
    struct tm tm;
    time_t curtime, prevtime;
    long n = 0;
    double sum = 0;
    double newclose = 0, oldclose=0;
    double leadingterm=0, middleterm = 0;
    double sigma, mu;

    double firstclose;
    for (int i=0; i<10; i++){
        combine.append(holder[i]);
    }
    //;cout << combine << "\n";


    std::stringstream stream;

    curl = curl_easy_init();
    char outfilename[FILENAME_MAX] = "testing.csv";
    std::ofstream outFile;
    if(curl){

        //fp = fopen(outfilename, "w");
        outFile.open(outfilename);
        
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &stream);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
        curl_easy_setopt(curl, CURLOPT_URL, combine.c_str());
        //curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

        res = curl_easy_perform(curl);

        //std::string output = stream.get();

        if( res != CURLE_OK){
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }
        curl_easy_cleanup(curl);
        //fclose(fp);

        char testline[512];
        //fscanf(stream, "%s", stream);
        stream.get();
        stream.getline(testline,512);

        time ( &prevtime);
        tm.tm_year = year;
        tm.tm_mon = month;
        tm.tm_mday = day;
        prevtime = mktime(&tm);

        string complete = stream.str();
        //cout << complete << "\nend test\n";
        
        string charfind (",");
        string newline ("\n");
        string::size_type found = complete.find(newline);
        string::size_type nextline = found;
        string::size_type oldline = -1;

        string templine;
        string date;
        string close;

        
        //skip first line
        oldline = nextline;
        nextline = complete.find(newline, nextline+1);
        templine = complete.substr(oldline+1, nextline-(oldline+1));

        /* get first date */
        found = templine.find(charfind, 0);
        date = templine.substr(0, found);
        sscanf(date.c_str(), "%d-%d-%d", &year, &month, &day);
        tm.tm_year = year;
        tm.tm_mon = month;
        tm.tm_mday = day;
        prevtime = mktime(&tm);

        found = templine.find_last_of(charfind);
        close = templine.substr(found+1, string::npos);

        oldclose = atof(close.c_str());
        firstclose = oldclose;
        //cout << "date: " << date << "  close: " << oldclose << "\n";

        oldline = nextline;
        nextline = complete.find(newline, nextline+1);
 
        double seconds;
        while(nextline != string::npos){
            templine = complete.substr(oldline+1, nextline-(oldline+1));
            //cout << templine <<"\n";

            /* get date */
            found = templine.find(charfind, 0);
            date = templine.substr(0, found);

            found = templine.find_last_of(charfind);
            close = templine.substr(found+1, string::npos);

            sscanf(date.c_str(), "%d-%d-%d", &year, &month, &day);
            tm.tm_year = year;
            tm.tm_mon = month;
            tm.tm_mday = day;
            curtime = mktime(&tm);
            newclose = atof(close.c_str());
            seconds  = difftime(prevtime, curtime);
            seconds = seconds/86400;
            //cout << "date: " << year << " " << month << " " << day << " " << "  close: " << newclose << "\n";
            if(seconds > 0){

                n += seconds;
                double tempd = log(oldclose/newclose);
                sum += tempd;
                leadingterm += pow(tempd,2);
                middleterm += tempd;
                //printf("sum: %f\n", sum);
            }


            oldline = nextline;
            nextline = complete.find(newline, nextline+1);
            oldclose = newclose;
            prevtime = curtime;
        }

        //printf("sum: %f, n: %ld\n", sum, n);
        sigma = 0;
        mu = sum/n;
        sigma = sqrt((leadingterm - 2*middleterm*mu + n*pow(mu, 2))/(n-1));
        printf("mu = %f  ", mu);
        printf("sigma = %f\n", sigma);
        outFile.close();
    }


    //printf("test %f\n", genRandNormal(10, 2));
    //printf("test %f\n", firstclose);

    long numpred = 1000;
    double sumpred = 0;

    double curpred;
    double lastpred;
    for(int i=0; i<numpred; i++){
        lastpred = firstclose;
        for (int j=0; j<7; j++){
            curpred = lastpred * exp(genRandNormal(mu, sigma));
            lastpred = curpred;
        }
        sumpred += curpred;
    }


    printf("STOCK: %s\nfinal prediction: %f\nvs current price: %f\n", s.c_str(), sumpred/numpred, firstclose);


    return 0;
}
