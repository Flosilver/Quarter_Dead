#ifndef GOAL_HPP
#define GOAL_HPP

#include "config.hpp"
#include "Room.hpp"
#include "Joueur.hpp"

class Goal : public Room
{
    protected:
    bool test_visited[NB_J_MAX];

    public:
        Goal();
        Goal(const Goal& g);
        ~Goal();

        /* Operators */
        Goal& operator=(const Goal& g);

        /* Accesseurs */

        /* Methodes */
        void activate(Joueur& j);        
};

#endif