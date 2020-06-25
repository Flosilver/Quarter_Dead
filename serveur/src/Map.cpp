#include "Map.hpp"

using namespace std;

Map::Map(){
    size = 0;
}

Map::Map(size_t s){
    size = s;

    map = map_t(s);
    for (size_t i=0 ; i<s ; i++){
        map[i] = vsp_Room(s);
        for (size_t j=0 ; j<s ; j++){
            map[i][j] = make_shared<Room>();
        }
    }
}

Map::Map(const Map& m){
    *(this) = m;
}

Map::~Map(){
    for (size_t i=0 ; i<size ; i++){
        map[i].clear();
    }
    map.clear();
}

Map& Map::operator=(const Map& m){
    for (size_t i=0 ; i<size ; i++){
        map[i].clear();
    }
    map.clear();

    size = m.size;
    map = map_t(size);
    for (size_t i=0 ; i<size ; i++){
        map[i] = vsp_Room(size);
        for (size_t j=0 ; j<size ; j++){
            map[i][j] = make_shared<Room>(Room(*(m.map[i][j])));
        }
    }

    return *this;
}

vsp_Room& Map::operator[](size_t i){
    return map[i];
}

void Map::print() const{
    cout << "\nMap:\nsize: " << size << endl;
    for (size_t i=0 ; i<size ; i++){
        for (size_t j=0 ; j<size ; j++){
            cout << map[i][j]->getType() << "\t";
        }
        cout << endl;
    }
}