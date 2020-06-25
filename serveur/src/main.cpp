#include "Quarter_Dead.hpp"

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

    Trap t1;
    cout << "t1: " << t1.getType() << " " << t1.getDMG() << " " << t1.getElement() << endl;
    Trap t2;
    Trap t3;
    Trap t4;
    Trap t5;
    cout << t1.getElement() << " " << t2.getElement() << " " << t3.getElement() << " " << t4.getElement() << " " << t5.getElement() << endl;


    //rsc::Game::initialize_server();
    Quarter_Dead game;
    cout << "game created" << endl;
    game.generateMaze();
    cout << "map generated" << endl;
    for (int i=0 ; i<NB_ETAGES ; i++){
        game.getEtage(i).print();
    }
}