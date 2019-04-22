#!/bin/sh

# ==============================
# Xsession
# ==============================

# Make caps lock another escape
setxkbmap -option caps:escape

# Key repeat (delay / rate)
xset r rate 230 35

# DPMS monitor setting (Standby -> Suspend -> Off, in seconds)
xset dpms 500 700 900

# Disable PC speaker beeps
xset -b

# Colours etc...
xrdb -merge "${HOME}/.Xresources"
