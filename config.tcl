#!/usr/bin/tclsh
##############################################################################
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the Licence, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# Product name :  TCL GameServer
# Copyright (C) 2011 Damien Lesgourgues
# Author(s): Damien Lesgourgues
#
##############################################################################
puts "Chargement des paramètres de configuration"

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
set mysock(plip) 192.168.42.2
set mysock(plport) 15000
set mysock(plpass) "password"

# Internal variables
set mysock(version) "0.1"
set mysock(proc-addon) ""
set gameserver 0
if {[info exists pl]} {
  puts "La PL est déjà chargée."
} else {
  set pl 0
  set mysock(pl) ""
  set mysock(plauthed) ""
}
set numeric($mysock(numeric)) $mysock(servername)
set mysock(users-description) "Array pour les utilisateurs présents sur un chan"
set mysock(mychans) $mysock(adminchan)
set mysock(gamelist) ""

# Variables for userlists
set mysock(users-$mysock(adminchan)) ""
foreach chan $mysock(chanlist) { set mysock(users-$chan) "" }

