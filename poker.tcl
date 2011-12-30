#!/usr/bin/tclsh

# Parametres pour le jeu Poker
set mysock(poker-nick) "Poker"
set mysock(poker-username) "poker"
set mysock(poker-hostname) "poker.$mysock(hostname)"
set mysock(poker-realname) "Bot de jeu Poker"
set mysock(poker-chan) "#Poker"
lappend mysock(gamelist) "poker"
nodouble $mysock(gamelist)

