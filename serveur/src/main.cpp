#include "Quarter_Dead.hpp"

using namespace std;

int main (){
    srand(time(0));
    cout << "\n\n\n____________________________________________________________________________________" << endl;
    cout << "North: " << rsc::North << "\tEast: " << rsc::East << "\tSouth: " << rsc::South << "\tWest: " << rsc::West << endl;

    
    rsc::Game::initialize_server();
    Quarter_Dead game;
    game.launch(SERVER_PORT);
    cout << "---game created" << endl;
    game.generateMaze();
    cout << "---map generated" << endl;
    for (int i=0 ; i<NB_ETAGES ; i++){
        game.getEtage(i).print();
    }
    cout << "---printed" << endl;

    int* listRooms[NB_ELEMENT];
    for (int i=0 ; i<NB_ETAGES ; i++){
        listRooms[i] = game.getEtage(i).getRoomList();
    }
    for (int i=0 ; i<NB_ETAGES ; i++){
        for (int j = 0 ; j < MAP_SIZE*MAP_SIZE ; j++){
            cout << listRooms[i][j];
        }
        cout << endl;
    }

    for (int i=0 ; i<NB_ETAGES ; i++){
        delete[] listRooms[i];
    }

    /*while (1)
    {
            while (game.game_host_service() > 0)
            {
                switch (game.event.type)
                {
                    case ENET_EVENT_TYPE_CONNECT:
                            printf ("A new client connected from %x:%u.\n", game.event.peer -> address.host, game.event.peer -> address.port);
                            break;
                    case ENET_EVENT_TYPE_RECEIVE:
                            game.receive_event();
                            game.handleIncomingMessage();
                            break;
                    case ENET_EVENT_TYPE_DISCONNECT:
                            printf ("%s disconnected FPX.\n", (char*)game.event.peer -> data);
                            game.event.peer -> data = NULL;
                }
            }
            // TODO: méthode pour quitter proprement la boucle
    }*/

    atexit (enet_deinitialize);
    return 0;
}