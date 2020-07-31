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
                            maze[i][j][k] = make_shared<Trap>(Trap());
                        }
                        else{
                            maze[i][j][k] = make_shared<Room>(Room());
                        }
                        break;

                    case room_t::FATAL :
                        haz = rand() % 101;
                        if ( haz <= (i+1) * SEUIL_FATAL ){
                            maze[i][j][k] = make_shared<Fatal>(Fatal());
                        }
                        else{
                            maze[i][j][k] = make_shared<Room>(Room());
                        }
                        break;

                    case room_t::GOAL :
                        haz = rand() % 101;
                        if ( haz <= SEUIL_GOAL ){
                            maze[i][j][k] = make_shared<Goal>(Goal());
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
            maze[i][randj][randk] = make_shared<Goal>(Goal());
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

void Quarter_Dead::write_Connection_Mess(){
    // c<North_connected?><East_connected?><South_connected?><West_connected?>
    int cnx[NB_J_MAX];
    for ( int i=0 ; i<NB_J_MAX ; i++ ){
        cnx[i] = players[i]->isConnected() ? 1 : 0;
    }
    sprintf(mess, "c%d%d%d%d", cnx[0], cnx[1], cnx[2], cnx[3]);
}

void Quarter_Dead::write_Info_Update_Mess(int dir){
    // i<dir><etage><hp><nbChauss>
    sprintf(mess, "i %d %d %d %d", dir, players[dir]->getEtage(), players[dir]->getHP(), players[dir]->getNbChauss());
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
    sp_Room sp_room;
    shared_ptr<Trap> sp_trap;

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
                    //sprintf(mess, "c%d", dir);
                    write_Connection_Mess();
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
                    sprintf(mess, "j%d%d", NB_ETAGES, MAP_SIZE);
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

                        // premier envoie des infos
                        write_Info_Update_Mess(i);
                        sendBroadcast(mess);
                    }
                }
            }
            if (recMess[0]=='D'){
                cout << "--- Demande de déconnection" << endl;
				dir = recMess[1]-'0'; // ascii to int
                if (isConnected(dir))
				{
					disconnect(dir);
                    //sprintf(mess, "c%d", dir);
                    write_Connection_Mess();
                    sendBroadcast(mess);
				}
            }
            break;

        case GAME:
            dir = recMess[1]-'0'; // ascii to int
            pos = players[dir]->getPawnPosition();  // position du joueur qui demande l'action
            etage = players[dir]->getEtage();
            sp_room = maze[etage][pos.x][pos.y];
            //cout << "position du joueur: " << pos << endl;
            if (!players[dir]->isConnected()){
                break;
            }
            switch( recMess[0] ){

                // Demande d'ouverture de porte
                case 'O':
                    vise = recMess[2]-'0';                  // où vise le joueur pour son action

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

                    //cout << "position de la salle visée: " << vtemp << endl;

                    // salle inaccessible pour l'action
                    if (temp < 0 || temp >= MAP_SIZE || sp_room->isDoorOpen(vise)){
                        sprintf(mess, "on");
                        sendBroadcast(mess);
                    }
                    // salle accessible pour l'action
                    else{
                        sprintf(mess, "oy%d%d", dir, vise);
                        sendBroadcast(mess);

                        // ouverture de la porte visée
                        sp_room->openDoor(vise);
                        // ouverture de la porte correspondante dans la nouvelle salle
                        maze[etage][vtemp.x][vtemp.y]->openDoor((vise+2)%4);
                    }
                    break;

                // demande d'entrée dans une salle
                case 'E':
                    vise = recMess[2]-'0';                  // où vise le joueur pour son action

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

                    //cout << "position de la salle visée: " << vtemp << endl;

                    //deplacement impossible = indices impossibles / porte visée fermée / portes vitrées fermées
                    if (temp < 0 || temp >= MAP_SIZE || !sp_room->isDoorOpen(vise) || !sp_room->isVitreOpen() || !maze[etage][vtemp.x][vtemp.y]->isVitreOpen()){
                        sprintf(mess, "en");
                        sendBroadcast(mess);
                    }

                    // déplacement possible
                    else{
                        sprintf(mess, "ey%d%d", dir, vise);
                        sendBroadcast(mess);

                        // déplacement du joueur dans la salle visée
                        players[dir]->movePawnTo(vtemp);
                        //cout << "new pos: " << players[dir]->getPawnPosition() << endl;
                    }
                    break;
                
                // indique que le joueur est effectivement dans la salle où il est entrée
                case 'I':
                    // faire que le joueur visite la salle
                    cout << "le joueur visite la pièce" << "\ttype: " << sp_room->getType() << endl;
                    // la visite met à jour les données du joueur
                    switch (players[dir]->visite(sp_room)){
                        case 1: // TRAP ou FATAL non activé
                            cout << "c'est un piège" << endl;
                            
                            // on indique aux clients de fermer les portes vitrées
                            sprintf(mess, "vc%d%d%d", etage, pos.x, pos.y);
                            sendBroadcast(mess);

                            if ( sp_room->getType() == room_t::TRAP ){
                                // on cast pour récupérer l'élément du trap
                                sp_trap = dynamic_pointer_cast<Trap>(sp_room);

                                // on indique aux joueur qu'une trap a été activé
                                sprintf(mess, "t%d%d%d%d", etage, pos.x, pos.y, sp_trap->getElement());
                                sendBroadcast(mess);
                            }
                            else{
                                // on indique aux joueur qu'une fatal a été activé
                                sprintf(mess, "f%d%d%d%d", etage, pos.x, pos.y, rand()%2);
                                sendBroadcast(mess);
                            }

                            /*// Fatal + en vie -> resurection de l'Homme chat
                            if ( maze[etage][pos.x][pos.y]->getType() == room_t::FATAL && players[dir]->isAlive() ){
                                // message de resurection du joueur
                                sprintf(mess, "s%d", dir);
                                sendBroadcast(mess);
                                
                                // update des infos
                                write_Info_Update_Mess(dir);
                                sendBroadcast(mess);
                            }
                            // si le joueur a survécu au piège on update ses infos
                            else if ( players[dir]->isAlive() ){
                                // information sur l'élément du Trap pour adapter l'animation
                                sprintf(mess, "t%d%d", pos.x, pos.y);
                                sendBroadcast(mess);

                                // update des infos
                                write_Info_Update_Mess(dir);
                                sendBroadcast(mess);
                            }
                            // sinon on indique a tout le monde sa mort
                            else{
                                // toutes ses chaussures sont dispersées dans la salle
                                while (players[dir]->throwShoe(maze[etage][pos.x][pos.y]) && maze[etage][pos.x][pos.y]->getType() != room_t::FATAL){}   // les chaussures tombent dans la salle si celle-ci n'est pas Fatal
                                sprintf(mess, "m%d", dir);
                                sendBroadcast(mess);
                            }*/

                            break;
                        
                        case 2: // GOAL
                            cout << "le joueur à fini l'étage" << endl;

                            // on test si le joueur a fini le dernier étage
                            if ( etage+1 >= NB_ETAGES ){
                                // message de victoire
                                sprintf(mess, "w%d", dir);
                                sendBroadcast(mess);

                                // Changement d'état
                                setState(state_t::END);
                            }
                            // sinon, le joueur monte d'un niveau
                            else{
                                players[dir]->climb();

                                // message indiquant le changement d'étage d'un joueur
                                sprintf(mess, "a%d", dir);
                                sendBroadcast(mess);
                            }
                            break;
                        
                        default: // tout le reste
                            cout << "il ne se passe rien" << endl;
                            //players[dir]->pickUpShoe(maze[etage][pos.x][pos.y]);

                            // construction du message
                            write_Info_Update_Mess(dir);
                            sendBroadcast(mess);
                            break;
                    }
                    

                    // créer le message avec les updates de hp, chaussure, etc...
                    break;
                
                case 'R':   // le jeux indique que le joueur est libéré du piège
                    // on rouvre les portes vitrées de la pièce dans laquelle le joueur est coincé
                    maze[etage][pos.x][pos.y]->openVitre();

                    // on envoie l'ordre de rouvrir les vitres coté client
                    sprintf(mess, "vo%d%d%d", etage, pos.x, pos.y);
                    sendBroadcast(mess);

                    // Fatal + en vie -> resurection de l'Homme chat
                    if ( maze[etage][pos.x][pos.y]->getType() == room_t::FATAL && players[dir]->isAlive() ){
                        // message de resurection du joueur
                        sprintf(mess, "s%d", dir);
                        sendBroadcast(mess);
                        
                        // update des infos
                        write_Info_Update_Mess(dir);
                        sendBroadcast(mess);
                    }
                    else if ( players[dir]->isAlive() ){
                        // update des infos
                        write_Info_Update_Mess(dir);
                        sendBroadcast(mess);
                    }
                    // sinon on indique a tout le monde sa mort
                    else{
                        // toutes ses chaussures sont dispersées dans la salle
                        while (players[dir]->throwShoe(maze[etage][pos.x][pos.y]) && maze[etage][pos.x][pos.y]->getType() != room_t::FATAL){}   // les chaussures tombent dans la salle si celle-ci n'est pas Fatal
                        sprintf(mess, "m%d", dir);
                        sendBroadcast(mess);
                    }

                    break;
                
                case 'D':   // un joueur est mort et se déconnecte
                    cout << "--- Demande de déconnection" << endl;
                    dir = recMess[1]-'0'; // ascii to int
                    if (isConnected(dir))
                    {
                        disconnect(dir);
                    }
                    break;
                
                default:
                    cerr << "***ERROR : state=GAME : unknown command" << endl;
                    break;
            }
            break;

        case END:
            cout << "--- fin du jeu ---" << endl;
            for (int i=0 ; i<NB_J_MAX ; i++){
                disconnect(i);
            }
            setState(state_t::CONNECTION);
            break;

        default:

            break;
    }
}