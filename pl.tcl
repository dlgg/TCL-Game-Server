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

proc pl_server {} {
  global mysock
  if {[catch {socket -server pl -myaddr $mysock(plip) $mysock(plport)} error]} { puts "Erreur lors de l'ouverture du socket ([set error])"; return 0 }
  puts "Ouverture du port PL OK"
  set mysock(server) "1"
}

proc pl { sockpl addr dstport } {
  global mysock
  puts "Arriv�e d'une connexion Partyline."
  fileevent $sockpl readable [list pl_control $sockpl]
  lappend mysock(pl) $sockpl
  nodouble $mysock(pl)
  fconfigure $sockpl -buffering line
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL activ�e :\002\003 $sockpl > $mysock(plport):$addr:$dstport"
}

proc pl_control { sockpl } {
  global mysock
  set argv [gets $sockpl arg]
  if {$argv=="-1"} {
    fsend $sockpl "Fermeture du socket PL $sockpl"
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Fermeture de la PL $sockpl"
    puts "Fermeture du socket PL $sockpl"
    lremove $mysock(pl) $sockpl
    close $sockpl
  }
  set arg [charfilter $arg]
  puts "<<< $arg"
  puts $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00312PL<<<\002 $sockpl \002<<<\003 $arg"

  if {[lindex $arg 0]==".close"} {
    fsend $sockpl "Fermeture du socket PL $sockpl par l'utilisateur"
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Fermeture de la PL $sockpl par l'utilisateur"
    puts "Fermeture du socket PL $sockpl par l'utilisateur"
    lremove $mysock(pl) $sockpl
    close $sockpl
  }
  if {[lindex $arg 0]==".rehash"} {
    my_rehash
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Rehash par la PL $sockpl"
  }
}

puts "Serveur de PartyLine charg�."
set pl 1
