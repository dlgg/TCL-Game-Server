#!/usr/bin/tclsh

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
  foreach s $mysock(pl) { puts $s "<<< $arg" }
  puts "<<< $arg"

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
      #if { ! [info exists mysock(users-$chan)] } { set mysock(users-$chan) "" } 
      if {[lsearch [string tolower $mysock(mychans)] [string tolower $chan]] > 0} {
        lappend $mysock(users-$chan) $nick
      }
    }
  }
  #<<< @1 SJOIN 1325144112 #Poker :Yume 
  if {[lindex $arg 1]=="SJOIN"} {
    set nick [string range [lindex $arg 4] 1 end]
    set chans [join [split [lindex $arg 2] ,]]
    foreach chan $chans {
      #if { ! [info exists mysock(users-$chan)] } { set mysock(users-$chan) "" } 
      lappend $mysock(users-$chan) $nick
    }
  }
  #<<< :Yume PART #Poker
  
  # PRIVMSG
  if {[lindex $arg 1]=="PRIVMSG"} {
    set from [string range [lindex $arg 0] 1 end]
    set to [lindex $arg 2]
    set comm [stripmirc [list [string range [lindex $arg 3] 1 end] [lrange $arg 4 end]]]

    if {[info exists mysock(proc-$to)]} {
      $mysock(proc-$to) $from "$comm"
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
      # Commande !test
      if {[string equal -nocase "$mysock(cmdchar)test" [lindex $comm 0]]} {
        fsend $sock ":$mysock(nick) PRIVMSG $from :Test OK !"
      }
      if {[string equal -nocase "!pl" [lindex $comm 0]]} {
        set long [exec ~/ip2long "$mysock(plip)"];
        fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :Long ip : $long"
        fsend $mysock(sock) ":$mysock(nick) PRIVMSG $from :\001DCC CHAT chat $long $mysock(plport)\001"
      }
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
        if {[string tolower [lindex $comm 1]]==[string tolower $mysock(adminchan)]} {
          fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :Je ne peux pas partir de [lindex $comm 1] !"
          fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :$from a tenté de me faire partir de [lindex $comm 1] !"
          return 0
        } else {
          fsend $mysock(sock) ":$mysock(nick) PART [lindex $comm 1] :$from m'a demandé de partir !"
        }
      }
      # Commande !die
      if {[string equal -nocase "$mysock(cmdchar)die" [lindex $comm 0]]} {
        exit 0
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
      if {[string equal -nocase "$mysock(cmdchar)op"      [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to +o $from" }
      if {[string equal -nocase "$mysock(cmdchar)deop"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to -o $from" }
      if {[string equal -nocase "$mysock(cmdchar)voice"   [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to +v $from" }
      if {[string equal -nocase "$mysock(cmdchar)devoice" [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) MODE $to -v $from" }
      if {[string equal -nocase "$mysock(cmdchar)touche"  [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :$from glisse sa main dans le string de [lindex $comm 1] et la caresse" }
      if {[string equal -nocase "$mysock(cmdchar)pipe"    [lindex $comm 0]]} { fsend $mysock(sock) ":$mysock(nick) PRIVMSG $to :$from prend le sexe de [lindex $comm 1] en bouche et le suce" }
    }
    return 0
  }
  if {[lindex $arg 1]=="KILL"&&[lindex $arg 2]==$mysock(nick)} { bot_init $mysock(nick) $mysock(username) $mysock(hostname) $mysock(realname); return 0 }
  if {[lindex $arg 1]=="KICK"&&[lindex $arg 3]==$mysock(nick)} { join_chan $mysock(nick) [lindex $arg 2]; return 0 }
}

set gameserver 1
