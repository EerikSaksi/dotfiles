#!/usr/bin/env bash
device="38:18:4C:59:6F:AD"

if bluetoothctl info "$device" | grep 'Connected: yes' -q; then
  bluetoothctl disconnect "$device"
else
  bluetoothctl connect "$device"
fi
