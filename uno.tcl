#!/usr/bin/tclsh

# Parametres pour le jeu UNO
set mysock(uno-nick) "UNO"
set mysock(uno-username) "uno"
set mysock(uno-hostname) "uno.$mysock(hostname)"
set mysock(uno-realname) "Bot de jeu UNO"
set mysock(uno-chan) "#UNO"
lappend mysock(gamelist) "uno"
nodouble $mysock(gamelist)

