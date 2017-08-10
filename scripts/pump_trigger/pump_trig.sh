#!/bin/bash

PUMP_ACT_PATH=/root/pump_trigger

echo "pump cycle start"
date
for i in $(seq 1 4); do
	${PUMP_ACT_PATH}/pump_activate.sh on
	sleep 25
	${PUMP_ACT_PATH}/pump_activate.sh off
	sleep 10
done

# just to make sure
date
echo "pump cycle finished"
${PUMP_ACT_PATH}/pump_activate.sh off
exit 0
