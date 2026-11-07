#!/bin/bash
set -e

export DISPLAY=:1
export HOME=/home/developer
export USER=developer
export LIBGL_ALWAYS_SOFTWARE=1

# Wait until X server is ready
echo "Waiting for Xvfb display :1..."
while ! xdpyinfo -display :1 >/dev/null 2>&1; do
    sleep 0.5
done
echo "Xvfb is ready. Launching XFCE desktop..."

# Disable screen blanking / power saving inside container
xset s off -dpms 2>/dev/null || true

exec dbus-launch --exit-with-session startxfce4

