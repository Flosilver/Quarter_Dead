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
        int roles[NB_ROLES_JOUABLES] = {role_t::Acrobate, role_t::Cordonnier, role_t::Healer, role_t::Homme_chat, role_t::Robot, role_t::Tank};

        std::vector<sp_Joueur> players = std::vector<sp_Joueur>(NB_J_MAX);  // list of 4 players


    public:
        Quarter_Dead();
        ~Quarter_Dead();

        /* Accesseurs */
        const Map& getEtage(int i) const;
        const sp_Joueur getPlayer(int dir) const;

        /* Methodes */
        void generateMaze();
        const std::string mapMess(int etage) const;
        const bool& isConnected(int dir) const;
        void connect(int dir);
        void disconnect(int dir);

        /* Methodes de Game */
        void handleIncomingMessage();

};

#endif