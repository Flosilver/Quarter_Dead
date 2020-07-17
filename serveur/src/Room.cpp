#include "Room.hpp"

Room::Room(){
    type = room_t::ROOM;
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

const bool Room::isDoorOpened(int dir) const{
    if (dir<0 || dir>3){
        return false;
    }
    return portes[dir];
}

/* Methode called when a Joueur visite a Room*/
void Room::activate(Joueur& j){
    visited = true;
}

void Room::receiveShoe(){
    nbChauss++;
}

const bool Room::giveShoe(){
    if(nbChauss > 0){
        nbChauss--;
        return true;
    }
    return false;
}

void Room::openDoor(int dir){
    if ( dir >= 0 && dir <= 3){
        portes[dir] = true;
    }
}