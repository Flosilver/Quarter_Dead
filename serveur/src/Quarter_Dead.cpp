#include "Quarter_Dead.hpp"

Quarter_Dead::Quarter_Dead(): rsc::Game(){
    for (int i=0 ; i<NB_J_MAX ; i++){
        players[i] = make_shared<Joueur>(Joueur(i));
    }
    
    setState(CONNECTION);
}

Quarter_Dead::~Quarter_Dead(){
    players.clear();
    cout << "\t*** dest QD" << endl;
}

const Map& Quarter_Dead::getEtage(int i) const{
    /* anti abruti-man */
    if ( i < 0 ){
        return maze[0];
    }
    if ( i >= NB_ETAGES ){
        return maze[NB_ETAGES-1];
    }
    /* comportement logique */
    return maze[i];
}

const sp_Joueur Quarter_Dead::getPlayer(int dir) const {
    for (const sp_Joueur& spp : players){
		if (spp->getDir() == dir){
			return spp;
		}
	}
	return make_shared<Joueur>();
	// TODO: gestion d'erreur
}

void Quarter_Dead::generateMaze(){
    for (int i=0 ; i<NB_ETAGES ; i++){
        spawns[i] = Vect2i(MAP_SIZE/2, MAP_SIZE/2);
    }

    int haz;
    bool goal = false;
    Vect2i vGoal;
    for (int i=0 ; i<NB_ETAGES ; i++){
        //cout << "----\netage " << i << endl;
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
                        if ( haz <= SEUIL_GOAL ){
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
        //cout << "toutes les rooms sont prêtes" << endl;
        //cout << "Goal etage " << i << ": " << vGoal << endl;

        if ( vGoal.x == -1 || vGoal.y == -1 ){
            //cout << "placement aléatoire du goal" << endl;
            int randj = rand() % MAP_SIZE;
            int randk = rand() % MAP_SIZE;
            maze[i][randj][randk] = make_shared<Room>(Goal());
            vGoal = Vect2i(randj, randk);
            //cout << "Goal placé en: " << vGoal << endl;
        }

        /* placement du spawn de l'étage i */
        int test = spawns[i].x - vGoal.x < 0 ? -(spawns[i].x - vGoal.x) : spawns[i].x - vGoal.x;
        //cout << "test: " << test << endl;
        do{
            spawns[i].x = (spawns[i].x + (rand()%MAP_SIZE)) % MAP_SIZE;
            test = spawns[i].x - vGoal.x < 0 ? -(spawns[i].x - vGoal.x) : spawns[i].x - vGoal.x;
        }while (test < MAP_SIZE/2);
        //cout << "test: " << test << endl;
        test = spawns[i].y - vGoal.y < 0 ? -(spawns[i].y - vGoal.y) : spawns[i].y - vGoal.y;
        //cout << "test: " << test << endl;
        do{
            spawns[i].y = (spawns[i].y + (rand()%MAP_SIZE)) % MAP_SIZE;
            test = spawns[i].y - vGoal.y < 0 ? -(spawns[i].y - vGoal.y) : spawns[i].y - vGoal.y;
        }while (test < MAP_SIZE/2);
        //cout << "test: " << test << endl;
        //cout << "spawn étage i: " << spawns[i] << endl;
        maze[i][spawns[i].x][spawns[i].y] = make_shared<Room>(Room());
    }
    //cout << "done" << endl;
}

const std::string Quarter_Dead::mapMess(int etage) const{
    std::string res("");
    int temp;
    char ctemp[200];
    int* listR = getEtage(etage).getRoomList(); // new int[] -> delete[]
    for (int i=0 ; i<MAP_SIZE*MAP_SIZE ; i++){
        temp = listR[i];
        sprintf(ctemp,"%d",temp);
        res += string(ctemp);
    }
    delete[] listR;
    //const char* mess = res.c_str();
    //cout << mess << endl;
    return res;
}

const bool& Quarter_Dead::isConnected(int dir) const{
	return players[dir]->isConnected();
}

void Quarter_Dead::connect(int dir){
	players[dir]->login();
    nbConnectes++;
}

void Quarter_Dead::disconnect(int dir){
	players[dir]->logout();
    nbConnectes--;
}

void Quarter_Dead::handleIncomingMessage(){
    cout << "état actuel: " << state << endl;

    int dir = 0;        // direction du joueur qui envoie un message
    int haz = 0;        // variable de random
    int temp = 0;       // vairiable temporaire
    Vect2i pos;     // position du joueur envoyant un message
    Vect2i vtemp;   // vecteur 2d d'entiers temporaire
    int vise = 0;    // direction que vise le joueur envoyant un message pour son action
    int etage = 0;

    switch (state){
        case CONNECTION:
            // état initial, on attend que 4 joueurs soient connectés
			if (recMess[0]=='C')
			{
                cout << "--- Demande de connection" << endl;
				dir = recMess[1]-'0'; // ascii to int
				if (!isConnected(dir))
				{
					connect(dir);
                    sprintf(mess, "c%d", dir);
                    sendBroadcast(mess);
				}

				// Tout le monde est connecté, on envoie plein de choses
				// aux interfaces graphiques.
				// la map complète
                // le placement des joueurs en fonction de la génération
                // distribution des rôles
				if (nbConnectes==4)
				{
                    cout << "Tout le monde est là! On passe au jeu." << endl;
                    setState(GAME);
                    cout << "Passage à l'état de GAME" << endl;

                    // Envoie des infos sur le jeux
                    sprintf(mess, "m%d%d", NB_ETAGES, MAP_SIZE);
                    sendBroadcast(mess);

                    // Génération de la map
                    generateMaze();
                    maze[0].print();
                    cout << "spawn: " << spawns[0] << endl;

                    // Envoie des salles de chaque etage dans le code des joueurs
                    for (int i=0 ; i<NB_ETAGES ; i++){
                        sprintf(mess, "g%d%s", i, mapMess(i).c_str());
                        sendBroadcast(mess);                       
                    }

                    // Placement des pions coté serveur et envoie des position dde spawn coté client
                    sprintf(mess, "p%d%d", spawns[0].x, spawns[0].y);
                    sendBroadcast(mess);
                    for (int i=0 ; i<NB_J_MAX ; i++){
                        players[i]->movePawnTo(spawns[0]);
                    }

                    // Distribution des rôles
                    for (int i=0 ; i<NB_ROLES_JOUABLES ; i++){
                        // mélange des rôles avant distribution
                        haz = rand() % NB_ROLES_JOUABLES;
                        temp = roles[i];
                        roles[i] = roles[haz];
                        roles[haz] = temp;
                    }
                    sprintf(mess, "r%d%d%d%d",roles[0],roles[1],roles[2],roles[3]);
                    sendBroadcast(mess);
                    for (int i=0 ; i<NB_J_MAX ; i++){
                        players[i]->giveRole(roles[i]);
                    }
                }
            }
            break;

        case GAME:
            dir = recMess[1]-'0'; // ascii to int
            switch( recMess[0] ){
                // Demande d'ouverture de porte
                case 'O':
                    vise = recMess[2]-'0';                  // où vise le joueur pour son action
                    pos = players[dir]->getPawnPosition();  // position du joueur qui demande l'action
                    etage = recMess[3]-'0';

                    if (vise%2 == 0){
                        // position de la salle visée
                        vtemp.x = pos.x + mouvements[vise].x;
                        vtemp.y = pos.y;

                        // recupération de la coordonnée changeante
                        temp = vtemp.x;
                    }
                    else{
                        // position de la salle vise
                        vtemp.x = pos.x;
                        vtemp.y = pos.y + mouvements[vise].y;

                        // récupération de la coordonnée changeante
                        temp = vtemp.y;
                    }

                    // salle inaccessible pour l'action
                    if (temp < 0 || temp >= MAP_SIZE || maze[etage][pos.x][pos.y]->isDoorOpened(vise)){
                        sprintf(mess, "on");
                        sendBroadcast(mess);
                    }
                    // salle accessible pour l'action
                    else{
                        sprintf(mess, "oy%d%d", dir, vise);
                        sendBroadcast(mess);

                        // ouverture de la porte visée
                        maze[etage][pos.x][pos.y]->openDoor(vise);
                        // ouverture de la porte correspondante dans la nouvelle salle
                        maze[etage][vtemp.x][vtemp.y]->openDoor((vise+2)%4);
                    }
                    break;
                
                case 'E':
                    vise = recMess[2]-'0';                  // où vise le joueur pour son action
                    pos = players[dir]->getPawnPosition();  // position du joueur qui demande l'action
                    etage = recMess[3]-'0';                 // étage où se trouve le joueur

                    if (vise%2 == 0){
                        // position de la salle visée
                        vtemp.x = pos.x + mouvements[vise].x;
                        vtemp.y = pos.y;

                        // recupération de la coordonnée changeante
                        temp = vtemp.x;
                    }
                    else{
                        // position de la salle vise
                        vtemp.x = pos.x;
                        vtemp.y = pos.y + mouvements[vise].y;

                        // récupération de la coordonnée changeante
                        temp = vtemp.y;
                    }

                    //deplacement impossible
                    if (temp < 0 || temp >= MAP_SIZE || !maze[etage][pos.x][pos.y]->isDoorOpened(vise)){
                        sprintf(mess, "en");
                        sendBroadcast(mess);
                    }
                    // déplacement possible
                    else{
                        sprintf(mess, "ey%d%d", dir, vise);
                        sendBroadcast(mess);

                        // déplacement du joueur dans la salle visée
                        players[dir]->movePawnTo(vtemp);
                    }
                    break;
                
                case 'I':
                    pos = players[dir]->getPawnPosition();  // position du joueur qui demande l'action
                    etage = recMess[2]-'0';
                    break;
                
                default:
                    cerr << "***ERROR : state=GAME : unknown command" << endl;
                    break;
            }
            break;

        case END:

            break;

        default:

            break;
    }
}