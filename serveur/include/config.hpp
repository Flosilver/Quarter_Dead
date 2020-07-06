#ifndef CONFIG_HPP
#define CONFIG_HPP

#include <iostream>
#include <memory>
#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <vector>
#include <list>
#include <set>
#include <thread>

#include <Rosace.hpp>

//#include "Room.hpp"
class Room;
class Joueur;

using namespace std;

enum role_t{Acrobate, Cordonnier, Devin, Healer, Homme_chat, Homme_chat2, Robot, Tank};
#define NB_ROLES 8
#define NB_ROLES_JOUABLES 6
enum room_t{ROOM, TRAP, FATAL, DEVIN, TREASURE, GOAL};
#define NB_ROOMS 6
enum element_t{None, Fire, Water, Thunder, Wind};

typedef shared_ptr<Room> sp_Room;
typedef vector<sp_Room> vsp_Room;
typedef vector<vsp_Room> map_t;

#define HP_S 10
#define HP_M 20
#define HP_L 30

#define NB_ELEMENT 5

#define MAP_SIZE 5
#define NB_ETAGES 3

#define SEUIL_TRAP 75
#define SEUIL_FATAL 25
#define SEUIL_GOAL 20

#define SERVER_PORT 4242

#endif