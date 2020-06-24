#ifndef ROOM_HPP
#define ROOM_HPP

#include <Rosace.hpp>

#include "Joueur.hpp"

class Room
{
    protected:
        int type;
        bool visited = false;

        Room(int t);    // reserved for constructors of classes which herits from Room

    public:
        Room();
        Room(const Room& r);
        ~Room();

        /* Opérators */
        Room& operator=(const Room& r);

        /* Accesseurs */
        const int& getType() const;
        const bool& isVisited() const;

        /* Methodes */
        void activate(Joueur& j);
};


#endif