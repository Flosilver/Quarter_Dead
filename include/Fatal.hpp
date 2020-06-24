#ifndef FATAL_HPP
#define FATAL_HPP

#include "config.hpp"

class Fatal : public Room
{
    public:
        Fatal();
        Fatal(const Fatal& f);
        ~Fatal();

        /* Operators */
        Fatal& operator=(const Fatal& f);

        /* Methodes */
        void activate(Joueur& j);
};

#endif