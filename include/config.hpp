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

#include "Room.hpp"

using namespace std;

enum role_t{Acrobate, Cordonnier, Devin, Healer, Homme_chat, Homme_chat2, Robot, Tank};
enum room_t{ROOM, TRAP, FATAL, DEVIN, TREASURE, GOAL};
enum element_t{None, Fire, Water, Thunder, Wind};
typedef shared_ptr<Room> sp_Room;

typedef shared_ptr<Room> sp_Room;
typedef vector<sp_Room> vsp_Room;
typedef vector<vsp_Room> map_t;

#define HP_S 10
#define HP_M 20
#define HP_L 30

#define NB_ELEM 5



#endif