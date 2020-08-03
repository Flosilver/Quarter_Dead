#include "Trap.hpp"

Trap::Trap(): Room(room_t::TRAP){
    dmg = 5 + rand()%7;
    element = rand() % NB_ELEMENT;
    cout << "dmg: " << dmg << "\telement: " << element << endl;
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
const int Trap::activate(Joueur& j){
    int haz = 100;

    cout << "degats: " << dmg << endl;

    // on ferme les portes vitrées de la salle
    closeVitre();

    switch (j.getRole())
    {
        case role_t::Acrobate :
            // test d'esquive de l'acrobate
            haz = rand()%101;
            if (haz >= j.getAgility()){
                // test échoué
                j.receiveDMG(dmg);
            }
            break;

        case role_t::Robot :
            // robot se fait soigné par l'éléctricité
            if( element == element_t::Thunder ){
                j.receiveDMG(-dmg/2);
            }
            // robot se fait one-shot par l'eau
            else if( element == element_t::Water ){
                j.receiveDMG(j.getHP());
            }
            // dans les autres cas le robots prends les dégats normaux
            else{
                j.receiveDMG(dmg);
            }

            break;

        case role_t::Homme_chat :
            // si l'attaque devait tuer, l'homme-chat renait
            if ( j.getHP() - dmg <= 0 ){
                j.giveRole(role_t::Homme_chat2);
            }
            // sinon il prend les dégats
            else{
                j.receiveDMG(dmg);
            }

            break;
        
        default:
            // dans tous les autres cas, le joueur prend les dégats de la room
            j.receiveDMG(dmg);

            break;
    }
    
    visited = true;
    return 1;   // il se passe qqchose
}

const int Trap::trigger(){
    if (!visited){
        closeVitre();
        visited = true;
        return 1;   // il se passe qqchose
    }
    return 0;
}