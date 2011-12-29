#!/usr/bin/tclsh

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

# Gestion complémentaire de listes
proc lremove { list element } {
  set final ""
  foreach l $list { if {![testcs $l $element]} { lappend final $l } }
  return [nodouble $final]
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
  close $mysock(sock)
  puts "Chargement des paramètres de configurations."
  source config.tcl
  puts "Chargement des outils."
  source tools.tcl
  puts "Chargement du controller."
  source controller.tcl
  puts "Chargement de la partyline."
  source pl.tcl
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304Rehash effectué"
}
