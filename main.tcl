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
source games/uno.tcl
puts "Chargement du Poker"
source games/poker.tcl

puts "Démarrage des services."
if {$gameserver=="1"} { socket_connect; set gameserver 2 }
if {$pl=="1"} { pl_server; set pl 2 }
