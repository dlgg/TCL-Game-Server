#!/usr/bin/tclsh

# Parametres pour le jeu Poker
set mysock(poker-nick) "Poker"
set mysock(poker-username) "poker"
set mysock(poker-hostname) "poker.$mysock(hostname)"
set mysock(poker-realname) "Bot de jeu Poker"
set mysock(poker-chan) "#Poker"

# Don't modify this
lappend mysock(gamelist) "poker"
nodouble $mysock(gamelist)
set mysock(users-$mysock(poker-chan)) ""
set mysock(proc-[string tolower $mysock(poker-chan)]) "poker_control_pub"
set mysock(proc-[string tolower $mysock(poker-nick)]) "poker_control_priv"

proc poker_control_pub { nick text } {
  global mysock
  fsend $mysock(sock) ":$mysock(poker-nick) PRIVMSG $mysock(poker-chan) :\002PUB \002 $nick > [join $text]"
}

proc poker_control_priv { nick text } {
  global mysock
  fsend $mysock(sock) ":$mysock(poker-nick) PRIVMSG $mysock(poker-chan) :\002PRIV\002 $nick > [join $text]"
}

