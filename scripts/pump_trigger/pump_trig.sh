#!/bin/bash

SIGNAL_FILE_PATH=/var/run/water-lemon
SIGNAL_FILENAME=do_water_lemontree.tmp
PUMP_ACT_PATH=/root/pump_trigger

function test_signal_present() {
	if [ -f "${SIGNAL_FILE_PATH}/${SIGNAL_FILENAME}" ]; then
		return 1
	else
		return 0
	fi
}

date
echo -n "start the pump? "
test_signal_present
if [ $? -eq 1 ]; then
	# remove the signal
	rm -f "${SIGNAL_FILE_PATH}/${SIGNAL_FILENAME}"
	echo "pump cycle start..."
else
	echo "no!"
	exit 0
fi

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
