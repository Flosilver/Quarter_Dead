#ifndef MAP_HPP
#define MAP_HPP

#include "config.hpp"
#include "Room.hpp"

using namespace std;

class Map
{
    protected:
        map_t map;
        size_t size;

    public:
        Map();
        Map(size_t s);
        Map(const Map& m);
        ~Map();

        /* Operators */
        Map& operator=(const Map& m);
        vsp_Room& operator[](size_t i);

        /* Accesseurs */

        /* Méthodes */
        void print() const;
};

#endif