#ifndef TRAP_HPP
#define TRAP_HPP

#include "Room.hpp"

class Trap : public Room
{
    protected:
        int dmg;

    public:
        Trap();
        Trap(int d);
        Trap(const Trap& t);
        ~Trap();

        /* Operator */
        Trap& operator=(const Trap& t);

        /* Accesseurs */

        /* Methodes */
        void visite();
};

#endif