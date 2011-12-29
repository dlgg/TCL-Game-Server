#!/usr/bin/tclsh
puts "Chargement des paramètres de configurations."
source config.tcl
puts "Chargement des outils."
source tools.tcl
puts "Chargement du controller."
source controller.tcl
puts "Chargement de la partyline."
source pl.tcl

puts "Démarrage des services."
if {$gameserver=="1"} { socket_connect; set gameserver 2 }
if {$pl=="1"} { pl_server; set pl 2 }
