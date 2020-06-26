#include "Quarter_Dead.hpp"

Quarter_Dead::Quarter_Dead(): rsc::Game(){
    
}

Quarter_Dead::~Quarter_Dead(){
    //cout << "\t*** dest QD" << endl;
}

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
        vGoal = Vect2i(-1, -1);

        maze[i] = Map(MAP_SIZE);

        /* Création de l'étage i */
        for (int j=0 ; j<MAP_SIZE ; j++){
            for (int k=0 ; k<MAP_SIZE ; k++){
                /* On tire au sort la room à la position [j, k] de l'étage i */
                do{
                    haz = rand() % NB_ROOMS;
                }while( (haz == room_t::GOAL && goal) || haz == room_t::DEVIN || haz == room_t::TREASURE);  // on evite de créer une salle de Devin car ce n'est pas du tout géré mdr et on ne créer qu'1 sortie
                //cout << "je quitte le while" << endl;
                switch (haz)
                {
                    case room_t::ROOM :
                        maze[i][j][k] = make_shared<Room>(Room());
                        break;

                    case room_t::TRAP :
                        haz = rand() % 101;
                        if ( haz <= (i+1) * SEUIL_TRAP){
                            maze[i][j][k] = make_shared<Room>(Trap());
                        }
                        else{
                            maze[i][j][k] = make_shared<Room>(Room());
                        }
                        break;

                    case room_t::FATAL :
                        haz = rand() % 101;
                        if ( haz <= (i+1) * SEUIL_FATAL ){
                            maze[i][j][k] = make_shared<Room>(Fatal());
                        }
                        else{
                            maze[i][j][k] = make_shared<Room>(Room());
                        }
                        break;

                    case room_t::GOAL :
                        haz = rand() % 101;
                        if ( haz <= (i+1) * SEUIL_GOAL ){
                            maze[i][j][k] = make_shared<Room>(Goal());
                            vGoal = Vect2i(j,k);
                            goal = true;
                        }
                        else{
                            maze[i][j][k] = make_shared<Room>(Room());
                        }
                        break;                  
                    
                    default:
                        maze[i][j][k] = make_shared<Room>(Room());
                        break;
                }
            }
        }
        cout << "toutes les rooms sont prêtes" << endl;
        cout << "Goal etage " << i << ": " << vGoal << endl;

        if ( vGoal.x == -1 || vGoal.y == -1 ){
            cout << "placement aléatoire du goal" << endl;
            int randj = rand() % MAP_SIZE;
            int randk = rand() % MAP_SIZE;
            maze[i][randj][randk] = make_shared<Room>(Goal());
            vGoal = Vect2i(randj, randk);
            cout << "Goal placé en: " << vGoal << endl;
        }

        /* placement du spawn de l'étage i */
        int test = spawns[i].x - vGoal.x < 0 ? -(spawns[i].x - vGoal.x) : spawns[i].x - vGoal.x;
        cout << "test: " << test << endl;
        do{
            spawns[i].x = (spawns[i].x + (rand()%MAP_SIZE)) % MAP_SIZE;
            test = spawns[i].x - vGoal.x < 0 ? -(spawns[i].x - vGoal.x) : spawns[i].x - vGoal.x;
        }while (test < MAP_SIZE/2);
        cout << "test: " << test << endl;
        test = spawns[i].y - vGoal.y < 0 ? -(spawns[i].y - vGoal.y) : spawns[i].y - vGoal.y;
        cout << "test: " << test << endl;
        do{
            spawns[i].y = (spawns[i].y + (rand()%MAP_SIZE)) % MAP_SIZE;
            test = spawns[i].y - vGoal.y < 0 ? -(spawns[i].y - vGoal.y) : spawns[i].y - vGoal.y;
        }while (test < MAP_SIZE/2);
        cout << "test: " << test << endl;
        cout << "spawn étage i: " << spawns[i] << endl;
        maze[i][spawns[i].x][spawns[i].y] = make_shared<Room>(Room());
    }
    cout << "done" << endl;
}

void Quarter_Dead::handleIncomingMessage(){
    // TODO
}