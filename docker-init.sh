#!/bin/bash -e

# Check if the conf exists already
if [ ! -f /root/.btfs/config ]; then
  echo "No configuration directory found, will be initialized with this first run."
  # If we've hit this block of code then it's fair to assume this is the first run
  # Initialize the daemon
  btfs init

  # Start the daemon and let it run for a bit to setup initial file structures
  btfs daemon &
  BTFS_PID=$!
  sleep 30

  # Enable storage profile
  btfs config profile apply storage-host
  sleep 30
  btfs config show

  # Stop our process now that it has built our basic file structure
  kill $BTFS_PID
else
  echo "BTFS configuration discovered, booting normally."
fi

# Start dogecoind daemon
echo "Starting BTFS..."
btfs daemon
