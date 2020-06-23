#ifndef MAP_HPP
#define MAP_HPP

#include <memory>
#include <vector>
#include <Rosace.hpp>

#include "Room.hpp"

using namespace std;

typedef shared_ptr<Room> sp_Room;
typedef vector<sp_Room> vsp_Room;
typedef vector<vsp_Room> map_t;

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

        /* Accesseurs */

        /* Méthodes */
        void print() const;
};

#endif