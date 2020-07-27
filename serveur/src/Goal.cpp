#include "Goal.hpp"

Goal::Goal(): Room(room_t::GOAL){

    for (int i=0 ; i<NB_J_MAX ; i++){
        test_visited[i] = false;
    }
}

Goal::Goal(const Goal& g): Room(room_t::GOAL){
    visited = g.visited;
    for (int i=0 ; i<NB_J_MAX ; i++){
        test_visited[i] = g.test_visited[i];
    }
}

Goal::~Goal(){}

Goal& Goal::operator=(const Goal& g){
    visited = g.visited;
    for (int i=0 ; i<NB_J_MAX ; i++){
        test_visited[i] = g.test_visited[i];
    }

    return *(this);
}

const int Goal::activate(Joueur& j){
    test_visited[j.getDir()] = true;
    return 2;   // le joueur a fini l'étage
}