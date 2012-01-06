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

# Proc for cleaning IRC strings
proc charfilter {arg} { return [string map {"\\" "\\\\" "\{" "\\\{" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]" "\'" "\\\'" "\"" "\\\""} $arg] }
proc stripmirc {arg} { return [regsub -all -- {\002|\037|\026|\003(\d{1,2})?(,\d{1,2})?} $arg ""] }

# Link to IRC Network
proc socket_connect {} {
  global mysock
  puts "Initialisation du link etape 1 : Creation du socket vers $mysock(ip):$mysock(port)"
  if {[catch {set mysock(sock) [socket $mysock(ip) $mysock(port)]} error]} { puts "Erreur lors de l'ouverture du socket ([set error])"; return 0 }
  fileevent $mysock(sock) readable [list socket_control $mysock(sock)]
  fconfigure $mysock(sock) -buffering line
  vwait mysock(wait)
}

# Ecriture du pid
proc write_pid { } {
  set f [open tcl.pid "WRONLY CREAT TRUNC" 0600]
  puts $f [pid]
  close $f
}

proc unixtime {} {return [exec date +%s]}

proc test { a b } { return [string equal -nocase $a $b] }
proc testcs { a b } { return [string equal $a $b] }

# Eggdrop tcl command
proc duration {s} {
  set days [expr {$s / 86400}]
  set hours [expr {$s / 3600}]
  set minutes [expr {($s / 60) % 60}]
  set seconds [expr {$s % 60}]
  set res ""
  if {$days != 0} {append res "$days jours"}
  if {$hours != 0} {append res "$hours heures"}
  if {$minutes != 0} {append res " $minutes minutes"}
  if {$seconds != 0} {append res " $seconds secondes"}
  return $res
}
proc rand { multiplier } {
  return [expr { int( rand() * $multiplier ) }]
}

# Gestion complémentaire de listes
proc lremove { list element } {
  set final ""
  foreach l $list { if {![string equal -nocase $l $element]} { lappend final $l } }
  return $final
}

proc nodouble { var } {
  set final ""
  foreach i $var {
    if {[llength $final] == 0} {
      set final $i
    } else {
      set l 1
      foreach j $final { if {[testcs $j $i]} { set l 0 } }
      if {[test $l 1]} { append final " $i" }
    }
  }
  return $final
}

# Proc gestion du service
proc my_rehash {} {
  global mysock
  puts "Fermeture de toutes les partylines"
  foreach pl $mysock(pl) { puts "Fermeture de la PL : $pl"; close $pl }
  puts "Chargement des paramètres de configurations."
  source config.tcl
  puts "Chargement des outils."
  source tools.tcl
  puts "Chargement du controller."
  source controller.tcl
  puts "Chargement de la partyline."
  source pl.tcl
  puts "Chargement du UNO"
  source games/uno.tcl
  puts "Chargement du Poker"
  source games/poker.tcl
  puts "Chargement de l'addon YouTube"
  source games/youtube.tcl
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304Rehash effectué"
}

proc fsend {sock data} {
  global mysock
  set data [stripmirc $data]
  foreach s $mysock(plauthed) { if {![string equal $s $sock]} { puts $s ">>> $sock >>> $data" } }
  puts ">>> \002$sock\002 >>> [stripmirc $data]"
  puts $sock $data
}

proc bot_init { nick user host gecos } {
  global mysock
  fsend $mysock(sock) "TKL + Q * $nick $mysock(servername) 0 [unixtime] :Reserved for Game Server"
  fsend $mysock(sock) "NICK $nick 0 [unixtime] $user $host $mysock(servername) 0 +oSqB * * :$gecos"
  if {$nick==$mysock(nick)} {
    join_chan $mysock(nick) $mysock(adminchan)
    foreach chan $mysock(chanlist) {
      join_chan $mysock(nick) $chan
    }
  }
  if {[info exists mysock(botlist)]} { lappend mysock(botlist) $nick } else { set mysock(botlist) $nick }
  puts "My bots are : $mysock(botlist)"
}

proc join_chan {bot chan} {
  global mysock
  if {$chan=="0"} {
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :On a tenté de faire partir le robot $bot de tous les chans via un join 0."
  } else {
    if {$bot==$mysock(nick)} {
      fsend $mysock(sock) ":$bot JOIN $chan"
      fsend $mysock(sock) ":$bot MODE $chan +qo $bot $bot"
    } else {
      fsend $mysock(sock) ":$bot JOIN $chan"
      fsend $mysock(sock) ":$bot MODE $chan +ao $bot $bot"
    }
    lappend mysock(mychans) $chan
    set mysock(mychans) [join [nodouble $mysock(mychans)]]
    puts "My chans are : $mysock(mychans)"
  }
}

proc game_init {} {
  global mysock
  foreach game $mysock(gamelist) {
    puts "Load game : $game"
    bot_init $mysock($game-nick) $mysock($game-username) $mysock($game-hostname) $mysock($game-realname)
    join_chan $mysock($game-nick) $mysock($game-chan)
  }
}

proc is_admin { nick } {
  global mysock
  if {[string equal -nocase $nick $mysock(root)]} { return 1 }
  return 0
}

