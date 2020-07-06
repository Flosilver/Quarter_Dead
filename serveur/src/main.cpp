#include "Quarter_Dead.hpp"

using namespace std;

void kb_event(int* in){
    cout << "thread created" << endl;
    while (in != nullptr){
        //cout << "thread en cours" << endl;
        *in = getchar();
    }
    exit(EXIT_SUCCESS);
}

int main (){
    srand(time(0));
    cout << "\n\n\n____________________________________________________________________________________" << endl;

    rsc::Game::initialize_server();
    Quarter_Dead game;
    game.launch(SERVER_PORT);

    int input = '\0';

    thread kbe(kb_event, &input);
    kbe.detach();

    /* tests */
    /*cout << "---game created" << endl;
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

    cout << endl;
    string mess1 = game.mapMess(0);
    cout << mess1 << endl;

    char mess[256];
    sprintf(mess, "g%d%s", 1, game.mapMess(1).c_str());
    cout << mess << endl;

    sp_Joueur spj = game.getPlayer(1);
    cout << spj->getDir() << " " << spj->getRole() << endl;
    spj->giveRole(3);
    cout << spj->getRole() << endl;*/

    /* suite du vrai main */
    while (input!='q' && input!='Q')
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
                    break;
                case ENET_EVENT_TYPE_NONE:
                    break;
                
            }
        }
        // TODO: méthode pour quitter proprement la boucle
    }
    //atexit (enet_deinitialize);

    return 0;
}