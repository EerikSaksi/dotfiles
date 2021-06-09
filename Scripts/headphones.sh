#!/usr/bin/env bash
device="94:DB:56:BA:97:5F"

if bluetoothctl info "$device" | grep 'Connected: yes' -q; then
  bluetoothctl disconnect "$device"
else
  bluetoothctl connect "$device"
fi
