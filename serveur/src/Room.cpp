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

const bool Room::isDoorOpen(int dir) const{
    if (dir<0 || dir>3){
        return false;
    }
    return portes[dir];
}

const bool Room::isVitreOpen() const{
    return vitres;
}

const bool Room::hasShoe() const{
    return nbChauss > 0;
}

/* Methode called when a Joueur visite a Room*/
const int Room::activate(Joueur& j){
    return trigger();
}

const int Room::trigger(){
    visited = true;
    return 0;   // il ne se passe rien
}

void Room::receiveShoe(){
    nbChauss++;
}

void Room::giveShoe(){
    if(nbChauss > 0){
        nbChauss--;
    }
    else{
        cerr << "***ERROR: Room::giveShoe() : not supposed to be called" << endl;
    }
}

void Room::openDoor(int dir){
    if ( dir >= 0 && dir <= 3){
        portes[dir] = true;
    }
    else{
        cerr << "***ERROR: Room::openDoor(int dir) : wrong argument" << endl;
    }
}

void Room::closeVitre(){
    vitres = false;
}

void Room::openVitre(){
    vitres = true;
}