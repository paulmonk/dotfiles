# Load user X profile
if [ -x "${HOME}/.xprofile" ]; then
  # shellcheck disable=SC1090
  source "${HOME}/.xprofile"
fi

# System Defaults
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    # shellcheck disable=SC1090
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Start i3 window-manager
exec i3

#  vim: set ft=sh ts=2 sw=2 tw=80 noet :
