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
    cout << "c'est un Fatal" << endl;
    
    // on ferme les portes vitrées de la salle
    for (int i = 0 ; i<4 ; i++){
        closeVitre(i);
    }

    j.receiveDMG(j.getHP());
    if (j.getRole() == role_t::Homme_chat){
        j.giveRole(role_t::Homme_chat2);
    }

    visited = true;
    return 1;   // il se passe qqchose
}