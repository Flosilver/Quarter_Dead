#include "Joueur.hpp"

Joueur::Joueur(): rsc::Player()
{
    hp = 0;
    agility = 0;
    role = -1;
    etage = 0;

    nbChauss = 2;
    nbMaxChauss = 2;
    nbMediKit = 0;

    pawn = Pawn_2i(Vect2i(-1,-1));
}

Joueur::Joueur(int aDir): rsc::Player(aDir){
    hp = 0;
    agility = 0;
    role = -1;
    etage = 0;

    nbChauss = 2;
    nbMaxChauss = 2;
    nbMediKit = 0;
}

Joueur::~Joueur(){}

Joueur& Joueur::operator=(const Joueur& j){
    dir = j.dir;

    hp = j.hp;
    agility = j.agility;
    role = j.role;
    etage = j.etage;

    nbChauss = j.nbChauss;
    nbMaxChauss = j.nbMaxChauss;
    nbMediKit = j.nbMediKit;

    return *this;
}

const int& Joueur::getHP() const{
    return hp;
}

const int& Joueur::getAgility() const{
    return agility;
}

const int& Joueur::getRole() const{
    return role;
}

const bool Joueur::isAlive() const{
    return hp > 0;
}

const Vect2i& Joueur::getPawnPosition() const{
    return pawn.getPosition();
}

const int& Joueur::getNbChauss() const{
    return nbChauss;
}

const int& Joueur::getEtage() const{
    return etage;
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
            nbMaxChauss = 50;

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
            nbMaxChauss = 1;

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

const int Joueur::visite(sp_Room& spr){
    // le joueur récupère autant de chaussure que possible dans la salle
    while( pickUpShoe(spr) ){}

    // on active la salle si celle-ci n'a pas déjà été visitée
    if ( !spr->isVisited() ){
        cout << "test inside: " << spr->getType() << endl;
        return spr->activate(*this);
    }
    return 0;   // il ne se passe rien

    /*if (role == role_t::Devin){
        if (spr->getType() == room_t::DEVIN){
            // SHIT TODO
        }
    }*/
}

const bool Joueur::throwShoe(sp_Room& spr){
    if (nbChauss > 0){
        nbChauss--;
        spr->receiveShoe();
        return true;
    }
    return false;
}

const bool Joueur::pickUpShoe(sp_Room& spr){
    if ( spr->hasShoe() && ((nbChauss + 1) <= nbMaxChauss) ){
        spr->giveShoe();
        nbChauss++;
        return true;
    }
    return false;
}

void Joueur::climb(){
    etage++;
}

void Joueur::movePawn(const Vect2i& v){
    pawn.move(v);
}

void Joueur::movePawnTo(const Vect2i& v){
    pawn.moveTo(v);
}