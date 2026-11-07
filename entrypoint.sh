#!/bin/bash
set -e

echo "=== Initializing Ubuntu GUI Environment ==="

# Clean any stale locks from previous runs
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# Ensure /tmp/.X11-unix directory exists with sticky bit
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Ensure developer directory ownership
mkdir -p /home/developer/workspace /home/developer/.vnc /home/developer/Desktop
chown -R developer:developer /home/developer

# Configure VNC Password if provided
if [ -n "$VNC_PASSWORD" ]; then
    echo "Setting up VNC password..."
    mkdir -p /home/developer/.vnc
    x11vnc -storepasswd "$VNC_PASSWORD" /home/developer/.vnc/passwd
    chown developer:developer /home/developer/.vnc/passwd
    chmod 600 /home/developer/.vnc/passwd
else
    rm -f /home/developer/.vnc/passwd
    echo "No VNC password set. Access will be open."
fi

# Ensure log directory exists
mkdir -p /var/log/supervisor

echo "Starting supervisor daemon..."
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
