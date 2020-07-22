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

const bool Room::isVitreOpen(int dir) const{
    if (dir<0 || dir>3){
        return false;
    }
    return portes[dir];
}

/* Methode called when a Joueur visite a Room*/
const int Room::activate(Joueur& j){
    visited = true;
    return 0;   // il ne se passe rien
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
    else{
        cerr << "***ERROR: Room::openDoor(int dir) : wrong argument" << endl;
    }
}

void Room::closeVitre(int dir){
    if ( dir >= 0 && dir <= 3){
        vitres[dir] = false;
    }
    else{
        cerr << "***ERROR: Room::closeVitre(int dir) : wrong argument" << endl;
    }
}

void Room::openVitre(int dir){
    if ( dir >= 0 && dir <= 3){
        vitres[dir] = true;
    }
    else{
        cerr << "***ERROR: Room::openVitre(int dir) : wrong argument" << endl;
    }
}