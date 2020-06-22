#include "Map.hpp"

using namespace std;

Map::Map(){
    size = rsc::Vect2i();
    map = nullptr;
}

Map::Map(size_t s){
    map = new sp_Room*[s];

    for (int i=0 ; i<s ; i++){
        map[i] = new sp_Room[s];
    }
}