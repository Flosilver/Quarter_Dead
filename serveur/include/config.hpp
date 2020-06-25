#ifndef CONFIG_HPP
#define CONFIG_HPP

#include <iostream>
#include <memory>
#include <cstdlib>
#include <ctime>
#include <vector>
#include <list>
#include <set>

#include <Rosace.hpp>

//#include "Room.hpp"
class Room;

using namespace std;

enum role_t{Acrobate, Cordonnier, Devin, Healer, Homme_chat, Homme_chat2, Robot, Tank};
#define NB_ROLES 8
enum room_t{ROOM, TRAP, FATAL, DEVIN, TREASURE, GOAL};
#define NB_ROOMS 6
enum element_t{None, Fire, Water, Thunder, Wind};
typedef shared_ptr<Room> sp_Room;

typedef shared_ptr<Room> sp_Room;
typedef vector<sp_Room> vsp_Room;
typedef vector<vsp_Room> map_t;

#define HP_S 10
#define HP_M 20
#define HP_L 30

#define NB_ELEMENT 5

#define MAP_SIZE 5
#define NB_ETAGES 3

#endif