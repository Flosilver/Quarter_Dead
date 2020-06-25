#include <Rosace.hpp>
#include <iostream>
#include <memory>

#include "config.hpp"
#include "Map.hpp"
#include "Room.hpp"
#include "Trap.hpp"
#include "Fatal.hpp"
#include "Goal.hpp"
#include "Joueur.hpp"

using namespace std;

int main (){
    srand(time(0));
    cout << "\n\n\n____________________________________________________________________________________" << endl;
    cout << "North: " << rsc::North << "\tEast: " << rsc::East << "\tSouth: " << rsc::South << "\tWest: " << rsc::West << endl;

    Map m1;
    m1.print();

    Map m2(MAP_SIZE);
    m2.print();

    cout << "\n room [1][1] : type=" << m2[1][1]->getType() << endl;
    m2[1][1] = make_shared<Room>(Trap(5));
    cout << "\n room [1][1] : type=" << m2[1][1]->getType() << endl;
}