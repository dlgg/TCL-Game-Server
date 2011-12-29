#!/bin/bash

pid=`cat tcl.pid`

run=`ps x | grep -v grep | grep $pid`

if [ $? -eq 1 ]  ; then
  screen -dmS TclGameServer ./main.tcl
else
  exit
fi 
