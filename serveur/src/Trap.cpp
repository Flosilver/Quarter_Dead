#include "Trap.hpp"

Trap::Trap(): Room(room_t::TRAP){
    dmg = 5 + rand() % 7;
    element = rand() % NB_ELEMENT;
}

Trap::Trap(int d): Room(room_t::TRAP){
    dmg = d;
    element = rand() % NB_ELEMENT;
}

Trap::Trap(const Trap& t): Room(room_t::TRAP){
    visited = t.visited;
    dmg = t.dmg;
    element = t.element;
}

Trap::~Trap(){}

Trap& Trap::operator=(const Trap& t){
    dmg = t.dmg;
    element = t.element;

    return *this;
}

const int& Trap::getDMG() const{
    return dmg;
}

const int& Trap::getElement() const{
    return element;
}

/* Methode called when a Joueur visite a Room*/
void Trap::activate(Joueur& j){
    int haz = 100;
    switch (j.getRole())
    {
        case role_t::Acrobate :
            haz = rand()%101;
            if (haz >= j.getAgility()){
                j.receiveDMG(dmg);
            }
            break;

        case role_t::Robot :
            if( element == element_t::Thunder ){
                j.receiveDMG(-dmg/2);
            }
            else if( element == element_t::Water ){
                j.receiveDMG(j.getHP());
            }
            else{
                j.receiveDMG(dmg);
            }

            break;

        case role_t::Homme_chat :
            if ( j.getHP() - dmg <= 0 ){
                j.giveRole(role_t::Homme_chat2);
            }
            else{
                j.receiveDMG(dmg);
            }

            break;
        
        default:
            j.receiveDMG(dmg);

            break;
    }
    
    visited = true;
}