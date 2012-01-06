#!/usr/bin/tclsh

# Messages for base
::msgcat::mcset fr startserv "Démarrage des services."
::msgcat::mcset fr loadmodule "Chargement du module %s."
::msgcat::mcset fr loadgame "Chargement du jeu : %s."
::msgcat::mcset fr loadaddon "Chargement de l'addon pour le Master Bot : %s."
::msgcat::mcset fr filenotexist "Impossible de charger %s. Le fichier n'existe pas."

# Messages for controller
::msgcat::mcset fr cont_netconn "Connexion au réseau."
::msgcat::mcset fr cont_shutdown "Coupure des services démandée par %s."

# Messages for partyline
::msgcat::mcset fr pl_activation "Activation de la PL sur %s:%s."
::msgcat::mcset fr pl_openport "Ouverture du port PL : OK"
::msgcat::mcset fr pl_incconn "Arrivée d'une connexion Partyline."
::msgcat::mcset fr pl_activated "\00304\002PL activée :\002\003 %s > %d:%s:%d"
::msgcat::mcset fr pl_close "Fermeture du socket PL %s par l'utilisateur %s"
::msgcat::mcset fr pl_help0 "Aide de TCL GameService v%s"
::msgcat::mcset fr pl_help1 "Commandes partyline"
::msgcat::mcset fr pl_help2 "Ferme votre PL ou une PL donnée en paramètre"
::msgcat::mcset fr pl_help3 "Affiche la liste des personnes en PL"
::msgcat::mcset fr pl_help4 "Recharge le service"
::msgcat::mcset fr pl_help5 "Tue le service"
::msgcat::mcset fr pl_inpl "Présent en PL : %s"
::msgcat::mcset fr pl_inplauth "Présent en PL et authentifié : %s"
::msgcat::mcset fr pl_rehash "Rehash par la PL : %s"
::msgcat::mcset fr pl_die "Die par la PL : %s"
::msgcat::mcset fr pl_auth "Vous êtes authentifié !!!"
::msgcat::mcset fr pl_notauth "Vous n'êtes pas authentifié. Merci d'utiliser la commande .pass <password> pour vous authentifier."
::msgcat::mcset fr pl_loaded "Serveur de PartyLine chargé."
