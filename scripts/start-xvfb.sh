#!/bin/bash
set -e

RES=${RESOLUTION:-"1280x800x24"}

# Remove any stale lock files from previous runs
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

echo "Starting Xvfb on display :1 with resolution ${RES}..."
exec Xvfb :1 -screen 0 "${RES}" -ac +extension GLX -noreset
