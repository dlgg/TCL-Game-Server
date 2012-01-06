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
  puts "Arrivée d'une connexion Partyline."
  fileevent $sockpl readable [list pl_control $sockpl]
  lappend mysock(pl) $sockpl
  set mysock(pl) [nodouble $mysock(pl)]
  fconfigure $sockpl -buffering line
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL activée :\002\003 $sockpl > $mysock(plport):$addr:$dstport"
}

proc pl_control { sockpl } {
  global mysock
  set argv [gets $sockpl arg]
  set isauth 0
  foreach pl $mysock(plauthed) { if {[test $pl $sockpl]} { set isauth 1 } }
  if {$argv=="-1"} {
    set mysock(pl) [lremove $mysock(pl) $sockpl]
    set mysock(plauthed) [lremove $mysock(plauthed) $sockpl]
    fsend $sockpl "Fermeture du socket PL $sockpl"
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Fermeture de la PL $sockpl"
    puts "Fermeture du socket PL $sockpl"
    close $sockpl
  }
  set arg [charfilter $arg]
  puts "<<< $sockpl <<< $arg"
  puts $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00312PL <<<\002 $sockpl \002<<<\003 [join $arg]"
  
  if {$isauth==1} {
    if {[lindex $arg 0]==".help"} {
      fsend $sockpl "Aide de TCL GameService v$mysock(version)"
      fsend $sockpl " "
      fsend $sockpl "Commandes partyline"
      fsend $sockpl "-------------------"
      fsend $sockpl " "
      fsend $sockpl ".close     Ferme votre PL ou une PL donnée en paramètre"
      fsend $sockpl ".who       Affiche la liste des personnes en PL"
      fsend $sockpl ".rehash    Recharge le service"
      fsend $sockpl ".die       Tue le service"
    }
    if {[lindex $arg 0]==".close"} {
      if {[lindex $arg 1]==""} {
        set socktoclose $sockpl
      } else {
        set socktoclose [lindex $arg 1]
      } 
      set mysock(pl) [lremove $mysock(pl) $socktoclose]
      set mysock(plauthed) [lremove $mysock(plauthed) $socktoclose]
      fsend $socktoclose "Fermeture du socket PL $socktoclose par l'utilisateur $sockpl"
      fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Fermeture de la PL $socktoclose par l'utilisateur $sockpl"
      puts "Fermeture du socket PL $socktoclose par l'utilisateur $sockpl"
      after 2000
      close $socktoclose
    }
    if {[lindex $arg 0]==".who"} {
      fsend $sockpl "Présent en PL : $mysock(pl)"
      fsend $sockpl "Présent en PL et auth : $mysock(plauthed)"
    }
    if {[lindex $arg 0]==".rehash"} {
      my_rehash
      fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Rehash par la PL $sockpl"
    }
    if {[lindex $arg 0]==".die"} {
      fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Die par la PL $sockpl"
      foreach bot $mysock(botlist) {
        fsend $mysock(sock) ":$bot QUIT :Coupure des services demandée par $sockpl. "
      }
      fsend $mysock(sock) "SQUIT $mysock(hub)"
      exit 0
    }
  } else {
    if {([lindex $arg 0]==".pass")&&([string equal [lindex $arg 1] $mysock(plpass)])} {
      lappend mysock(plauthed) $sockpl
      set mysock(plauthed) [nodouble $mysock(plauthed)]
      fsend $sockpl "You are authed !!!"
    } elseif {[lindex $arg 0]==".close"} {
      if {[lindex $arg 1]==""} {
        set socktoclose $sockpl
      } else {
        set socktoclose [lindex $arg 1]
      } 
      set mysock(pl) [lremove $mysock(pl) $socktoclose]
      set mysock(plauthed) [lremove $mysock(plauthed) $socktoclose]
      fsend $socktoclose "Fermeture du socket PL $socktoclose par l'utilisateur $sockpl"
      fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL :\003\002 Fermeture de la PL $socktoclose par l'utilisateur $sockpl"
      puts "Fermeture du socket PL $socktoclose par l'utilisateur $sockpl"
      close $socktoclose
    } else {
      fsend $sockpl "You are not authed. Please use .pass <password> to auth yourself."
    }
  }
}

puts "Serveur de PartyLine chargé."
set pl 1
