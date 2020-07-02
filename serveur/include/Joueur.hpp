#ifndef JOUEUR_HPP
#define JOUEUR_HPP

#include "config.hpp"
#include "Room.hpp"

using namespace rsc;

class Joueur : public Player
{
    protected:
        int hp;
        int agility;
        int role;

        int nbChauss;
        int nbMaxChauss;
        int nbMediKit;

        Pawn_2i pawn;

    public:
        Joueur();
        Joueur(int aDir);
        ~Joueur();

        /* Operator */
        Joueur& operator=(const Joueur& j);

        /* Accesseurs */
        const int& getHP() const;
        const int& getAgility() const;
        const int& getRole() const;
        const bool isAlive() const;

        /* Methodes */
        void receiveDMG(int dmg);
        void giveRole(int r);
        void visite(sp_Room& spr);
        const bool throwShoe(sp_Room& spr);
        const bool pickUpShoe(sp_Room& spr);

        void movePawn(const Vect2i& v);
        void movePawnTo(const Vect2i& v);
};

typedef std::shared_ptr<Joueur> sp_Joueur;

#endif