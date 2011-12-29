#!/usr/bin/tclsh

# Service configuration
set mysock(ip) 192.168.42.4
set mysock(port) 7000
set mysock(password) "tclpur"
set mysock(numeric) 42
set mysock(servername) "tcl.hebeo.fr"
set mysock(networkname) "Hebeo"
set mysock(hub) "irc1.hebeo.fr"

# Game controller
set mysock(nick) GameServer
set mysock(username) tclsh
set mysock(hostname) "tcl.hebeo.fr"
set mysock(realname) "TCL Game Server Controller"
set mysock(adminchan) "#Opers"
set mysock(chanlist) "#UNO #Poker #1000Bornes #Services"
set mysock(root) "Yume"
set mysock(cmdchar) "!"

# Partyline configuration
set mysock(plip) 192.168.42.4
set mysock(plport) 15000

# Internal variables
set mysock(version) "0.1"
set gameserver 0
if {[info exists pl]} {
  puts "La PL est déjà chargée."
} else {
  set pl 0
  set mysock(pl) ""
}
set numeric($mysock(numeric)) $mysock(servername)
#set mysock(sock) ""
#set mysock(sockpl) ""
#set mysock(server) "0"

