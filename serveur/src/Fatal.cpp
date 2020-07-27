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

const int Fatal::activate(Joueur& j){
    
    // on ferme les portes vitrées de la salle
    closeVitre();

    j.receiveDMG(j.getHP());
    if (j.getRole() == role_t::Homme_chat){
        j.giveRole(role_t::Homme_chat2);
    }

    visited = true;
    return 1;   // il se passe qqchose
}