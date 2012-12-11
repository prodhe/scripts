#!/bin/sh

echo "Shutting down interface: en0"
sudo ifconfig en0 down

echo "Flushing routes..."
for i in {1..10}
do
	sudo route -n flush
done

echo "Activating interface: en0"
sudo ifconfig en0 up
