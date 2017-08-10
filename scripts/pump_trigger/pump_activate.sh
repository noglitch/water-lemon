#!/bin/bash

PUMP_PIN_VAL=124

## Compute /sys GPIO path
PIO_BANK_NBR=$((${PUMP_PIN_VAL} / 32))
PIO_BANK=$(echo ${PIO_BANK_NBR} | tr "[0-9]" "[A-J]")
PIO_NBR=$((${PUMP_PIN_VAL} % 32))

PUMP_PIN="P${PIO_BANK}${PIO_NBR}"
echo "pin = ${PUMP_PIN}" >&2
GPIO_PATH=/sys/class/gpio
PUMP_PATH=${GPIO_PATH}/${PUMP_PIN}
##

if [ -d ${PUMP_PATH} ]; then
	echo "error: pin already exported" >&2
else
	echo ${PUMP_PIN_VAL} > ${GPIO_PATH}/export
fi


echo out > ${PUMP_PATH}/direction

if [ "$1" == "on" ]; then
	echo 1 >  ${PUMP_PATH}/value
	echo "pump on"
elif [ "$1" == "off" ]; then
	echo 0 >  ${PUMP_PATH}/value
	echo "pump off"
else
	echo "error: unsuported command" >&2
fi

echo ${PUMP_PIN_VAL} > ${GPIO_PATH}/unexport

exit 0
