#ifndef JOUEUR_HPP
#define JOUEUR_HPP

#include "config.hpp"

using namespace rsc;

class Joueur : public Player
{
    protected:
        int hp;
        int agility;
        int role;

        int nbChauss;
        int nbMediKit;

    public:
        Joueur();
        Joueur(std::string n, int aDir);
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
};

#endif