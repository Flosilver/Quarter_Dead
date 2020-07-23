#ifndef ROOM_HPP
#define ROOM_HPP

#include <Rosace.hpp>
#include "config.hpp"

class Joueur;

class Room
{
    protected:
        int type;
        bool visited = false;
        bool portes[4] = {false, false, false, false};
        bool vitres[4] = {true, true, true, true};

        int nbChauss = 0;

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
        const bool isDoorOpen(int dir) const;
        const bool isVitreOpen(int dir) const;
        const bool hasShoe() const;

        /* Methodes */
        const int activate(Joueur& j);
        void receiveShoe();
        void giveShoe();
        void openDoor(int dir);
        void closeVitre(int dir);
        void openVitre(int dir);

};


#endif