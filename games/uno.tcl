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
# Based on UNO bot by Marky v0.96
#
##############################################################################
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
##############################################################################

# Parametres pour le jeu UNO
set mysock(uno-nick) "UNO"
set mysock(uno-username) "uno"
set mysock(uno-hostname) "uno.$mysock(hostname)"
set mysock(uno-realname) "Bot de jeu UNO"
set mysock(uno-chan) "#UNO"

# Original variables
set UnoChan $mysock(uno-chan)
set UnoRobot $mysock(uno-nick)
set UnoPointsName "Points"
set UnoStopAfter 5
set UnoBonus 1000
set UnoWildDrawTwos 1
set UnoCFGFile "games/uno.cfg"
set UnoScoreFile "games/UnoScores"
set UnoMaxNickLen 32
set UnoMaxPlayers 8
set UnoNTC "NOTICE"

# Don't modify this
lappend mysock(gamelist) "uno"
set mysock(proc-[string tolower $mysock(uno-chan)]) "uno_control_pub"
set mysock(proc-[string tolower $mysock(uno-nick)]) "uno_control_priv"
set mysock(join-[string tolower $mysock(uno-chan)]) "uno_control_join"
nodouble $mysock(gamelist)
set mysock(users-$mysock(uno-chan)) ""

proc uno_control_pub { nick text } {
  # nick uhost hand chan arg
  global mysock UnoOn UnoPaused
  fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $mysock(uno-chan) :\002PUB \002 $nick > [join $text]"
  if {[string equal -nocase "!uno-reset" [lindex $text 0]]} { UnoReset; set UnoOn 0 }
  if {[string equal -nocase "!uno" [lindex $text 0]]} { UnoInit $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unocmds" [lindex $text 0]]} { UnoCmds $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!remove" [lindex $text 0]]} { UnoRemove $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!pause" [lindex $text 0]]} { UnoPause $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unowon" [lindex $text 0]]} { UnoWon $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unotop10" [lindex $text 0]]} { UnoTopTen $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unotop10won" [lindex $text 0]]} { UnoTopTenWon $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unotop3last" [lindex $text 0]]} { UnoTopThreeLast $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unofast" [lindex $text 0]]} { UnoTopFast $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unohigh" [lindex $text 0]]} { UnoHighScore $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unoplayed" [lindex $text 0]]} { UnoPlayed $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unorecords" [lindex $text 0]]} { UnoRecords $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!unoversion" [lindex $text 0]]} { UnoVersion $nick "none" "-" $mysock(uno-chan) "$text" }
  if {[string equal -nocase "!stop" [lindex $text 0]]} { UnoStop $nick "none" "-" $mysock(uno-chan) "$text" }
  if {($UnoOn != 0)&&(UnoPaused == 0)} {
    if {[string equal -nocase "join" [lindex $text 0]]} { JoinUno $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "jo" [lindex $text 0]]} { JoinUno $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!jo" [lindex $text 0]]} { JoinUno $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "order" [lindex $text 0]]} { UnoOrder $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "od" [lindex $text 0]]} { UnoOrder $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!od" [lindex $text 0]]} { UnoOrder $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "time" [lindex $text 0]]} { UnoTime $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "ti" [lindex $text 0]]} { UnoTime $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!ti" [lindex $text 0]]} { UnoTime $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "cards" [lindex $text 0]]} { UnoShowCards $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "ca" [lindex $text 0]]} { UnoShowCards $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!ca" [lindex $text 0]]} { UnoShowCards $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "play" [lindex $text 0]]} { UnoPlayCard $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "pl" [lindex $text 0]]} { UnoPlayCard $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!pl" [lindex $text 0]]} { UnoPlayCard $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "card" [lindex $text 0]]} { UnoTopCard $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "cd" [lindex $text 0]]} { UnoTopCard $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!cd" [lindex $text 0]]} { UnoTopCard $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "turn" [lindex $text 0]]} { UnoTurn $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "tu" [lindex $text 0]]} { UnoTurn $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!tu" [lindex $text 0]]} { UnoTurn $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "draw" [lindex $text 0]]} { UnoDraw $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "dr" [lindex $text 0]]} { UnoDraw $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!dr" [lindex $text 0]]} { UnoDraw $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "color" [lindex $text 0]]} { UnoColorChange $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "co" [lindex $text 0]]} { UnoColorChange $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!co" [lindex $text 0]]} { UnoColorChange $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "pass" [lindex $text 0]]} { UnoPass $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "pa" [lindex $text 0]]} { UnoPass $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!pa" [lindex $text 0]]} { UnoPass $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "count" [lindex $text 0]]} { UnoCount $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "ct" [lindex $text 0]]} { UnoCount $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!ct" [lindex $text 0]]} { UnoCount $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "stats" [lindex $text 0]]} { UnoCardStats $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "st" [lindex $text 0]]} { UnoCardStats $nick "none" "-" $mysock(uno-chan) "$text" }
    if {[string equal -nocase "!st" [lindex $text 0]]} { UnoCardStats $nick "none" "-" $mysock(uno-chan) "$text" }
  }
}

proc uno_control_priv { nick text } {
  global mysock
  fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $mysock(uno-chan) :\002PRIV\002 $nick > [join $text]"
}

proc uno_control_join { nick } {
  global mysock
  fsend $mysock(sock) ":$mysock(uno-nick) NOTICE $nick :Bienvenue ! Tapez \002!uno\017 pour lancer une partie de [unoad]\017 :) (Liste de mes commandes : \002!unocmds\017)"
}

# Global Variables
set UnoOn 0
set UnoMode 0
set UnoPaused 0
set UnoPlayers 0
set MasterDeck ""
set UnoDeck ""
set DiscardPile ""
set PlayCard ""
set RoundRobin ""
set ThisPlayer ""
set ThisPlayerIDX 0
set UnoStartTime [unixtime]
set IsColorChange 0
set ColorPicker ""
set IsDraw 0
set UnoIDX ""
set UnPlayedRounds 0

# Scores Records And Ads
set UnoLastMonthCards(0) "Personne 0"
set UnoLastMonthCards(1) "Personne 0"
set UnoLastMonthCards(2) "Personne 0"
set UnoLastMonthGames(0) "Personne 0"
set UnoLastMonthGames(1) "Personne 0"
set UnoLastMonthGames(2) "Personne 0"
set UnoFast "Personne 600"
set UnoHigh "Personne 0"
set UnoPlayed "Personne 0"
set UnoRecordHigh "Personne 0"
set UnoRecordFast "Personne 600"
set UnoRecordCard "Personne 0"
set UnoRecordWins "Personne 0"
set UnoRecordPlayed "Personne 0"
set UnoAdNumber 0

# Card Stats
set CardStats(played) 0
set CardStats(passed) 0
set CardStats(drawn) 0
set CardStats(wilds) 0
set CardStats(draws) 0
set CardStats(skips) 0
set CardStats(revs) 0

# Timers
set UnoStartTimer ""
set UnoSkipTimer ""
set UnoCycleTimer ""
set UnoBotTimer ""

# Grace periods and timeouts
# AutoSkip period can be raised but not lower than 2
set AutoSkipPeriod 2
set StartGracePeriod 30
set RobotRestartPeriod 1
set UnoCycleTime 30

# Nick colours
set UnoNickColour "06 13 03 07 12 10 04 11 09 08"

# Debugging info
set Debug 0
set UnoVersion "0.96.74.3"

#
# Starting game
#
proc UnoInit {nick uhost hand chan arg} {
  global UnoChan UnoOn mysock
  puts "UNO : !uno par $nick sur $chan."
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304UNO :\017 !uno par \00302$nick\017 sur \00302$chan\017."
  if {$UnoOn > 0} {
    if {$chan != $UnoChan} { fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $chan :[unoad]\00306 Désolé, une partie est en cours sur un autre salon." }
    if {$chan == $UnoChan} { fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $chan :[unoad]\00306 Une partie est déjà en cours !" }
    return
  }
  set UnoChan $chan
  puts "UNO : Partie démarrée sur $chan."
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304UNO :\017 Partie démarrée sur \00302$chan\017."
  unomsg "[unoad] \00304\[\00310$nick\00304\]\003"
  set UnoOn 1
  Uno_WriteCFG
  #UnoBindCmds
  UnoNext
  return
}

#
# Initialize a new game
#
proc UnoNext {} {
  global UnoOn MasterDeck UnoDeck UnoMode StartGracePeriod UnoHand NickColor UnoVersion UnoStartTimer UnoSkipTimer
  if {$UnoOn == 0} {return}
  UnoReset
  set UnoMode 1
  set MasterDeck [list B0 B1 B1 B2 B2 B3 B3 B4 B4 B5 B5 B6 B6 B7 B7 B8 B8 B9 B9 BR BR BS BS BDT BDT R0 R1 R1 R2 R2 R3 R3 R4 R4 R5 R5 R6 R6 R7 R7 R8 R8 R9 R9 RR RR RS RS RDT RDT Y0 Y1 Y1 Y2 Y2 Y3 Y3 Y4 Y4 Y5 Y5 Y6 Y6 Y7 Y7 Y8 Y8 Y9 Y9 YR YR YS YS YDT YDT G0 G1 G1 G2 G2 G3 G3 G4 G4 G5 G5 G6 G6 G7 G7 G8 G8 G9 G9 GR GR GS GS GDT GDT W W W W WDF WDF WDF WDF]
  set UnoDeck ""

  binary scan [unixtime] S1 rseed
  set newrand [expr srand($rseed)]
  while {[llength $UnoDeck] != 108} {
    set pcardnum [expr {int(rand()*[llength $MasterDeck])}]
    set pcard [lindex $MasterDeck $pcardnum]
    lappend UnoDeck $pcard
    set MasterDeck [lreplace $MasterDeck $pcardnum $pcardnum]
  }
  if [info exist UnoHand] {unset UnoHand}
  if [info exist NickColor] {unset NickColor}
  unomsg "[unoad]\003 \00300,12Tapez jo pour rejoindre la partie ! Vous avez $StartGracePeriod secondes. \003"
  #set UnoStartTimer [utimer $StartGracePeriod UnoStart]
  set UnoStartTimer [after [expr {int($StartGracePeriod * 1000)}] UnoStart]
  puts "[after info]"
  return
}

#
# Start a new game
#
proc UnoStart {} {
  global UnoChan UnoOn UnoCycleTime UnoRobot Debug UnoIDX UnoStartTime UnoPlayers RoundRobin ThisPlayer ThisPlayerIDX UnoDeck DiscardPile UnoMode UnoHand PlayCard AutoSkipPeriod
  global UnoSkipTimer UnPlayedRounds UnoStopAfter NickColor
  if {$UnoOn == 0} {return}
  if {[llength $RoundRobin] == 0} {
    unomsg "[unoad] \00300,03Aucun joueur, prochain jeu dans $UnoCycleTime secondes. \003"
    incr UnPlayedRounds
    if {($UnoStopAfter > 0)&&($UnPlayedRounds >= $UnoStopAfter)} {
      unomsg "[unoad] \00300,06Partie stoppée, $UnoStopAfter tours non joués. Tapez !uno pour recommencer une partie.\003"
      set UnoOn 0
      after 1000 "UnoStop $UnoRobot $UnoRobot none $UnoChan none"
      return
    }
    UnoCycle
    return
  }

  # Bot Joins If One Player
  if {[llength $RoundRobin] == 1} {
    incr UnoPlayers
    lappend RoundRobin "$UnoRobot"
    lappend UnoIDX "$UnoRobot"
    if [info exist UnoHand($UnoRobot)] {unset UnoHand($UnoRobot)}
    if [info exist NickColor($UnoRobot)] {unset NickColor($UnoRobot)}
    set UnoHand($UnoRobot) ""
    set NickColor($UnoRobot) [colornick $UnoPlayers]
    unomsg "[nikclr $UnoRobot]\017 rejoint la partie [unoad]\017"
    puts "UNO : $UnoRobot rejoint la partie."
    fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304UNO : \00302$UnoRobot\017 rejoint la partie."
    UnoShuffle 7

    while {[llength $UnoHand($UnoRobot)] != 7} {
      set pcardnum [rand [llength $UnoDeck]]
      set pcard [lindex $UnoDeck $pcardnum]
      set UnoDeck [lreplace ${UnoDeck} $pcardnum $pcardnum]
      lappend UnoHand($UnoRobot) "$pcard"
    }
    if {$Debug > 1} { unolog $UnoRobot $UnoHand($UnoRobot) }
  }
  unomsg "\00300,06 Bienvenue dans le jeu de \003 [unoad]\003"
  unomsg "\00300,10 \002$UnoPlayers\002 joueurs dans cette partie \00300,06 $RoundRobin \003"
  set UnoMode 2
  set ThisPlayer [lindex $RoundRobin 0]

  # Draw Card From Deck - First Top Card
  set DiscardPile ""
  set pcardnum [rand [llength $UnoDeck]]
  set pcard [lindex $UnoDeck $pcardnum]

  # Play Doesnt Start With A Wild Card
  while {[string range $pcard 0 0] == "W"} {
    set pcardnum [rand [llength $UnoDeck]]
    set pcard [lindex $UnoDeck $pcardnum]
  }

  set PlayCard $pcard
  set UnoDeck [lreplace ${UnoDeck} $pcardnum $pcardnum]
  set Card [CardColor $pcard]
  unomsg "[nikclr $ThisPlayer]\003 commence. La première carte est $Card \017."
  set Card [CardColorAll $ThisPlayer]
  showcards $ThisPlayerIDX $Card
  set UnoStartTime [unixtime]

  # Start Auto-Skip Timer
  set UnoSkipTimer [after [expr {int($AutoSkipPeriod*1000*60)}] UnoAutoSkip]
  set UnPlayedRounds 0
  return
}

#
# Stop a game
#
proc UnoStop {nick uhost hand chan arg} {
  global Debug UnoChan UnoOn UnoPaused UnPlayedRounds UnoStartTimer UnoSkipTimer UnoCycleTimer
  global mysock
  if {$chan != $UnoChan} {return}
  catch {after cancel $UnoStartTimer}
  catch {after cancel $UnoSkipTimer}
  catch {after cancel $UnoCycleTimer}
  unomsg "[unoad]\00306 Partie stoppée par \00304\[\00312$nick\00304\]\003"
  puts "UNO : Partie stoppée par $nick sur $chan."
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304UNO :\017 Partie stoppée par \00302$nick\017 sur \00302$chan\017."
  set UnoOn 0
  set UnoPaused 0
  set UnPlayedRounds 0
  #UnoUnbindCmds
  UnoReset
  return
}

#
# Cycle a new game
#
proc UnoCycle {} {
  global UnoOn UnoMode UnoCycleTime UnoCycleTimer UnoSkipTimer
  if {$UnoOn == 0} {return}
  set UnoMode 4
  catch {after cancel $UnoSkipTimer}
  set AdTime [expr $UnoCycleTime /2]
  set UnoAdTimer [after [expr {int($AdTime*1000)}] UnoScoreAdvertise]
  set UnoCycleTimer [after [expr {int($UnoCycleTime*1000)}] UnoNext]
  return
}

#
# Add a player
#
proc JoinUno {nick uhost hand chan arg} {
  global Debug UnoIDX UnoMode UnoPlayers RoundRobin UnoDeck UnoHand UnoChan NickColor UnoMaxPlayers
  global mysock
  if {($chan != $UnoChan)||($UnoMode < 1)||($UnoMode > 2)} {return}
  if {[llength $RoundRobin] == $UnoMaxPlayers} {
    unontc $nick "Désolé $nick, le nombre maximum de joueurs est déjà atteint !"
    return
  }
  set pcount 0
  while {[lindex $RoundRobin $pcount] != ""} {
    if {[lindex $RoundRobin $pcount] == $nick} {
      return
    }
    incr pcount
  }
  incr UnoPlayers
  lappend RoundRobin $nick
  lappend UnoIDX $nick
  if [info exist UnoHand($nick)] {unset UnoHand($nick)}
  if [info exist NickColor($nick)] {unset NickColor($nick)}
  set UnoHand($nick) ""
  set NickColor($nick) [colornick $UnoPlayers]
  # Re-Shuffle Deck
  UnoShuffle 7
  # Deal Cards To Player
  set Card ""
  while {[llength $UnoHand($nick)] != 7} {
    set pcardnum [rand [llength $UnoDeck]]
    set pcard [lindex $UnoDeck $pcardnum]
    set UnoDeck [lreplace ${UnoDeck} $pcardnum $pcardnum]
    lappend UnoHand($nick) $pcard
    append Card [CardColor $pcard]
  }
  if {$Debug > 1} { unolog $nick $UnoHand($nick) }
  unomsg "[nikclr $nick]\003 rejoint la partie [unoad]\003"
  puts "UNO : $nick rejoint la partie."
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304UNO : \00302$nick\017 rejoint la partie."
  unontc $nick "En main : $Card"
  return
}

#
# Reset Game Variables
#
proc UnoReset {} {
  global UnoOn UnoMode UnoPaused UnoPlayers RoundRobin UnoDeck ThisPlayer ThisPlayerIDX PlayCard
  global DiscardPile IsColorChange ColorPicker IsDraw UnoIDX MasterDeck CardStats
  global UnoStartTimer UnoSkipTimer UnoCycleTimer

  set UnoMode 0
  set UnoPaused 0
  set UnoPlayers 0
  set MasterDeck ""
  set UnoDeck ""
  set DiscardPile ""
  set RoundRobin ""
  set ThisPlayer ""
  set ThisPlayerIDX 0
  set PlayCard ""
  set IsColorChange 0
  set ColorPicker ""
  set IsDraw 0
  set UnoIDX ""
  set UnoAdNumber 0

  set CardStats(played) 0
  set CardStats(passed) 0
  set CardStats(drawn) 0
  set CardStats(wilds) 0
  set CardStats(draws) 0
  set CardStats(skips) 0
  set CardStats(revs) 0

  set UnoStartTimer ""
  set UnoSkipTimer ""
  set UnoCycleTimer ""

  return
}

#
# Add card(s) to players hand
#
proc UnoAddDrawToHand {cplayer idx num} {
  global UnoHand UnoDeck RoundRobin CardStats mysock
  # Check if deck needs reshuffling
  UnoShuffle $num
  set Card ""
  set newhand [expr [llength $UnoHand($cplayer)] + $num]
  while {[llength $UnoHand($cplayer)] != $newhand} {
    set pcardnum [rand [llength $UnoDeck]]
    set pcard [lindex $UnoDeck $pcardnum]
    set UnoDeck [lreplace ${UnoDeck} $pcardnum $pcardnum]
    lappend UnoHand($cplayer) $pcard
    append Card [CardColor $pcard]
  }
  showdraw $idx $Card
  incr CardStats(drawn) $num
}

#
# Remove played card from player's hand
#
proc UnoRemoveCardFromHand {cplayer pcard} {
  global UnoHand
  set UnoHand($cplayer) [lreplace $UnoHand($cplayer) $pcard $pcard]
}

#
# Add card to discard pile
#
proc AddToDiscardPile {playcard} {
  global DiscardPile
  if {[string range $playcard 1 1] != ""} {
    lappend DiscardPile $playcard
  }
}

#
# Draw a card
#
proc UnoDraw {nick uhost hand chan arg} {
  global UnoChan UnoMode UnoDeck ThisPlayer ThisPlayerIDX UnoHand RoundRobin IsDraw CardStats
  if {($chan != $UnoChan)||($UnoMode != 2)||($nick != $ThisPlayer)} {return}
  if {$IsDraw == 0} {
    set IsDraw 1
    UnoShuffle 1
    set dcardnum [rand [llength $UnoDeck]]
    set dcard [lindex $UnoDeck $dcardnum]
    lappend UnoHand($nick) $dcard
    set UnoDeck [lreplace ${UnoDeck} $dcardnum $dcardnum]
    append Card [CardColor $dcard]
    showdraw $ThisPlayerIDX $Card
    showwhodrew $nick
    incr CardStats(drawn)
    UnoAutoSkipReset
    return
  }
  unontc $nick "Vous avez déjà pioché une carte, jouez-la (pl) ou passez (pa)."
  UnoAutoSkipReset
  return
}

#
# Pass a turn
#
proc UnoPass {nick uhost hand chan arg} {
  global UnoChan UnoMode ThisPlayer IsDraw ThisPlayerIDX RoundRobin IsColorChange CardStats
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  if {($nick != $ThisPlayer)||($IsColorChange == 1)} {return}
  UnoAutoSkipReset
  if {$IsDraw == 1} {
    incr CardStats(passed)
    set IsDraw 0
    UnoNextPlayer
    playpass $nick $ThisPlayer
    set Card [CardColorAll $ThisPlayer]
    showcards $ThisPlayerIDX $Card
    UnoRobotRestart
  } {
    unontc $nick "Désolé $nick, vous ne pouvez pas passer sans avoir pioché (dr) auparavant."
  }
  return
}

#
# Color change
#
proc UnoColorChange {nick uhost hand chan arg} {
  global UnoChan UnoMode IsDraw PlayCard ColorPicker IsColorChange ThisPlayer ThisPlayerIDX RoundRobin
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  if {($nick != $ColorPicker)||($IsColorChange == 0)} {return}
  UnoAutoSkipReset
  regsub -all \[`.,!{}] $arg "" arg
  set NewColor [string toupper [string range $arg 0 0]]
  switch $NewColor {
    "B" { set PlayCard "B"; set Card " \00300,12 Blue \003 "}
    "G" { set PlayCard "G"; set Card " \00300,03 Green \003 "}
    "Y" { set PlayCard "Y"; set Card " \00301,08 Yellow \003 "}
    "R" { set PlayCard "R"; set Card " \00300,04 Red \003 "}
    default { unontc $nick "Choisissez une couleur valide : \002R\002ed, \002G\002reen, \002B\002lue, ou \002Y\002ellow"; return }
  }
  UnoNextPlayer
  unomsg "[nikclr $ColorPicker]\003 a choisi $Card. Le jeu continue avec [nikclr $ThisPlayer].\003"
  set Card [CardColorAll $ThisPlayer]
  showcards $ThisPlayerIDX $Card
  set ColorPicker ""
  set IsColorChange 0
  set IsDraw 0
  UnoRobotRestart
  return
}

#
# Skip card
#
proc PlayUnoSkipCard {nick pickednum crd} {
  global IsDraw ThisPlayer ThisPlayerIDX PlayCard RoundRobin CardStats
  set c0 [string range $crd 0 0]
  set c1 [string range $crd 1 1]
  set cip0 [string range $PlayCard 0 0]
  set cip1 [string range $PlayCard 1 1]
  if {$c1 != "S"} {return 0}
  if {($c0 != $cip0)&&($c1 != $cip1)} {return 0}
  incr CardStats(played)
  incr CardStats(skips)
  AddToDiscardPile $PlayCard
  UnoRemoveCardFromHand $nick $pickednum
  set PlayCard $crd
  set Card [CardColor $crd]
  set SkipPlayer $ThisPlayer
  UnoNextPlayer
  set SkippedPlayer [lindex $RoundRobin $ThisPlayerIDX]
  UnoNextPlayer
  # No Cards Left = Winner
  if {[check_unowin $SkipPlayer $Card] > 0} {
    showwin $SkipPlayer $Card
    UnoWin $SkipPlayer
    UnoCycle
    return 1
  }
  playskip $nick $Card $SkippedPlayer $ThisPlayer
  check_hasuno $SkipPlayer
  set Card [CardColorAll $ThisPlayer]
  showcards $ThisPlayerIDX $Card
  set IsDraw 0
  return 1
}

#
# Reverse card
#
proc PlayUnoReverseCard {nick pickednum crd} {
  global IsDraw UnoIDX ThisPlayer ThisPlayerIDX PlayCard RoundRobin CardStats
  set c0 [string range $crd 0 0]
  set c1 [string range $crd 1 1]
  set cip0 [string range $PlayCard 0 0]
  set cip1 [string range $PlayCard 1 1]
  if {$c1 != "R"} {return 0}
  if {($c0 != $cip0)&&($c1 != $cip1)} {return 0}
  incr CardStats(played)
  incr CardStats(revs)
  AddToDiscardPile $PlayCard
  UnoRemoveCardFromHand $nick $pickednum
  set PlayCard $crd
  set Card [CardColor $crd]
  # Reverse RoundRobin and Move To Next Player
  set NewRoundRobin ""
  set OrigOrderLength [llength $RoundRobin]
  set IDX $OrigOrderLength
  while {$OrigOrderLength != [llength $NewRoundRobin]} {
    set IDX [expr ($IDX - 1)]
    lappend NewRoundRobin [lindex $RoundRobin $IDX]
  }
  set Newindexorder ""
  set OrigindexLength [llength $UnoIDX]
  set IDX $OrigindexLength
  while {$OrigindexLength != [llength $Newindexorder]} {
    set IDX [expr ($IDX - 1)]
    lappend Newindexorder [lindex $UnoIDX $IDX]
  }
  set UnoIDX $Newindexorder
  set RoundRobin $NewRoundRobin
  set ReversePlayer $ThisPlayer
  # Next Player After Reversing RoundRobin
  set pcount 0
  while {$pcount != [llength $RoundRobin]} {
    if {[lindex $RoundRobin $pcount] == $ThisPlayer} {
      set ThisPlayerIDX $pcount
      break
    }
    incr pcount
  }
  # <3 Players Act Like A Skip Card
  if {[llength $RoundRobin] > 2} {
    incr ThisPlayerIDX
    if {$ThisPlayerIDX >= [llength $RoundRobin]} {set ThisPlayerIDX 0}
  }
  set ThisPlayer [lindex $RoundRobin $ThisPlayerIDX]
  # No Cards Left = Winner
  if {[check_unowin $ReversePlayer $Card] > 0} {
    showwin $ReversePlayer $Card
    UnoWin $ReversePlayer
    UnoCycle
    return 1
  }
  playcard $nick $Card $ThisPlayer
  check_hasuno $ReversePlayer
  set Card [CardColorAll $ThisPlayer]
  showcards $ThisPlayerIDX $Card
  set IsDraw 0
  return 1
}

#
# Draw Two card
#
proc PlayUnoDrawTwoCard {nick pickednum crd} {
  global IsDraw ThisPlayer ThisPlayerIDX PlayCard RoundRobin CardStats UnoWildDrawTwos
  set CardOk 0
  set c0 [string range $crd 0 0]
  set c2 [string range $crd 2 2]
  set cip0 [string range $PlayCard 0 0]
  set cip1 [string range $PlayCard 1 1]
  set cip2 [string range $PlayCard 2 2]
  if {$c2 != "T"} {return 0}
  if {$c0 == $cip0} {set CardOk 1}
  if {$cip2 == "T"} {set CardOk 1}
  if {$UnoWildDrawTwos != 0} {
    if {($cip1 != "")&&($cip2 != "F")} {set CardOk 1}
  }
  if {$CardOk == 1} {
    incr CardStats(draws)
    incr CardStats(played)
    AddToDiscardPile $PlayCard
    UnoRemoveCardFromHand $nick $pickednum
    set PlayCard $crd
    set Card [CardColor $crd]
    set DrawPlayer $ThisPlayer
    set DrawPlayerIDX $ThisPlayerIDX
    # Move to the player that draws
    UnoNextPlayer
    set PlayerThatDrew $ThisPlayer
    set PlayerThatDrewIDX $ThisPlayerIDX
    # Move To The Next Player
    UnoNextPlayer
    if {[check_unowin $nick $Card] > 0} {
      UnoAddDrawToHand $PlayerThatDrew $PlayerThatDrewIDX 2
      showwin $nick $Card
      UnoWin $nick
      UnoCycle
      return 1
    }
    playdraw $nick $Card $PlayerThatDrew $ThisPlayer
    UnoAddDrawToHand $PlayerThatDrew $PlayerThatDrewIDX 2
    check_hasuno $nick
    set Card [CardColorAll $ThisPlayer]
    showcards $ThisPlayerIDX $Card
    set IsDraw 0
    return 1
  }
  return 0
}

#
# Wild Draw Four card
#
proc PlayUnoWildDrawFourCard {nick pickednum crd isrobot} {
  global ThisPlayer ThisPlayerIDX PlayCard RoundRobin IsColorChange ColorPicker CardStats
  if {[string range $crd 2 2] != "F"} {return 0}
  incr CardStats(wilds)
  incr CardStats(played)
  set ColorPicker $ThisPlayer
  AddToDiscardPile $PlayCard
  UnoRemoveCardFromHand $nick $pickednum
  set PlayCard $crd
  set Card [CardColor $crd]
  # move to the player that draws
  UnoNextPlayer
  set PlayerThatDrew $ThisPlayer
  set PlayerThatDrewIDX $ThisPlayerIDX
  if {$isrobot > 0} {
    # choose color and move to next player
    set cip [UnoBotPickAColor]
    UnoNextPlayer
  }
  if {[check_unowin $nick $Card] > 0} {
    UnoAddDrawToHand $PlayerThatDrew $PlayerThatDrewIDX 4
    showwin $nick $Card
    UnoWin $nick
    UnoCycle
    return 1
  }
  if {$isrobot > 0} {
    botplaywildfour $ColorPicker $PlayerThatDrew $ColorPicker $cip $ThisPlayer
    set ColorPicker ""
    set IsColorChange 0
  } {
    playwildfour $nick $PlayerThatDrew $ColorPicker
    set IsColorChange 1
  }
  UnoAddDrawToHand $PlayerThatDrew $PlayerThatDrewIDX 4
  check_hasuno $nick
  if {$isrobot > 0} {
    set Card [CardColorAll $ThisPlayer]
    showcards $ThisPlayerIDX $Card
  }
  set IsDraw 0
  return 1
}

#
# Wild card
#
proc PlayUnoWildCard {nick pickednum crd isrobot} {
  global IsDraw ThisPlayer ThisPlayerIDX PlayCard RoundRobin IsColorChange ColorPicker CardStats
  if {[string range $crd 0 0] != "W"} {return 0}
  incr CardStats(wilds)
  incr CardStats(played)
  set ColorPicker $ThisPlayer
  AddToDiscardPile $PlayCard
  UnoRemoveCardFromHand $nick $pickednum
  set PlayCard $crd
  set Card [CardColor $crd]
  # Ok to remove this?
  #set ThisPlayer [lindex $RoundRobin $ThisPlayerIDX]
  #set DrawnPlayer $ThisPlayer
  if {$isrobot > 0} {
    # Make A Color Choice
    set cip [UnoBotPickAColor]
    UnoNextPlayer
  }
  # No Cards Left = Winner
  if {[check_unowin $nick $Card] > 0} {
    showwin $nick $Card
    UnoWin $nick
    UnoCycle
    return 1
  }
  if {$isrobot > 0} {
    botplaywild $nick $ColorPicker $cip $ThisPlayer
    set ColorPicker ""
    set Card [CardColorAll $ThisPlayer]
    showcards $ThisPlayerIDX $Card
    set IsColorChange 0
  } {
    playwild $nick $ColorPicker
    set IsColorChange 1
  }
  check_hasuno $nick
  set IsDraw 0
  return 1
}

#
# Number card
#
proc PlayUnoNumberCard {nick pickednum crd} {
  global IsDraw ThisPlayer ThisPlayerIDX PlayCard RoundRobin CardStats
  set CardOk 0
  set c1 [string range $crd 0 0]
  set c2 [string range $crd 1 1]
  set cip1 [string range $PlayCard 0 0]
  set cip2 [string range $PlayCard 1 1]
  if {$c2 == -1} {return 0}
  if {$c1 == $cip1} {set CardOk 1}
  if {($cip2 != "")} {
    if {$c2 == $cip2} {set CardOk 1}
  }
  if {$CardOk == 1} {
    incr CardStats(played)
    AddToDiscardPile $PlayCard
    UnoRemoveCardFromHand $nick $pickednum
    set PlayCard $crd
    set Card [CardColor $crd]
    set NumberCardPlayer $ThisPlayer
    UnoNextPlayer
    if {[check_unowin $NumberCardPlayer $Card] > 0} {
      showwin $NumberCardPlayer $Card
      UnoWin $NumberCardPlayer
      UnoCycle
      return 1
    }
    playcard $nick $Card $ThisPlayer
    check_hasuno $NumberCardPlayer
    set Card [CardColorAll $ThisPlayer]
    showcards $ThisPlayerIDX $Card
    set IsDraw 0
    return 1
  }
  unontc $nick "Oops ! Ce n'est pas une carte valide, piochez (dr) ou jouez-en (pl) une autre."
  return 0
}

#
# Attempt to find card in hand
#
proc UnoFindCard {nick pickednum crd IsRobot} {
  global UnoRobot ThisPlayer ThisPlayerIDX
  #if {$Debug > 1} {unolog $UnoRobot "UnoFindCard: [lindex $UnoHand($ThisPlayer) $pickednum"}
  # Wild Draw Four
  set FoundCard [PlayUnoWildDrawFourCard $nick $pickednum $crd $IsRobot]
  if {$FoundCard == 1} {return 4}
  # Wild
  set FoundCard [PlayUnoWildCard $nick $pickednum $crd $IsRobot]
  if {$FoundCard == 1} {return 5}
  # Draw Two
  set FoundCard [PlayUnoDrawTwoCard $nick $pickednum $crd]
  if {$FoundCard == 1} {return 3}
  # Skip
  set FoundCard [PlayUnoSkipCard $nick $pickednum $crd]
  if {$FoundCard == 1} {return 1}
  # Reverse
  set FoundCard [PlayUnoReverseCard $nick $pickednum $crd]
  if {$FoundCard == 1} {return 2}
  # Number card
  set FoundCard [PlayUnoNumberCard $nick $pickednum $crd]
  if {$FoundCard == 1} {return 6}
  return 0
}

#
# Play a card
#
proc UnoPlayCard {nick uhost hand chan arg} {
  global UnoChan UnoMode IsDraw IsColorChange ColorPicker UnoPlayers RoundRobin UnoHand ThisPlayer
  if {($chan != $UnoChan)||($UnoMode != 2)||($nick != $ThisPlayer)} {return}
  UnoAutoSkipReset
  if {$IsColorChange == 1} {return}
  regsub -all \[`,.!{}\ ] $arg "" arg
  if {$arg == ""} {return}
  set pcard [string toupper [string range $arg 0 3]]
  set CardInPlayerHand 0
  set pcount 0
  while {[lindex $UnoHand($nick) $pcount] != ""} {
    if {$pcard == [lindex $UnoHand($nick) $pcount]} {
      set pcardnum $pcount
      set CardInPlayerHand 1
      break
    }
    incr pcount
  }
  if {$CardInPlayerHand == 0} {
    unontc $nick "Désolé, vous n'avez pas cette carte en main. Piochez (dr) ou jouez-en (pl) une autre."
    return
  }
  set CardFound [UnoFindCard $nick $pcardnum $pcard 0]
  switch $CardFound {
    0 {return}
    4 {return}
    5 {return}
    default {UnoRobotRestart; return}
  }
}

#
# Robot Player
#

proc UnoRobotPlayer {} {
  global Debug UnoIDX IsDraw IsColorChange ColorPicker UnoMode UnoPlayers RoundRobin UnoDeck UnoHand ThisPlayer ThisPlayerIDX PlayCard CardStats UnoRobot
  # Check for a valid card in hand
  set CardOk 0
  set IsDraw 0
  set CardCount 0
  set cip1 [string range $PlayCard 0 0]
  set cip2 [string range $PlayCard 1 1]
  while {$CardCount < [llength $UnoHand($ThisPlayer)]} {
    set playcard [lindex $UnoHand($ThisPlayer) $CardCount]
    set c1 [string range $playcard 0 0]
    set c2 [string range $playcard 1 1]
    #if {$Debug > 1} {unolog $UnoRobot "Trying: $playcard"}
    if {($c1 == $cip1)||($c2 == $cip2)||($c1 == "W")} {
      set CardOk 1
      set pcard $playcard
      set pcardnum $CardCount
      break
    }
    incr CardCount
  }
  # Play the card if found
  if {$CardOk == 1} {
    set CardFound [UnoFindCard $UnoRobot $pcardnum $pcard 1]
    switch $CardFound {
      0 {}
      5 {return}
      6 {return}
      default {UnoRobotRestart; return}
    }
  }
  # Bot draws a card
  UnoShuffle 1
  set dcardnum [rand [llength $UnoDeck]]
  set dcard [lindex $UnoDeck $dcardnum]
  lappend UnoHand($UnoRobot) "$dcard"
  set UnoDeck [lreplace ${UnoDeck} $dcardnum $dcardnum]
  showwhodrew $UnoRobot
  set CardOk 0
  set CardCount 0
  incr CardStats(drawn)
  while {$CardCount < [llength $UnoHand($ThisPlayer)]} {
    set playcard [lindex $UnoHand($ThisPlayer) $CardCount]
    set c1 [string range $playcard 0 0]
    set c2 [string range $playcard 1 1]
    # if {$Debug > 1} {unolog $UnoRobot "DrawTry: $playcard"}
    if {($c1 == $cip1)||($c2 == $cip2)||($c1 == "W")} {
      set CardOk 1
      set pcard $playcard
      set pcardnum $CardCount
      break
    }
    incr CardCount
  }
  # Bot plays drawn card or passes turn
  if {$CardOk == 1} {
    set CardFound [UnoFindCard $UnoRobot $pcardnum $pcard 1]
    if {$CardFound == 1} {UnoRobotRestart; return}
    switch $CardFound {
      0 {}
      5 {return}
      6 {return}
      default {UnoRobotRestart; return}
    }
  } {
    incr CardStats(passed)
    set IsDraw 0
    UnoNextPlayer
    playpass $UnoRobot $ThisPlayer
    set Card [CardColorAll $ThisPlayer]
    showcards $ThisPlayerIDX $Card
  }
  return
}

#
# Read config file
#
proc Uno_ReadCFG {} {
  global UnoCFGFile UnoLastMonthCards UnoLastMonthGames UnoPointsName UnoScoreFile UnoRobot UnoChan UnoFast UnoHigh UnoPlayed UnoStopAfter UnoBonus
  global UnoRecordHigh UnoRecordFast UnoRecordCard UnoRecordWins UnoRecordPlayed UnoWildDrawTwos
  if {[file exist $UnoCFGFile]} {
    set f [open $UnoCFGFile r]
    while {[gets $f s] != -1} {
      set kkey [string tolower [lindex [split $s "="] 0]]
      set kval [lindex [split $s "="] 1]
      switch $kkey {
        botname {set UnoRobot $kval}
        channel {set UnoChan $kval}
        points {set UnoPointsName $kval}
        scorefile {set UnoScoreFile $kval}
        stopafter {set UnoStopAfter $kval}
        wilddrawtwos {set UnoWildDrawTwos $kval}
        lastmonthcard1 {set UnoLastMonthCards(0) $kval}
        lastmonthcard2 {set UnoLastMonthCards(1) $kval}
        lastmonthcard3 {set UnoLastMonthCards(2) $kval}
        lastmonthwins1 {set UnoLastMonthGames(0) $kval}
        lastmonthwins2 {set UnoLastMonthGames(1) $kval}
        lastmonthwins3 {set UnoLastMonthGames(2) $kval}
        fast {set UnoFast $kval}
        high {set UnoHigh $kval}
        played {set UnoPlayed $kval}
        bonus {set UnoBonus $kval}
        recordhigh {set UnoRecordHigh $kval}
        recordfast {set UnoRecordFast $kval}
        recordcard {set UnoRecordCard $kval}
        recordwins {set UnoRecordWins $kval}
        recordplayed {set UnoRecordPlayed $kval}
      }
    }
    close $f
    if {$UnoStopAfter < 0} {set UnoStopAfter 0}
    if {$UnoBonus < 0} {set UnoBonus 1000}
    if {($UnoWildDrawTwos < 0)||($UnoWildDrawTwos > 1)} {set UnoWildDrawTwos 0}
    return
  }
  Uno_WriteCFG
  return
}

#
# Write config file
#
proc Uno_WriteCFG {} {
  global UnoCFGFile UnoLastMonthCards UnoLastMonthGames UnoPointsName UnoScoreFile UnoRobot UnoChan UnoFast UnoHigh UnoPlayed UnoStopAfter UnoBonus
  global UnoRecordHigh UnoRecordFast UnoRecordCard UnoRecordWins UnoRecordPlayed UnoWildDrawTwos
  set f [open $UnoCFGFile w]
  puts $f "# This file is automatically overwritten"
  puts $f "BotName=$UnoRobot"
  puts $f "Channel=$UnoChan"
  puts $f "Points=$UnoPointsName"
  puts $f "ScoreFile=$UnoScoreFile"
  puts $f "StopAfter=$UnoStopAfter"
  puts $f "WildDrawTwos=$UnoWildDrawTwos"
  puts $f "LastMonthCard1=$UnoLastMonthCards(0)"
  puts $f "LastMonthCard2=$UnoLastMonthCards(1)"
  puts $f "LastMonthCard3=$UnoLastMonthCards(2)"
  puts $f "LastMonthWins1=$UnoLastMonthGames(0)"
  puts $f "LastMonthWins2=$UnoLastMonthGames(1)"
  puts $f "LastMonthWins3=$UnoLastMonthGames(2)"
  puts $f "Fast=$UnoFast"
  puts $f "High=$UnoHigh"
  puts $f "Played=$UnoPlayed"
  puts $f "Bonus=$UnoBonus"
  puts $f "RecordHigh=$UnoRecordHigh"
  puts $f "RecordFast=$UnoRecordFast"
  puts $f "RecordCard=$UnoRecordCard"
  puts $f "RecordWins=$UnoRecordWins"
  puts $f "RecordPlayed=$UnoRecordPlayed"
  close $f
  return
}

#
# Read score file
#
proc UnoReadScores {} {
  global unogameswon unoptswon UnoScoreFile UnoRobot
  if [info exists unogameswon] { unset unogameswon }
  if [info exists unoptswon] { unset unoptswon }
  if ![file exists $UnoScoreFile] {
    set f [open $UnoScoreFile w]
    puts $f "$UnoRobot 0 0"
    close $f
  }
  set f [open $UnoScoreFile r]
  while {[gets $f s] != -1} {
    set unogameswon([lindex [split $s] 0]) [lindex $s 1]
    set unoptswon([lindex [split $s] 0]) [lindex $s 2]
  }
  close $f
  return
}

#
# Channel triggers
#

#
# Show current player order
#
proc UnoOrder {nick uhost hand chan arg} {
  global UnoChan UnoMode UnoPlayers RoundRobin
  if {($chan != $UnoChan)||($UnoMode < 2)} {return}
  unomsg "\00300,10 Ordre des joueurs \[$UnoPlayers\]: \00300,06 $RoundRobin "
  return
}

#
# Show game running time
#
proc UnoTime {nick uhost hand chan arg} {
  global UnoChan UnoMode
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  set unotime "\00300,10 Temps de jeu : \00300,06 [duration [game_time]] \003"
  unomsg "$unotime"
  return
}

#
# Show player what cards they hold
#
proc UnoShowCards {nick uhost hand chan arg} {
  global UnoChan UnoMode UnoHand ThisPlayerIDX
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  if [info exist UnoHand($nick)] {
    set Card ""
    set ccnt 0
    while {[llength $UnoHand($nick)] != $ccnt} {
      set pcard [lindex $UnoHand($nick) $ccnt]
      append Card [CardColor $pcard]
      incr ccnt
    }
    if {![uno_isrobot $ThisPlayerIDX]} {
      unontc $nick "En main : $Card\003"
    }
  }
  return
}

#
# Show current player
#
proc UnoTurn {nick uhost hand chan arg} {
  global UnoChan UnoMode ThisPlayer RoundRobin UnoMode
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  if {[llength $RoundRobin] < 1 } {return}
  set info "\00300,10 Au tour de : \00300,06 $ThisPlayer. \003"
  unomsg "$info"
  return
}

#
# Show current top card
#
proc UnoTopCard {nick uhost hand chan arg} {
  global PlayCard UnoChan UnoMode
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  set pcard $PlayCard
  set Card [CardColor $pcard]
  unomsg "\00300,10 Carte en jeu : \003 $Card \003"
  return
}

#
# Show card stats
#
proc UnoCardStats {nick uhost hand chan arg} {
  global UnoChan UnoMode CardStats
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  set passdraw [format "%3.1f" [get_ratio $CardStats(passed) $CardStats(drawn)]]
  set skiprev [expr $CardStats(skips) +$CardStats(revs)]
  unomsg "\00300,10 Statistiques des cartes : \00300,06 Jouées : $CardStats(played)  Ratio Passe\/Pioche : $passdraw\%  Skip\/Rev : $skiprev  DrawCards : $CardStats(draws)  WildCards : $CardStats(wilds) \003"
  return
}

#
# Card count
#
proc UnoCount {nick uhost hand chan arg} {
  global RoundRobin UnoHand UnoMode UnoChan
  if {($chan != $UnoChan)||($UnoMode != 2)} {return}
  set ordcnt 0
  set crdcnt ""
  while {[lindex $RoundRobin $ordcnt] != ""} {
    append crdcnt "\00300,10 [lindex $RoundRobin $ordcnt] \00300,06 [llength $UnoHand([lindex $RoundRobin $ordcnt])] cartes "
    incr ordcnt
  }
  unomsg "$crdcnt\003"
  return
}

#
# Show player's score
#
proc UnoWon {nick uhost hand chan arg} {
  global UnoScoreFile UnoPointsName
  regsub -all \[`,.!] $arg "" arg
  if {[string length $arg] == 0} {set arg $nick}
  set scorer [string tolower $arg]
  set pflag 0
  set f [open $UnoScoreFile r]
  while {[gets $f sc] != -1} {
    set cnick [string tolower [lindex [split $sc] 0]]
    if {$cnick == $scorer} {
      set pmsg "\00300,10 [lindex [split $sc] 0] \00300,06 [lindex $sc 2] $UnoPointsName en [lindex $sc 1] parties \003"
      set pflag 1
    }
  }
  close $f
  if {$pflag == 0} {
    set pmsg "\00300,10 $arg \00300,06 Aucun score \003"
  }
  unomsg "$pmsg"
  return
}

#
# Display current top10
#
proc UnoTopTen {nick uhost hand chan arg} {
  global UnoChan
  if {$chan != $UnoChan} {return}
  UnoTop10 1
  return
}
proc UnoTopTenWon {nick uhost hand chan arg} {
  global UnoChan
  if {$chan != $UnoChan} {return}
  UnoTop10 0
  return
}

#
# Display last month's top3
#
proc UnoTopThreeLast {nick uhost hand chan arg} {
  global UnoChan
  if {$chan != $UnoChan} {return}
  UnoLastMonthTop3 $nick $uhost $hand $chan 0
  unomsg " "
  UnoLastMonthTop3 $nick $uhost $hand $chan 1
  return
}

#
# Display month fastest game
#
proc UnoTopFast {nick uhost hand chan arg} {
  global UnoChan UnoFast
  if {$chan != $UnoChan} {return}
  unomsg "\00300,06La partie la plus rapide du mois : \00300,10 [lindex [split $UnoFast] 0] [duration [lindex $UnoFast 1]] \003"
  return
}

#
# Display month high score
#
proc UnoHighScore {nick uhost hand chan arg} {
  global UnoChan UnoHigh UnoPointsName
  if {$chan != $UnoChan} {return}
  unomsg "\00300,06Le meilleur score du mois : \00300,10 [lindex [split $UnoHigh] 0] [lindex $UnoHigh 1] $UnoPointsName \003"
  return
}

#
# Display month most cards played
#
proc UnoPlayed {nick uhost hand chan arg} {
  global UnoChan UnoPlayed
  if {$chan != $UnoChan} {return}
  unomsg "\00300,06Le plus grand nombre de cartes jouées du mois : \00300,10 [lindex [split $UnoPlayed] 0] [lindex $UnoPlayed 1] cartes \003"
  return
}

#
# Show all-time records
#
proc UnoRecords {nick uhost hand chan arg} {
  global UnoChan UnoRecordFast UnoRecordHigh UnoRecordCard UnoRecordWins UnoRecordPlayed
  if {$chan != $UnoChan} {return}
  unomsg "\00300,06Records globaux : Points \00300,10 $UnoRecordCard \00300,06 Parties \00300,10 $UnoRecordWins \00300,06 Rapide \00300,10 [lindex $UnoRecordFast 0] [duration [lindex $UnoRecordFast 1]] \00300,06 Meilleur Score \00300,10 $UnoRecordHigh \00300,06 Cartes Jouées \00300,10 $UnoRecordPlayed \003"
  return
}

#
# Display month top10
#
proc UnoTop10 {mode} {
  global UnoScoreFile unsortedscores UnoPointsName UnoRobot
  if {($mode < 0)||($mode > 1)} {set mode 0}
  switch $mode {
    0 {set winners "\00300,06 Top10 Gagnants "}
    1 {set winners "\00300,06 Top10 $UnoPointsName "}
  }
  if ![file exists $UnoScoreFile] {
    set f [open $UnoScoreFile w]
    puts $f "$UnoRobot 0 0"
    unomsg "\00300,10Le fichier des scores est vide.\003"
    close $f
    return
  }
  if [info exists unsortedscores] {unset unsortedscores}
  if [info exists top10] {unset top10}
  set f [open $UnoScoreFile r]
  while {[gets $f s] != -1} {
    switch $mode {
      0 {set unsortedscores([lindex [split $s] 0]) [lindex $s 1]}
      1 {set unsortedscores([lindex [split $s] 0]) [lindex $s 2]}
    }
  }
  close $f
  for {set s 0} {$s < 10} {incr s} {
    set top10($s) "Personne 0"
  }
  set s 0
  foreach n [lsort -decreasing -command UnoSortScores [array names unsortedscores]] {
    set top10($s) "$n $unsortedscores($n)"
    incr s
  }
  for {set s 0} {$s < 10} {incr s} {
    if {[lindex $top10($s) 1] > 0} {
      append winners "\00300,06 #[expr $s +1] \00300,10 [lindex [split $top10($s)] 0] [lindex $top10($s) 1] "
    } {
      append winners "\00300,06 #[expr $s +1] \00300,10 Personne 0 "
    }
  }
  unomsg "$winners\003"
  return
}

#
# Last month's top3
#
proc UnoLastMonthTop3 {nick uhost hand chan arg} {
  global UnoChan UnoLastMonthCards UnoLastMonthGames UnoPointsName
  if {$chan != $UnoChan} {return}
  if {$arg == 0} {
    if [info exists UnoLastMonthCards] {
      set UnoTop3 "\00300,06 Top 3 du mois dernier : $UnoPointsName gagnés "
      for { set s 0} { $s < 3 } { incr s} {
        append UnoTop3 "\00300,06 #[expr $s +1] \00300,10 $UnoLastMonthCards($s) "
      }
      unomsg "$UnoTop3"
    }
  } {
    if [info exists UnoLastMonthGames] {
      set UnoTop3 "\00300,06 Top 3 du mois dernier "
      for { set s 0} { $s < 3 } { incr s} {
        append UnoTop3 "\00300,06 #[expr $s +1] \00300,10 $UnoLastMonthGames($s) "
      }
      unomsg "$UnoTop3"
    }
  }
}

#
# Show game help
#
proc UnoCmds {nick uhost hand chan arg} {
  global UnoChan mysock
  puts "UNO : !unocmds par $nick."
  fsend $mysock(sock) ":$mysock(nick) PRIVMSG $mysock(adminchan) :\00304UNO :\017 !unocmds par \00302$nick\017."
  unontc $nick "Uno Commandes : !uno !stop !remove \[nick\] !unowon \[nick\] !unocmds"
  unontc $nick "Uno Stats : !unotop10 !unotop3last !unofast !unohigh !unorecords"
  unontc $nick "Uno Cartes : jo=join (rejoindre une partie) pl=play (jouer une carte) dr=draw (piocher) pa=pass (passer) co=color (choisir une couleur)"
  unontc $nick "Uno Jeu : ca=cards (cartes) cd=card (carte) tu=turn (au tour de) od=order (ordre des joueurs) ct=count (compte) st=stats ti=time (temps de jeu)"
  return
}

#
# Uno version
#
proc UnoVersion {nick uhost hand chan arg} {
  global UnoVersion
  unomsg "[unoad]\003 \00300,06v$UnoVersion par Marky (Traduction par Xor)\003"
  return
}

#
# Clear top10 and write monthly scores
#
proc UnoNewMonth {min hour day month year} {
  global unsortedscores unogameswon unoptswon UnoLastMonthCards UnoLastMonthGames UnoScoreFile UnoRobot
  global UnoFast UnoHigh UnoPlayed UnoRecordFast UnoRecordHigh UnoRecordPlayed UnoRecordCard UnoRecordWins
  set lmonth [UnoLastMonthName $month]
  unomsg "[unoad] \00300,04Scores du mois effacés \003"
  set UnoMonthFileName "$UnoScoreFile.$lmonth"
  # Read Current Scores
  UnoReadScores
  # Write To Old Month File
  if ![file exists $UnoMonthFileName] {
    set f [open $UnoMonthFileName w]
     foreach n [array names unogameswon] {
       puts $f "$n $unogameswon($n) $unoptswon($n)"
     }
    close $f
  }
  # Find Top 3 Card Holders and Game Winners
  set mode 0
  while {$mode < 2} {
    if [info exists unsortedscores] {unset unsortedscores}
    if [info exists top10] {unset top10}
    set f [open $UnoScoreFile r]
    while {[gets $f s] != -1} {
      switch $mode {
        0 {set unsortedscores([lindex [split $s] 0]) [lindex $s 1]}
        1 {set unsortedscores([lindex [split $s] 0]) [lindex $s 2]}
      }
    }
    close $f
    set s 0
    foreach n [lsort -decreasing -command UnoSortScores [array names unsortedscores]] {
      set top10($s) "$n $unsortedscores($n)"
      incr s
    }
    for {set s 0} {$s < 3} {incr s} {
      if {[lindex $top10($s) 1] > 0} {
       switch $mode {
          0 {set UnoLastMonthGames($s) "[lindex [split $top10($s)] 0] [lindex $top10($s) 1]"}
          1 {set UnoLastMonthCards($s) "[lindex [split $top10($s)] 0] [lindex $top10($s) 1]"}
        }
      } {
        switch $mode {
          0 {set UnoLastMonthGames($s) "Personne 0"}
          1 {set UnoLastMonthCards($s) "Personne 0"}
        }
      }
    }
    incr mode
  }
  # Update records
  if {[lindex $UnoFast 1] < [lindex $UnoRecordFast 1]} {set UnoRecordFast $UnoFast}
  if {[lindex $UnoHigh 1] > [lindex $UnoRecordHigh 1]} {set UnoRecordHigh $UnoHigh}
  if {[lindex $UnoPlayed 1] > [lindex $UnoRecordPlayed 1]} {set UnoRecordPlayed $UnoPlayed}
  if {[lindex $UnoLastMonthCards(0) 1] > [lindex $UnoRecordCard 1]} {set UnoRecordCard $UnoLastMonthCards(0)}
  if {[lindex $UnoLastMonthGames(0) 1] > [lindex $UnoRecordWins 1]} {set UnoRecordWins $UnoLastMonthGames(0)}
  # Wipe last months records
  set UnoFast "$UnoRobot 60"
  set UnoHigh "$UnoRobot 100"
  set UnoPlayed "$UnoRobot 100"
  # Save Top3 And Records To Config File
  Uno_WriteCFG
  # Wipe This Months Score File
  set f [open $UnoScoreFile w]
  puts $f "$UnoRobot 0 0"
  close $f
  unolog "uno" "Scores du mois effacés."
  return
}

#
# Update score of winning player
#
proc UnoUpdateScore {winner cardtotals} {
  global unogameswon unoptswon UnoScoreFile
  UnoReadScores
  if {[info exists unogameswon($winner)]} {
    incr unogameswon($winner)
  } {
    set unogameswon($winner) 1
  }
  if {[info exists unoptswon($winner)]} {
    incr unoptswon($winner) $cardtotals
  } {
    set unoptswon($winner) $cardtotals
  }
  set f [open $UnoScoreFile w]
  foreach n [array names unogameswon] {
    puts $f "$n $unogameswon($n) $unoptswon($n)"
  }
  close $f
  return
}

#
# Display winner and game statistics
#
proc UnoWin {winner} {
  global UnoHand ThisPlayer RoundRobin UnoPointsName CardStats UnoMode UnoCycleTime UnoFast UnoHigh UnoPlayed UnoBonus
  set cardtotals 0
  set UnoMode 3
  set ThisPlayerIDX 0
  set needCFGWrite 0
  set UnoTime [game_time]
  unomsg "\00300,06 Cartes restantes :\003"
  # Total up all player's cards
  while {$ThisPlayerIDX != [llength $RoundRobin]} {
    set Card ""
    set ThisPlayer [lindex $RoundRobin $ThisPlayerIDX]
    if {$ThisPlayer != $winner} {
      set ccount 0
      while {[lindex $UnoHand($ThisPlayer) $ccount] != ""} {
        set cardtotal [lindex $UnoHand($ThisPlayer) $ccount]
        set c1 [string range $cardtotal 0 0]
        set c2 [string range $cardtotal 1 1]
        set cardtotal 0
        if {$c1 == "W"} {
          set cardtotal 50
        } {
          switch $c2 {
            "S" {set cardtotal 20}
            "R" {set cardtotal 20}
            "D" {set cardtotal 20}
            default {set cardtotal $c2}
          }
        }
        set cardtotals [expr $cardtotals + $cardtotal]
        incr ccount
      }
      set Card [CardColorAll $ThisPlayer]
      unomsg "[strpad [nikclr $ThisPlayer] 12] $Card"
    }
    incr ThisPlayerIDX
  }
  # Check high score record
  set HighScore [lindex $UnoHigh 1]
  if {$cardtotals > $HighScore} {
    unomsg "\00300,04 $winner a battu le Meilleur Score, et gagne un bonus de $UnoBonus $UnoPointsName !\003"
    set UnoHigh "$winner $cardtotals"
    incr cardtotals $UnoBonus
    set needCFGWrite 1
  }
  # Check played cards record
  set HighPlayed [lindex $UnoPlayed 1]
  if {$CardStats(played) > $HighPlayed} {
    unomsg "\00300,04 $winner a battu le score du nombre de cartes jouées et gagne un bonus de $UnoBonus $UnoPointsName !\003"
    set UnoPlayed "$winner $CardStats(played)"
    incr cardtotals $UnoBonus
    set needCFGWrite 1
  }
  # Check fast game record
  set FastRecord [lindex $UnoFast 1]
  if {$UnoTime < $FastRecord} {
    unomsg "\00300,04 $winner a battu le record de rapidité et gagne un bonus de $UnoBonus $UnoPointsName !\003"
    incr cardtotals $UnoBonus
    set UnoFast "$winner $UnoTime"
    set needCFGWrite 1
  }
  # Winner
  unomsg "\00300,10 $winner \00300,06 $cardtotals $UnoPointsName en [duration $UnoTime] \003"
  # Card stats
  set passdraw [format "%3.1f" [get_ratio $CardStats(passed) $CardStats(drawn)]]
  set skiprev [expr $CardStats(skips) +$CardStats(revs)]
  unomsg "\00300,10 Statistiques - \00300,06 Jouées : $CardStats(played)  Ratio Passe\/Pioche : $passdraw\%  Skip\/Rev : $skiprev  DrawCards : $CardStats(draws)  WildCards : $CardStats(wilds) \003"
  unomsg "[unoad] \00300,03 Prochaine partie dans $UnoCycleTime secondes. \003"
  # Write scores
  UnoUpdateScore $winner $cardtotals
  # Write records
  if {$needCFGWrite > 0} {Uno_WriteCFG}
  return
}

#
# Re-Shuffle deck
#
proc UnoShuffle {len} {
  global UnoDeck DiscardPile
  if {[llength $UnoDeck] >= $len} { return }
  unomsg "[unoad] \00300,04 Mélange du jeu. \003"
  lappend DiscardPile "$UnoDeck"
  set UnoDeck ""
  set NewDeckSize [llength $DiscardPile]
  while {[llength $UnoDeck] != $NewDeckSize} {
    set pcardnum [rand [llength $DiscardPile]]
    set pcard [lindex $DiscardPile $pcardnum]
    lappend UnoDeck "$pcard"
    set DiscardPile [lreplace ${DiscardPile} $pcardnum $pcardnum]
  }
  return
}

#
# Score advertiser
#
proc UnoScoreAdvertise {} {
  global UnoChan UnoAdNumber UnoRobot
  unomsg " "
  switch $UnoAdNumber {
    0 {UnoTop10 0}
    1 {UnoLastMonthTop3 $UnoRobot none none $UnoChan 0}
    2 {UnoTop10 1}
    3 {UnoRecords $UnoRobot none none $UnoChan ""}
    4 {UnoPlayed $UnoRobot none none $UnoChan ""}
    5 {UnoHighScore $UnoRobot none none $UnoChan ""}
    6 {UnoTopFast $UnoRobot none none $UnoChan ""}
  }
  incr UnoAdNumber
  if {$UnoAdNumber > 6} {set UnoAdNumber 0}
  return
}

#
# Color all cards in hand
#
proc CardColorAll {cplayer} {
  global UnoHand
  set pCard ""
  set ccount 0
  while {[llength $UnoHand($cplayer)] != $ccount} {
    append pCard [CardColor [lindex $UnoHand($cplayer) $ccount]]
    incr ccount
  }
  return $pCard
}

#
# Color a single card
#
proc CardColor {pcard} {
  set cCard ""
  set c2 [string range $pcard 1 1]
  switch [string range $pcard 0 0] {
    "W" {
      if {$c2 == "D"} {
        append cCard "[wildf]"
      } {
        append cCard "[wild]"
      }
      return $cCard
    }
    "Y" {append cCard " \00301,08 Yellow "}
    "R" {append cCard " \00300,04 Red "}
    "G" {append cCard " \00300,03 Green "}
    "B" {append cCard " \00300,12 Blue "}
  }
  switch $c2 {
    "S" {append cCard "\002Skip\002 \003 "}
    "R" {append cCard "\002Reverse\002 \003 "}
    "D" {append cCard "\002Draw Two\002 \003 "}
    default {append cCard "$c2 \003 "}
  }
  return $cCard
}

#
# Check if player has Uno
#
proc check_hasuno {cplayer} {
  global UnoHand
  if {[llength $UnoHand($cplayer)] > 1} {return}
  hasuno $cplayer
  return
}

#
# Check for winner
#
proc check_unowin {cplayer ccard} {
  global UnoHand
  if {[llength $UnoHand($cplayer)] > 0} {return 0}
  return 1
}

#
# Show player what cards they have
#
proc showcards {idx pcards} {
  global UnoIDX
  if {[uno_isrobot $idx]} {return}
  unontc [lindex $UnoIDX $idx] "En main : $pcards"
}

#
# Check if this is the robot player
#
proc uno_isrobot {cplayerIDX} {
  global RoundRobin UnoRobot UnoMaxNickLen
  if {[string range [lindex $RoundRobin $cplayerIDX] 0 $UnoMaxNickLen] != $UnoRobot} {return 0}
  return 1
}

# Show played card
proc playcard {who crd nplayer} { unomsg "[nikclr $who]\003 joue $crd, \003au tour de [nikclr $nplayer].\003" }
# Show played draw card
proc playdraw {who crd dplayer nplayer} { unomsg "[nikclr $who]\003 joue $crd, [nikclr $dplayer]\003 pioche \002deux cartes\002 et passe son tour. Au tour de [nikclr $nplayer].\003" }
# Show played wildcard
proc playwild {who chooser} { unomsg "[nikclr $who]\003 joue [wild]. Choisissez une couleur [nikclr $chooser].\003" }
# Show played wild draw four
proc playwildfour {who skipper chooser} { unomsg "[nikclr $who]\003 joue [wildf], [nikclr $skipper]\003 pioche \002quatre cartes\002 et passe son tour. Choisissez une couleur [nikclr $chooser].\003" }
# Show played skip card
proc playskip {who crd skipper nplayer} { unomsg "[nikclr $who]\003 joue $crd\003 et passe le tour de [nikclr $skipper].\003 Au tour de [nikclr $nplayer].\003" }
proc showwhodrew {who} { unomsg "[nikclr $who]\003 \002pioche\002 une carte." }
proc playpass {who nplayer} { unomsg "[nikclr $who]\003 \002passe\002 son tour. Au tour de [nikclr $nplayer].\003" }
proc botplaywild {who chooser ncolr nplayer} { unomsg "[nikclr $who]\003 joue [wild] et choisit $ncolr. \003Au tour de : [nikclr $nplayer].\003" }
# Show played wild draw four
proc botplaywildfour {who skipper chooser choice nplayer} { unomsg "[nikclr $who]\003 joue [wildf], [nikclr $skipper]\003 pioche \002quatre cartes\002 et passe son tour. [nikclr $chooser]\003 choisit $choice.\003 Au tour de : [nikclr $nplayer].\003" }
# Show a player what they drew
proc showdraw {idx crd} {
  global UnoIDX
  if {[uno_isrobot $idx]} {return}
  unontc [lindex $UnoIDX $idx] "Pioche : $crd"
}

# Show Win
proc showwin {who crd} { unomsg "[nikclr $who]\003 joue $crd \003et \002G\00309A\00312G\00313N\00307E\002 [unoad]\003" }
# Show Win by default
proc showwindefault {who} { unomsg "[nikclr $who] \002G\00309A\00312G\00313N\00307E\002 [unoad]\002\003 par défaut \003" }
# Player Has Uno
proc hasuno {who} { global UnoChan mysock; fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $UnoChan :\001ACTION [nikclr $who] \002\00309d\00312i\00313t \00309U\00312n\00313o\00308 ! \017\001" }


#
# Utility Functions
#

# Check if a timer exists
proc unotimerexists {cmd} {
  set ret [after info $cmd]
  puts ret 
  if {[string match -nocase -- $cmd [info procs [lindex $ret 0]]]} { return 1 }
  return
}

# Sort Scores
proc UnoSortScores {s1 s2} {
  global unsortedscores
  if {$unsortedscores($s1) >  $unsortedscores($s2)} {return 1}
  if {$unsortedscores($s1) <  $unsortedscores($s2)} {return -1}
  if {$unsortedscores($s1) == $unsortedscores($s2)} {return 0}
}

# Calculate Game Running Time
proc game_time {} {
  global UnoStartTime
  set UnoCurrentTime [unixtime]
  set gt [expr ($UnoCurrentTime - $UnoStartTime)]
  return $gt
}

# Colorize Nickname
proc nikclr {nick} {
  global NickColor
  return "\003$NickColor($nick)$nick"
}
proc colornick {pnum} {
  global UnoNickColour
  set c [lindex $UnoNickColour [expr $pnum-1]]
  set nik [format "%02d" $c]
  return $nik
}

# Ratio Of Two Numbers
proc get_ratio {num den} {
  set n 0.0
  set d 0.0
  set n [expr $n +$num]
  set d [expr $d +$den]
  if {$d == 0} {return 0}
  set ratio [expr (($n /$d) *100.0)]
  return $ratio
}

# Name Of Last Month
proc UnoLastMonthName {month} {
  switch $month {
    00 {return "Dec"}
    01 {return "Jan"}
    02 {return "Feb"}
    03 {return "Mar"}
    04 {return "Apr"}
    05 {return "May"}
    06 {return "Jun"}
    07 {return "Jul"}
    08 {return "Aug"}
    09 {return "Sep"}
    10 {return "Oct"}
    11 {return "Nov"}
    default {return "???"}
  }
}

# String Pad
proc strpad {str len} {
  set slen [string length $str]
  if {$slen > $len} {return $str}
  while {$slen < $len} {
    append str " "
    incr slen
  }
  return $str
}

# Uno!
proc unoad {} { return "\002\00303U\00312N\00313O\00308!" }
# Wild Card
proc wild {} { return " \00301,08 \002W\00300,03I \00300,04L\00300,12D\002 \003 " }
# Wild Draw Four Card
proc wildf {} { return " \00301,08 \002W\00300,03I \00300,04L\00300,12D \00301,08D\00300,03r\00300,04a\00300,12w \00301,08F\00300,03o\00300,04u\00300,12r\002 \003 " }

#
# Channel And DCC Messages
#

proc unomsg {what} {
  global UnoChan mysock
  fsend $mysock(sock) ":$mysock(uno-nick) PRIVMSG $UnoChan :$what"
}
proc unontc {who what} {
  global UnoNTC mysock
  fsend $mysock(sock) ":$mysock(uno-nick) $UnoNTC $who :$what"
}
proc unolog {who what} {
  puts "\[$who\] $what"
}

Uno_ReadCFG
UnoReadScores

###
### Original bot
###
return 0
###
### MARK
###
# Cron Bind For Score Reset
#bind time - "00 00 01 * *" UnoNewMonth

#
# Autoskip inactive players
#
proc UnoAutoSkip {} {
  global UnoMode ThisPlayer ThisPlayerIDX RoundRobin AutoSkipPeriod IsColorChange ColorPicker
  global UnoIDX UnoPlayers UnoDeck UnoHand UnoChan UnoSkipTimer Debug NickColor UnoPaused
  if {$UnoMode != 2} {return}
  if {$UnoPaused != 0} {return}
  if {[uno_isrobot $ThisPlayerIDX]} {return}
  set Idler $ThisPlayer
  set IdlerIDX $ThisPlayerIDX
  if {[unotimerexists UnoSkipTimer] != ""} {
    unolog "uno" "AutoSkip Timer existe déjà"
    return
  }
  set InChannel 0
  set uclist [chanlist $UnoChan]
  set pcount 0
  while {[lindex $uclist $pcount] != ""} {
    if {[lindex $uclist $pcount] == $Idler} {
      set InChannel 1
      break
    }
    incr pcount
  }
  if {$InChannel == 0} {
    unomsg "[nikclr $Idler]\003 a quitté le salon, et est retiré de la partie.\003"
    if {$IsColorChange == 1} {
      if {$Idler == $ColorPicker} {
        # Make A Color Choice
        set cip [UnoPickAColor]
        unomsg "\00300,13 $Idler \003devait choisir une couleur : sélection aléatoire de $cip. \003"
        set IsColorChange 0
      } {
        unolog "uno" "UnoAutoRemove: IsColorChange set but $Idler not ColorPicker"
      }
    }
    UnoNextPlayer
    unomsg "[nikclr $Idler]\003 a joué, au tour de [nikclr $ThisPlayer].\003"
    if {![uno_isrobot $ThisPlayerIDX]} {
      set Card [CardColorAll $ThisPlayer]
      showcards $ThisPlayerIDX $Card
    }
    set UnoPlayers [expr ($UnoPlayers -1)]
    # Remove Player From Game And Put Cards Back In Deck
    if {$UnoPlayers > 1} {
      set RoundRobin [lreplace ${RoundRobin} $IdlerIDX $IdlerIDX]
      set UnoIDX [lreplace ${UnoIDX} $IdlerIDX $IdlerIDX]
      lappend UnoDeck "$UnoHand($Idler)"
      unset UnoHand($Idler)
      unset NickColor($Idler)
    }
    switch $UnoPlayers {
      1 {
         showwindefault $ThisPlayer
         UnoWin $ThisPlayer
         UnoCycle
       }
     0 {
         unomsg "[unoad] \00300,10Aucun joueur, aucun gagnant ! \003"
         UnoCycle
       }
     default {
         if {![uno_isrobot $ThisPlayerIDX]} {
           UnoAutoSkipReset
           UnoRobotRestart
         }
       }
    }
    return
  }
  if {$Debug > 0} {unolog "uno" "AutoSkip Player: $Idler"}
  unomsg "[nikclr $Idler]\003 a un idle de \00313$AutoSkipPeriod \003minutes : son tour est sauté."
  # Player Was ColorPicker
  if {$IsColorChange == 1} {
    if {$Idler == $ColorPicker} {
      # Make A Color Choice
      set cip [UnoPickAColor]
      unomsg "[nikclr $Idler]\003 devait choisir une couleur : sélection aléatoire de $cip."
      set IsColorChange 0
    } {
      unolog "uno" "UnoRemove: IsColorChange set but $Idler not ColorPicker"
    }
  }
  UnoNextPlayer
  unomsg "[nikclr $Idler]\003 a joué, au tour de [nikclr $ThisPlayer].\003"
  if {![uno_isrobot $ThisPlayerIDX]} {
    set Card [CardColorAll $ThisPlayer]
    showcards $ThisPlayerIDX $Card
  } {
    UnoRobotRestart
  }
  UnoAutoSkipReset
  return
}

#
# Pause play
#
proc UnoPause {nick uhost hand chan arg} {
  global UnoChan UnoOn UnoMode UnoPaused
  if {$chan != $UnoChan} {return}
  if {$UnoOn != 1} {return}
  if {$UnoMode != 2} {return}
  if {[is_admin $nick]} {
    if {$UnoPaused == 0} {
      set UnoPaused 1
      unomsg "[unoad] \00300,04 Pause par $nick. \003"
    } {
      set UnoPaused 0
      UnoAutoSkipReset
      unomsg "[unoad] \00300,04 Reprise du jeu par $nick. \003"
    }
  }
}

#
# Remove user from play
#
proc UnoRemove {nick uhost hand chan arg} {
  global UnoChan UnoOn UnoCycleTime UnoIDX UnoPlayers ThisPlayer ThisPlayerIDX RoundRobin UnoDeck DiscardPile UnoHand IsColorChange ColorPicker NickColor
  if {$chan != $UnoChan} {return}
  if {$UnoOn == 0} {return}
  regsub -all \[`,.!{}] $arg "" arg
  # Allow Ops To Remove Another Player
  set UnoOpRemove 0
  if {[string length $arg] > 0} {
    if {[is_admin $nick]} {
      set UnoOpRemove 1
      set UnoOpNick $nick
      set nick $arg
    } {
      return
    }
  }
  set PlayerFound 0
  # Remove Player If Found - Put Cards Back To Bottom Of Deck
  set pcount 0
  while {[lindex $RoundRobin $pcount] != ""} {
    if {[string tolower [lindex $RoundRobin $pcount]] == [string tolower $nick]} {
      set PlayerFound 1
      set FoundIDX $pcount
      set nick [lindex $RoundRobin $pcount]
      break
    }
    incr pcount
  }
  if {$PlayerFound == 1} {
    if {$UnoOpRemove > 0} {
      unomsg "[nikclr $nick]\003 retiré de la partie par $UnoOpNick."
    } {
      unontc $nick "Vous ne participez plus à la partie."
      unomsg "[nikclr $nick]\003 a quitté la partie."
    }
    # Player Was ColorPicker
    if {$IsColorChange == 1} {
      if {$nick == $ColorPicker} {
        # Make A Color Choice
        set cip [UnoPickAColor]
        unomsg "[nikclr $nick]\003 devait choisir une couleur : sélection aléatoire de $cip."
        set IsColorChange 0
      } {
        unolog "uno" "UnoRemove: IsColorChange Set but $nick not ColorPicker"
      }
    }
    if {$nick == $ThisPlayer} {
      UnoNextPlayer
      if {$UnoPlayers > 2} {
        unomsg "[nikclr $nick]\003 a joué, au tour de [nikclr $ThisPlayer].\003"
      }
      UnoAutoSkipReset
    }
    set UnoPlayers [expr ($UnoPlayers -1)]
    # Remove Player From Game And Put Cards Back In Deck
    if {$UnoPlayers > 1} {
      set RoundRobin [lreplace ${RoundRobin} $FoundIDX $FoundIDX]
      set UnoIDX [lreplace ${UnoIDX} $FoundIDX $FoundIDX]
      lappend DiscardPile "$UnoHand($nick)"
      unset UnoHand($nick)
      unset NickColor($nick)
    }
    set pcount 0
    while {[lindex $RoundRobin $pcount] != ""} {
      if {[lindex $RoundRobin $pcount] == $ThisPlayer} {
        set ThisPlayerIDX $pcount
        break
      }
      incr pcount
    }
    if {$UnoPlayers == 1} {
      showwindefault $ThisPlayer
      UnoWin $ThisPlayer
      UnoCycle
      return
    }
    UnoRobotRestart
  } {
    # Player not in current game
    return
  }
  if {$UnoPlayers == 0} {
    unomsg "[unoad] \0030,10Aucun joueur, aucun gagnant. \003"
    UnoCycle
  }
  return
}

#
# Move to next player
#
proc UnoNextPlayer {} {
  global ThisPlayer ThisPlayerIDX RoundRobin
  incr ThisPlayerIDX
  if {$ThisPlayerIDX >= [llength $RoundRobin]} {set ThisPlayerIDX 0}
  set ThisPlayer [lindex $RoundRobin $ThisPlayerIDX]
}

#
# Pick a random color for skipped/removed players
#
proc UnoPickAColor {} {
  global PlayCard
  set ucolors "r g b y"
  set pcol [string tolower [lindex $ucolors [rand [llength $ucolors]]]]
  switch $pcol {
    "r" {set PlayCard "R"; return "\00300,04 Red \003"}
    "g" {set PlayCard "G"; return "\00300,03 Green \003"}
    "b" {set PlayCard "B"; return "\00300,12 Blue \003"}
    "y" {set PlayCard "Y"; return "\00301,08 Yellow \003"}
  }
}

#
# Robot picks a color by checking hand for 1st color card
# found with matching color, else picks color at random
#
proc UnoBotPickAColor {} {
  global PlayCard UnoHand ThisPlayer
  set CardCount 0
  while {$CardCount < [llength $UnoHand($ThisPlayer)]} {
    set thiscolor [string range [lindex $UnoHand($ThisPlayer) $CardCount] 0 0]
    switch $thiscolor {
      "R" {set PlayCard "R"; return "\00300,04 Red \003"}
      "G" {set PlayCard "G"; return "\00300,03 Green \003"}
      "B" {set PlayCard "B"; return "\00300,12 Blue \003"}
      "Y" {set PlayCard "Y"; return "\00301,08 Yellow \003"}
    }
    incr CardCount
  }
  set ucolors "r g b y"
  set pcol [string tolower [lindex $ucolors [rand [llength $ucolors]]]]
  switch $pcol {
    "r" {set PlayCard "R"; return "\00300,04 Red \003"}
    "g" {set PlayCard "G"; return "\00300,03 Green \003"}
    "b" {set PlayCard "B"; return "\00300,12 Blue \003"}
    "y" {set PlayCard "Y"; return "\00301,08 Yellow \003"}
  }
}

#
# Set robot for next turn
#
proc UnoRobotRestart {} {
  global UnoMode ThisPlayerIDX RobotRestartPeriod UnoBotTimer
  if {$UnoMode != 2} {return}
  if {![uno_isrobot $ThisPlayerIDX]} {return}
  set UnoBotTimer [after [expr {int($RobotRestartPeriod * 1000)}] UnoRobotPlayer]
}

#
# Reset autoskip timer
#
proc UnoAutoSkipReset {} {
  global AutoSkipPeriod UnoMode UnoSkipTimer
  catch {after cancel $UnoSkipTimer}
  if {$UnoMode == 2} {
    set UnoSkipTimer [after [expr {int($AutoSkipPeriod * 1000 * 60)}] UnoAutoSkip]
  }
}

return 0
>>>    [expr int(rand()*[llength $MasterDeck])]
>>>    [after [expr {int($StartGracePeriod * 1000)}] UnoStart]
