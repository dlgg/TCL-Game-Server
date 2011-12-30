#!/usr/bin/tclsh

# Parametres pour le jeu UNO
set mysock(uno-nick) "UNO"
set mysock(uno-username) "uno"
set mysock(uno-hostname) "uno.$mysock(hostname)"
set mysock(uno-realname) "Bot de jeu UNO"
set mysock(uno-chan) "#UNO"

# Don't modify this
lappend mysock(gamelist) "uno"
set mysock(proc-[string tolower $mysock(uno-chan)]) "uno_control_pub"
set mysock(proc-[string tolower $mysock(uno-nick)]) "uno_control_priv"
nodouble $mysock(gamelist)
set mysock(users-$mysock(uno-chan)) ""

proc uno_control_pub { nick text } {
  global mysock
  fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $mysock(uno-chan) :\002PUB \002 $nick > [join $text]"
}

proc uno_control_priv { nick text } {
  global mysock
  fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $mysock(uno-chan) :\002PRIV\002 $nick > [join $text]"
}
