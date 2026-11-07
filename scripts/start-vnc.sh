#!/bin/bash
set -e

export DISPLAY=:1
export HOME=/home/developer
export USER=developer

# Wait until Xvfb display :1 is truly up and accepting connections
echo "Waiting for X display :1..."
while ! xdpyinfo -display :1 >/dev/null 2>&1; do
    sleep 0.5
done
echo "Display :1 is ready. Starting x11vnc..."

VNC_ARGS=(
    -display :1
    -forever
    -shared
    -rfbport 5900
    -noshm
    -noxrecord
    -noxfixes
    -noxdamage
)

if [ -f /home/developer/.vnc/passwd ]; then
    echo "x11vnc: running with password authentication."
    VNC_ARGS+=(-rfbauth /home/developer/.vnc/passwd)
else
    echo "x11vnc: running without password (-nopw)."
    VNC_ARGS+=(-nopw)
fi

exec x11vnc "${VNC_ARGS[@]}"
