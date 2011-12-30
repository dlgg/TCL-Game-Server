#!/usr/bin/tclsh
puts "Chargement des paramètres de configurations."
source config.tcl
puts "Chargement des outils."
source tools.tcl
puts "Chargement du controller."
source controller.tcl
puts "Chargement de la partyline."
source pl.tcl

# TODO : une variable avec la liste des jeux à charger et le chargement en dynamique  selon les jeux listés
puts "Chargement du UNO"
source uno.tcl
puts "Chargement du Poker"
source poker.tcl

puts "Démarrage des services."
if {$gameserver=="1"} { socket_connect; set gameserver 2 }
if {$pl=="1"} { pl_server; set pl 2 }
