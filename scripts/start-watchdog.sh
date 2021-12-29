#!/bin/bash
killpid="$(pgrep Wreckfest_x64.e)"
while true
do
	tail --pid=$killpid -f /dev/null
	kill "$(pidof tail)"
exit 0
done