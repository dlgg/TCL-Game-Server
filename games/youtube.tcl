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

package require http

# Register Master Bot Addon
lappend mysock(proc-addon) "youtube_control"
nodouble $mysock(proc-addon)

# vars for youtube
set youtube(logo) "\002\00301,00You\00300,04Tube\002\017"
set youtube(base) "http://www.youtube.com"
set youtube(agent) "Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1"
set youtube(timeout) 30000

# Proc for searching youtube URI
proc youtube_control { nick chan text } {
  global mysock youtube
  set textnc [stripmirc $text]
  set watch [regexp -nocase -- {\/watch\?v\=([^\s]{11})} $textnc youtubeid]
  if {!$watch} { set watch [regexp -nocase -- {youtu\.be\/([^\s]{11})} $textnc yt youtubeidd]; if {$watch} {set youtubeid "/watch?v=$youtubeidd"} }
  if {$watch && $youtubeid != ""} {
    set link "$youtube(base)$youtubeid"
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :$youtube(logo) \002$nick\002 on \002$chan\002 : $link"
    set t [::http::config -useragent $youtube(agent)]
    set t [::http::geturl "$link" -timeout $youtube(timeout)]
    set data [::http::data $t]
    ::http::cleanup $t
    set l [regexp -all -inline -- {<meta name="title" content="(.*?)">.*?<span class="watch-view-count">.*?<strong>(.*?)</strong>} $data]
    regexp {"length_seconds": (\d+),} $data "" length
    foreach {black a b c d e} $l {
      set a [string map -nocase {\&\#39; \x27 &amp; \x26 &quot; \x22} $a]
      set b [string map [list \n ""] $b]
      set c [string map [list \n ""] $c]
      set d [string map [list \n ""] $d]
      set e [string map -nocase {\&\#39; \x27 &amp; \x26 &quot; \x22} $e]
      regsub -all {<.*?>} $a {} a
      regsub -all {<.*?>} $b {} b
      regsub -all {<.*?>} $c {} c
      regsub -all {<.*?>} $d {} d
      regsub -all {<.*?>} $e {} e
      fsend $mysock(sock) ":$mysock(nick) PRIVMSG [join [list $chan $mysock(adminchan)] ,]  :$youtube(logo) $a \002(\002[duration $length]\002) Viewed\002 $b"
    }
  }
  #fsend $mysock(sock) ":$mysock(nick) PRIVMSG $chan :\002YT\002 $nick > [join $text]"
}

