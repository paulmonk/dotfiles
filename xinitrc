#!/bin/sh
#
# ==============================
# Xinitrc
# ==============================
#

# System Defaults
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    # shellcheck disable=SC1090
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# User Xprofile
if [ -f "${HOME}/.xprofile" ]; then
  # shellcheck disable=SC1090
  . "${HOME}/.xprofile"
fi

# User Xsession
if [ -f "${HOME}/.xsession" ]; then
  # shellcheck disable=SC1090
  . "${HOME}/.xsession"
fi

# Start i3 window-manager
exec i3
