#include "Fatal.hpp"

Fatal::Fatal(): Room(room_t::FATAL){}

Fatal::Fatal(const Fatal& f): Room(room_t::FATAL){
    visited = f.visited;
}

Fatal::~Fatal(){}

Fatal& Fatal::operator=(const Fatal& f){
    visited = f.visited;

    return *this;
}

void Fatal::activate(Joueur& j){
    j.receiveDMG(j.getHP());
}