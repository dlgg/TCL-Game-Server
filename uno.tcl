#!/usr/bin/tclsh

# Parametres pour le jeu UNO
set mysock(uno)(nick) "UNO"
set mysock(uno)(username) "uno"
set mysock(uno)(hostname) "uno.$mysock(hostname)"
set mysock(uno)(realname) "Bot de jeu UNO"
set mysock(uno)(chan) "#UNO"

# Initialisation du bot
bot_init $mysock(uno)(nick) $mysock(uno)(username) $mysock(uno)(hostname) $mysock(uno)(realname)
join_chan $mysock(uno)(chan)
