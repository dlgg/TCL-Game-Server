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

proc socket_control {sock} {
  global mysock
  global numeric
  set argv [gets $sock arg]
  if {$argv=="-1"} {
    puts "Fermeture du socket"
    close $sock
    exit 0
  }
  set arg [charfilter $arg]
  # TODO : Verifier le chargement du module de PL
  foreach s $mysock(plauthed) { puts $s "<<< $sock <<< [stripmirc $arg]" }
  puts "<<< $sock <<< [stripmirc $arg]"

  if {[lrange $arg 1 end]=="NOTICE AUTH :*** Looking up your hostname..."} {
    fsend $sock "PROTOCTL NOQUIT NICKv2 UMODE2 VL SJ3 NS TKLEXT CLK"
    fsend $sock "PASS $mysock(password)"
    fsend $sock "SERVER $mysock(servername) 1 :U2310-Fh6XiOoEe-$mysock(numeric) TCL Game Server V.$mysock(version)"
    bot_init $mysock(nick) $mysock(username) $mysock(hostname) $mysock(realname)
    game_init
    fsend $sock "NETINFO 0 [unixtime] 2310 * 0 0 0 :$mysock(networkname)"
    fsend $sock "EOS"
    return 0
  }

  if {[lindex $arg 0]=="PING"} {
    fsend $sock "PONG $mysock(servername) [lindex $arg 1]"; return 0
  }
  if {[lindex $arg 0]=="NETINFO"} {
    write_pid; return 0
  }

  #<<< :Yume JOIN #blabla,#opers
  if {[lindex $arg 1]=="JOIN"} {
    set nick [string range [lindex $arg 0] 1 end]
    set chans [join [split [lindex $arg 2] ,]]
    foreach chan $chans {
      if {[lsearch [string tolower $mysock(mychans)] [string tolower $chan]] > 0} {
        lappend $mysock(users-$chan) $nick
      }
      if {[info exists mysock(join-[string tolower $chan])]} {
        $mysock(join-[string tolower $chan]) $nick
      }
    }
  }
  #<<< @1 SJOIN 1325144112 #Poker :Yume 
  if {[lindex $arg 1]=="SJOIN"} {
    set nick [string range [lindex $arg 4] 1 end]
    set chans [join [split [lindex $arg 3] ,]]
    foreach chan $chans {
      if {[lsearch [string tolower $mysock(mychans)] [string tolower $chan]] > 0} {
        lappend $mysock(users-$chan) $nick
      }
      if {[info exists mysock(join-[string tolower $chan])]} {
        $mysock(join-[string tolower $chan]) $nick
      }
    }
  }

  #<<< :Yume PART #Poker
  
  # PRIVMSG
  if {[lindex $arg 1]=="PRIVMSG"} {
    set from [string range [lindex $arg 0] 1 end]
    set to [lindex $arg 2]
    set commc [list [string range [lindex $arg 3] 1 end] [lrange $arg 4 end]]
    set comm [stripmirc [list [string range [lindex $arg 3] 1 end] [lrange $arg 4 end]]]

    # Send info to addon proc for master bot
    if {[string index $to 0]=="#"} {
      foreach addon $mysock(proc-addon) {
        if {[info procs $addon]==$addon} { $addon $from $to "$commc" }
      }
    }
    # Send info to bot who need it
    if {[info exists mysock(proc-[string tolower $to])]} {
      $mysock(proc-[string tolower $to]) $from "$comm"
    }

    if {[string match $mysock(root) [string range [lindex $arg 0] 1 end]] || [string match Yuki [string range [lindex $arg 0] 1 end]]} {
      if {[string equal $mysock(cmdchar) [lindex $comm 0]]} {
        fsend $sock [join [lrange $comm 1 end]]
      }
      # Commande !rehash
      if {[string equal "$mysock(cmdchar)rehash" [lindex $comm 0]]} {
        my_rehash
        fsend $sock ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00310Rehash par $from"
      }
      if {[string equal "$mysock(cmdchar)source" [lindex $comm 0]]} {
        my_rehash
        source $comm
        fsend $sock ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00310Source de $comm par $from"
      }
      if {[string equal "$mysock(cmdchar)tcl" [lindex $comm 0]]} {
        my_rehash
        $comm
        fsend $sock ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00310TCL\017 Execution par $from de $comm"
      }
      # Commande !test
      if {[string equal -nocase "$mysock(cmdchar)test" [lindex $comm 0]]} {
        fsend $sock ":$mysock(nick) PRIVMSG $from :Test OK !"
      }
#      if {[string equal -nocase "!pl" [lindex $comm 0]]} {
#        set long [exec ~/ip2long "$mysock(plip)"];
#        fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :Long ip : $long"
#        fsend $mysock(sock) ":$mysock(nick) PRIVMSG $from :\001DCC CHAT chat $long $mysock(plport)\001"
#      }
      # Commande !join #chan
      if {[string equal -nocase "$mysock(cmdchar)join" [lindex $comm 0]]} {
        foreach chan [lrange $comm 1 end] {
          if {$chan=="0"} {
            fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :On a tenté de me faire partir de tous les chans via un join 0."
          }
          join_chan $mysock(nick) [join [lindex [split $chan ","] 0]]
        }
      }
      # Commmande !part #chan
      if {[string equal -nocase "$mysock(cmdchar)part" [lindex $comm 0]]} {
        set pchan [join [string tolower [lindex $comm 1]]]
        if {$pchan==[string tolower $mysock(adminchan)]} {
          fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :Je ne peux pas partir de $pchan !"
          fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :$from a tenté de me faire partir de $pchan !"
          return 0
        } else {
          fsend $mysock(sock) ":$mysock(nick) PART $pchan :$from m'a demandé de partir !"
        }
      }
      # Commande !die
      if {[string equal -nocase "$mysock(cmdchar)die" [lindex $comm 0]]} {
        foreach bot $mysock(botlist) {
          fsend $mysock(sock) ":$bot QUIT :Coupure des services demandée par $from. "
        }
        fsend $mysock(sock) "SQUIT $mysock(hub)"
        exit 0
      }
      # Commande !flood
      if {[string equal -nocase "$mysock(cmdchar)flood" [lindex $comm 0]]} {
        for {set num 1} {$num < 129} {incr i} {
          fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :Test de flood sur IRC N° $num"
        }
      }
#      # Commande !restart
#      if {[string equal -nocase "$mysock(cmdchar)restart" [lindex $comm 0]]} {
#        fsend $mysock(sock) ":$mysock(nick) PRIVMSG $from :OK je restart !"
#        fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :Restart demandé par $from !"
#        fsend $mysock(sock) "SQUIT $mysock(hub)"
#        [exec /usr/bin/nohup ./main.tcl]
#        exit 0
#      }
      # Commande !op
      if {[string equal -nocase "$mysock(cmdchar)owner"      [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to +q $from" }
      if {[string equal -nocase "$mysock(cmdchar)deowner"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to -q $from" }
      if {[string equal -nocase "$mysock(cmdchar)protect"      [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to +a $from" }
      if {[string equal -nocase "$mysock(cmdchar)deprotect"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to -a $from" }
      if {[string equal -nocase "$mysock(cmdchar)op"      [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to +o $from" }
      if {[string equal -nocase "$mysock(cmdchar)deop"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to -o $from" }
      if {[string equal -nocase "$mysock(cmdchar)halfop"      [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to +h $from" }
      if {[string equal -nocase "$mysock(cmdchar)dehalfop"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to -h $from" }
      if {[string equal -nocase "$mysock(cmdchar)voice"   [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to +v $from" }
      if {[string equal -nocase "$mysock(cmdchar)devoice" [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to -v $from" }
      if {[string equal -nocase "$mysock(cmdchar)mode" [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to [join [lrange $comm 1 end]]" }
      if {[string equal -nocase "$mysock(cmdchar)touche"  [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :\002$from\002 glisse sa main dans le string de \002[lindex $comm 1]\002 et la caresse." }
      if {[string equal -nocase "$mysock(cmdchar)pipe"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :\002$from\002 prend le sexe de \002[lindex $comm 1]\002 en bouche et le suce." }
      if {[string equal -nocase "$mysock(cmdchar)cuni"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :\002$from\002 retire le shorty de \002[lindex $comm 1]\002 et viens jouer avec sa langue entre ses lèvres." }
    }
    return 0
  }
  if {[lindex $arg 1]=="KILL"&&[lindex $arg 2]==$mysock(nick)} { bot_init $mysock(nick) $mysock(username) $mysock(hostname) $mysock(realname); return 0 }
  if {[lindex $arg 1]=="KICK"} {
    set to [lindex $arg 2]
    if {[lindex $arg 3]==$mysock(nick)} {
      join_chan $mysock(nick) $to
    }
    foreach bot $mysock(botlist) {
      if {[lindex $arg 3]==$bot} {
        join_chan $bot $to
      }
    }
  }
}

set gameserver 1
