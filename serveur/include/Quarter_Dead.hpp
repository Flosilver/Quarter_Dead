#ifndef QUARTER_DEAD_HPP
#define QUARTER_DEAD_HPP

#include "config.hpp"
#include "Joueur.hpp"
#include "Map.hpp"
#include "Room.hpp"
#include "Trap.hpp"
#include "Fatal.hpp"
#include "Goal.hpp"

enum state_t{CONNECTION, GAME, END};

class Quarter_Dead : public rsc::Game
{
    protected:
        Map maze[NB_ETAGES];
        Vect2i spawns[NB_ETAGES];

    public:
        Quarter_Dead();
        ~Quarter_Dead();

        /* Accesseurs */
        const Map& getEtage(int i) const;

        /* Methodes */
        void generateMaze();

        /* Methodes de Game */
        void handleIncomingMessage();

};

#endif