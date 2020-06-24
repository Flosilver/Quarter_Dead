#include "Joueur.hpp"

Joueur::Joueur(): rsc::Player()
{
    nbChauss = 2;
    nbMediKit = 0;
}

Joueur::Joueur(std::string n, int aDir): rsc::Player(n, aDir){
    // TODO
}

Joueur::~Joueur(){}

Joueur& Joueur::operator=(const Joueur& j){
    name = j.name;
    dir = j.dir;

    hp = j.hp;
    agility = j.agility;
    role = j.role;

    return *this;
}

const int& Joueur::getHP() const{
    return hp;
}

const int& Joueur::getRole() const{
    return role;
}

const bool Joueur::isAlive() const{
    return hp <= 0;
}

void Joueur::receiveDMG(int dmg){
    hp -= dmg;
}

void Joueur::giveRole(int r){
    switch(r){
        case role_t::Acrobate :
            hp = HP_M;
            agility = 20;
            role = r;

            break;

        case role_t::Cordonnier :
            hp = HP_M;
            agility = 0;
            role = r;

            nbChauss += 2;

            break;

        /*case role_t::Devin :
            hp = HP_M;
            agility = 0;
            role = r;

            break;*/

        case role_t::Healer :
            hp = HP_M;
            agility = 0;
            role = r;

            nbMediKit += 2;

            break;

        case role_t::Homme_chat :
            hp = HP_S;
            agility = 0;
            role = r;

            break;

        case role_t::Homme_chat2 :
            hp = HP_S;
            agility = 0;
            role = r;

            break;

        case role_t::Robot :
            hp = HP_M;
            agility = 0;
            role = r;

            nbChauss -= 2;

            break;

        case role_t::Tank :
            hp = HP_L;
            agility = 0;
            role = r;

            nbChauss -= 2;

            break;

        default:
            cerr << "***ERROR: Joueur::giveRole(int r) : wrong argument, role unknown" << endl;
    }
}

void Joueur::visite(sp_Room& spr){
    if ( !spr->isVisited() ){
        spr->activate(*this);
    }

    /*if (role == role_t::Devin){
        if (spr->getType() == room_t::DEVIN){
            // SHIT TODO
        }
    }*/
}