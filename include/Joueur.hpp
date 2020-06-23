#ifndef JOUEUR_HPP
#define JOUEUR_HPP

#include <Rosace.hpp>

using namespace rsc;

class Joueur : public Player
{
    protected:
        int hp;
        int agility;

    public:
        Joueur();
        Joueur(std::string n, int aDir, int aHp);
        Joueur(const Joueur& j);
        ~Joueur();

        /* Operator */
        Joueur& operator=(const Joueur& j);

        /* Accesseurs */
        const int& getHP() const;

        /* Methodes */
        void inflictDMG(int dmg);
};

#endif