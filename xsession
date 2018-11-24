# DPI
xrandr --dpi 210

# X11 Key repeat (delay / rate)
xset r rate 230 35

# DPMS monitor setting (Standby -> Suspend -> Off, in seconds)
xset dpms 500 700 900

# Disable PC speaker beeps
xset -b

# Read the Xresources file if it exists.
if [ -f ~/.Xresources ]; then
  xrdb -merge "${HOME}/.Xresources"
fi

#  vim: set ft=sh ts=2 sw=2 tw=80 noet :
