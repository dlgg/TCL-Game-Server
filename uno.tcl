#!/usr/bin/tclsh
#
# Based on UNO bot by Marky v0.96
#
# Marky's Uno v0.96
# Copyright (C) 2004 Mark A. Day (techwhiz@earthlink.net)
#
# Uno(tm) is Copyright (C) 2001 Mattel, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

# Parametres pour le jeu UNO
set mysock(uno-nick) "UNO"
set mysock(uno-username) "uno"
set mysock(uno-hostname) "uno.$mysock(hostname)"
set mysock(uno-realname) "Bot de jeu UNO"
set mysock(uno-chan) "#UNO"

# Don't modify this
lappend mysock(gamelist) "uno"
set mysock(proc-[string tolower $mysock(uno-chan)]) "uno_control_pub"
set mysock(proc-[string tolower $mysock(uno-nick)]) "uno_control_priv"
nodouble $mysock(gamelist)
set mysock(users-$mysock(uno-chan)) ""

proc uno_control_pub { nick text } {
  global mysock
  fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $mysock(uno-chan) :\002PUB \002 $nick > [join $text]"
}

proc uno_control_priv { nick text } {
  global mysock
  fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $mysock(uno-chan) :\002PRIV\002 $nick > [join $text]"
}
