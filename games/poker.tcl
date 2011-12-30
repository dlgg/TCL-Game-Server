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

