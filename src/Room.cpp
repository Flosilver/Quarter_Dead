#include "Room.hpp"

Room::Room(){
    type = 0;
}

Room::Room(int t){
    type = t;
}

Room::Room(const Room& r){
    type = r.type;
    visited = r.visited;
}

Room::~Room(){}

Room& Room::operator=(const Room& r){
    type = r.type;
    visited = r.visited;

    return *this;
}

const int& Room::getType() const{
    return type;
}

const bool& Room::isVisited() const{
    return visited;
}