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
    //srand(time(0));
    cout << "\n\n\n____________________________________________________________________________________" << endl;

    rsc::Game::initialize_server();
    Quarter_Dead game;
    game.launch(SERVER_PORT);

    int input = '\0';

    thread kbe(kb_event, &input);
    kbe.detach();

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
    }

    return 0;
}