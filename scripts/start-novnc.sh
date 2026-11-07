#!/bin/bash
set -e

# Wait until VNC port 5900 is listening
echo "Waiting for VNC port 5900 to become available..."
while ! nc -z 127.0.0.1 5900 >/dev/null 2>&1 && ! (echo > /dev/tcp/127.0.0.1/5900) >/dev/null 2>&1; do
    sleep 0.5
done
echo "VNC port 5900 is listening. Starting noVNC websockify bridge on port 6080..."

exec websockify --web=/usr/share/novnc 6080 localhost:5900
