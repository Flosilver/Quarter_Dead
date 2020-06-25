#ifndef TRAP_HPP
#define TRAP_HPP

#include "config.hpp"
#include "Room.hpp"
#include "Joueur.hpp"

/* Trap is Room of type 1 */
class Trap : public Room
{
    protected:
        int dmg;
        int element;

    public:
        Trap();
        Trap(int d);
        Trap(const Trap& t);
        ~Trap();

        /* Operator */
        Trap& operator=(const Trap& t);

        /* Accesseurs */
        const int& getDMG() const;
        const int& getElement() const;

        /* Methodes */
        void activate(Joueur& j);
};

#endif