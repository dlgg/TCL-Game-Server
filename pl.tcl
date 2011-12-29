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
  nodouble $mysock(pl)
  fconfigure $sockpl -buffering line
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304\002PL activée :\002\003 $sockpl > $mysock(plport):$addr:$dstport"
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

puts "Serveur de PartyLine chargé."
set pl 1
