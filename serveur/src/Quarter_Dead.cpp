#include "Quarter_Dead.hpp"

Quarter_Dead::Quarter_Dead(): rsc::Game(){
    
}

Quarter_Dead::~Quarter_Dead(){}

const Map& Quarter_Dead::getEtage(int i) const{
    if ( i < 0 ){
        return maze[0];
    }
    if ( i >= NB_ETAGES ){
        return maze[NB_ETAGES-1];
    }
    return maze[i];
}

void Quarter_Dead::generateMaze(){
    for (int i=0 ; i<NB_ETAGES ; i++){
        spawns[i] = Vect2i(MAP_SIZE/2, MAP_SIZE/2);
    }

    int haz;
    bool goal = false;
    Vect2i vGoal;
    for (int i=0 ; i<NB_ETAGES ; i++){
        cout << "----\netage " << i << endl;
        goal = false;

        maze[i] = Map(MAP_SIZE);

        /* Création de l'étage i */
        for (int j=0 ; j<MAP_SIZE ; j++){
            for (int k=0 ; k<MAP_SIZE ; k++){
                /* On tire au sort la room à la position [j, k] de l'étage i */
                do{
                    haz = rand() % NB_ROOMS;
                }while( (haz == room_t::GOAL && goal) );  // on evite de créer une salle de Devin car ce n'est pas du tout géré mdr et on ne créer qu'1 sortie
                //cout << "je quitte le while" << endl;
                switch (haz)
                {
                    case room_t::ROOM :
                        maze[i][j][k] = make_shared<Room>(Room());
                        break;

                    case room_t::TRAP : 
                        maze[i][j][k] = make_shared<Room>(Trap());
                        break;

                    case room_t::FATAL :
                        maze[i][j][k] = make_shared<Room>(Fatal());
                        break;

                    case room_t::GOAL :
                        maze[i][j][k] = make_shared<Room>(Goal());
                        vGoal = Vect2i(j,k);
                        goal = true;
                        break;                  
                    
                    default:
                        maze[i][j][k] = make_shared<Room>(Room());
                        break;
                }
            }
        }
        cout << "toutes les rooms sont prêtes" << endl;
        cout << "Goal etage " << i << ": " << vGoal << endl;

        /* placement du spawn de l'étage i */
        int test = spawns[i].x - vGoal.x < 0 ? -(spawns[i].x - vGoal.x) : spawns[i].x - vGoal.x;
        cout << "test: " << test << endl;
        while (test < 2){
            spawns[i].x = (spawns[i].x + 1) % MAP_SIZE;
            test = spawns[i].x - vGoal.x < 0 ? -(spawns[i].x - vGoal.x) : spawns[i].x - vGoal.x;
        }
        cout << "test: " << test << endl;
        test = spawns[i].y - vGoal.y < 0 ? -(spawns[i].y - vGoal.y) : spawns[i].y - vGoal.y;
        cout << "test: " << test << endl;
        while (test < 2){
            spawns[i].y = (spawns[i].y + 1) % MAP_SIZE;
            test = spawns[i].y - vGoal.y < 0 ? -(spawns[i].y - vGoal.y) : spawns[i].y - vGoal.y;
        }
        cout << "test: " << test << endl;
        cout << "spawn étage i: " << spawns[i] << endl;
    }
    cout << "done" << endl;
}

void Quarter_Dead::handleIncomingMessage(){
    // TODO
}