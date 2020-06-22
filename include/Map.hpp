#ifndef MAP_HPP
#define MAP_HPP

#include <memory>
#include <Rosace.hpp>

#include "Room.hpp"

using namespace std;

typedef shared_ptr<Room> sp_Room;
typedef sp_Room** Map_t;

class Map
{
    protected:
        Map_t map;
        rsc::Vect2i size;

    public:
        Map();
        Map(size_t s);
        Map(const Map& m);
        ~Map();

        Map& operator=(const Map& m);

};

#endif