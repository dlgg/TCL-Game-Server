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

# Load internal needed scripts
source config.tcl
source tools.tcl
source controller.tcl
source pl.tcl

# Load games and addons for Master Bot
load_games

puts "[::msgcat::mc startserv]"
if {$pl=="1"} { puts "Activation de la PL sur $mysock(plip):$mysock(plport)"; pl_server; set pl 2 }
if {$gameserver=="1"} { puts "Connexion au réseau"; socket_connect; set gameserver 2 }
