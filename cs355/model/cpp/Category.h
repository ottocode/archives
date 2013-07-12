#ifndef CATEGORY_H
#define CATEGORY_H


#include <queue>

class Category {
    public:
        Category();
        void clearUsage();
        void setSafety(double nsafe);
        double addUsage(double additional);
        double getUsage();

        void setCapacity(double nCapacity);
        void updateCapacity();
        double getCapacity();

        void clearEffect();
        void updateEffect();
        double getEffect();

        void clear(){clearUsage(); clearEffect();};

    private:
        std::queue<double> effectQueue;
        double usage;
        double capacity;
        double customerEffect;
        double safety;
};

#endif
