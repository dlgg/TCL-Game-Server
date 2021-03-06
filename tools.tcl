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
puts [::msgcat::mc loadmodule "Tools"]

# Proc for cleaning IRC strings
proc charfilter {arg} { return [string map {"\\" "\\\\" "\{" "\\\{" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]" "\'" "\\\'" "\"" "\\\""} $arg] }
proc stripmirc {arg} { return [regsub -all -- {\002|\037|\026|\003(\d{1,2})?(,\d{1,2})?} $arg ""] }

# Link to IRC Network
proc socket_connect {} {
  global mysock
  if {$mysock(debug)==1} { puts [::msgcat::mc initlink1 $mysock(ip) $mysock(port)] }
  if {[catch {set mysock(sock) [socket $mysock(ip) $mysock(port)]} error]} { puts [::msgcat::mc sockerror $error]); close $mysock(sock); socket_connect; return 0 }
  fileevent $mysock(sock) readable [list socket_control $mysock(sock)]
  fconfigure $mysock(sock) -buffering line
  vwait mysock(wait)
}

# Ecriture du pid
proc write_pid { } {
  global mysock
  set f [open $mysock(pid) "WRONLY CREAT TRUNC" 0600]
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
  if {$days != 0} {append res "$days [::msgcat::mc days]"}
  if {$hours != 0} {append res "$hours [::msgcat::mc hours]"}
  if {$minutes != 0} {append res " $minutes [::msgcat::mc minutes]"}
  if {$seconds != 0} {append res " $seconds [::msgcat::mc seconds]"}
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

# Conversion of unreal server numeric from unreal specific base 64 to decimal
set mysock(chars) { 0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z \{ \} }
proc dec2base { num baselist } {
  set res {}
  set base [llength $baselist]
  while {$num/$base != 0} {
    set rest [expr { $num % $base } ]
    set res [lindex $baselist $rest]$res
    set num [expr { $num / $base } ]
  }
  set res [lindex $baselist $num]$res
  return $res
}
proc base2dec { num baselist } {
  set sum 0
  foreach char [split $num ""] {
    set d [lsearch $baselist $char]
    if {$d == -1} {error "invalid unrealbase-64 digit '$char' in $num"}
    set sum [expr {$sum * 64 + $d}]
  }
  return $sum
}

# Proc gestion du service
proc my_rehash {} {
  global mysock
  puts [::msgcat::mc closepls]
  foreach pl $mysock(pl) { closepl $pl "rehash" }
  source config.tcl
  source tools.tcl
  source controller.tcl
  source pl.tcl
  foreach file $mysock(toload) {
    append file ".tcl"
    set file games/$file
    if {[file exists $file]} {
      if {[catch {source $file} err]} { puts "Error loading $file \n$err" }
    } else {
      puts [::msgcat::mc filenotexist $file]
    }
  }
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304[::msgcat::mc rehashdone]"
}

proc fsend {sock data} {
  global mysock
  puts $sock $data
  if {$mysock(debug)==1} {
    set datanc [stripmirc $data]
    foreach s $mysock(plauthed) { if {![string equal $s $sock]} { puts $s ">>> $sock >>> $datanc" } }
    puts ">>> \002$sock\002 >>> $datanc"
  }
}

proc bot_init { nick user host gecos } {
  global mysock network
  fsend $mysock(sock) "TKL + Q * $nick $mysock(servername) 0 [unixtime] :Reserved for Game Server"
  fsend $mysock(sock) "NICK $nick 0 [unixtime] $user $host $mysock(servername) 0 +oSqB * * :$gecos"
  if {$nick==$mysock(nick)} {
    join_chan $mysock(nick) $mysock(adminchan)
    foreach chan $mysock(chanlist) {
      join_chan $mysock(nick) $chan
    }
  }
  if {[info exists mysock(botlist)]} { lappend mysock(botlist) $nick; set mysock(botlist) [nodouble $mysock(botlist)] } else { set mysock(botlist) $nick }
  if {[info exists network(userlist)]} { lappend network(userlist) $nick; set network(userlist) [nodouble $network(userlist)] } else { set network(userlist) $nick }
  if {$mysock(debug)==1} { puts "My bots are : $mysock(botlist)" }
}

proc join_chan {bot chan} {
  global mysock network
  if {$chan=="0"} {
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :[::msgcat::mc botjoin0 $bot]"
  } else {
    if {$bot==$mysock(nick)} {
      fsend $mysock(sock) ":$bot JOIN $chan"
      fsend $mysock(sock) ":$bot MODE $chan +qo $bot $bot"
    } else {
      fsend $mysock(sock) ":$bot JOIN $chan"
      fsend $mysock(sock) ":$mysock(nick) MODE $chan +ao $bot $bot"
    }
    if {[info exists mysock(mychans)]} { lappend mysock(mychans) $chan; set mysock(mychans) [join [nodouble $mysock(mychans)]] } else { set mysock(mychans) $bot }
    if {[info exists network(users-[string tolower $chan])]} { lappend network(users-[string tolower $chan]) $bot; set network(users-[string tolower $chan]) [nodouble $network(users-[string tolower $chan])] } else { set network(users-[string tolower $chan]) $bot }
    if {$mysock(debug)==1} { puts "My chans are : $mysock(mychans)" }
  }
}

proc game_init {} {
  global mysock network
  foreach game $mysock(gamelist) {
    if {$mysock(debug)==1} { puts "Load game : $game" }
    bot_init $mysock($game-nick) $mysock($game-username) $mysock($game-hostname) $mysock($game-realname)
    join_chan $mysock(nick) $mysock($game-chan)
    join_chan $mysock($game-nick) $mysock($game-chan)
  }
  foreach game $mysock(gamelist2) {
    if {$mysock(debug)==1} { puts "Load game2 : $game" }
    bot_init [set ::${game}::nick] [set ::${game}::username] [set ::${game}::hostname] [set ::${game}::realname]
    join_chan $mysock(nick) [set ::${game}::chan]
    join_chan [set ::${game}::nick] [set ::${game}::chan]
  }
  return
}
proc gamebot_init {bot} {
  global mysock
  foreach game $mysock(gamelist) {
    if {[string tolower $mysock($game-nick)]!=[string tolower $bot]} { continue }
    if {$mysock(debug)==1} { puts "Load game : $game" }
    bot_init $mysock($game-nick) $mysock($game-username) $mysock($game-hostname) $mysock($game-realname)
    join_chan $mysock(nick) $mysock($game-chan)
    join_chan $mysock($game-nick) $mysock($game-chan)
  }
  foreach game $mysock(gamelist2) {
    if {[string tolower [set ::${game}::nick]]!=[string tolower $bot]} { continue }
    if {$mysock(debug)==1} { puts "Load game2 : $game" }
    bot_init [set ::${game}::nick] [set ::${game}::username] [set ::${game}::hostname] [set ::${game}::realname]
    join_chan $mysock(nick) [set ::${game}::chan]
    join_chan [set ::${game}::nick] [set ::${game}::chan]
  }
  return
}

proc is_admin { nick } {
  global mysock
  if {[string equal -nocase $nick $mysock(root)]} { return 1 }
  return 0
}
proc ischan { chan } { if {[string index $chan 0]=="#"} { return 1 } else { return 0 } }
