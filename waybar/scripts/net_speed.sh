#!/bin/bash

INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
sleep 1
RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

RX=$((RX2 - RX1))
TX=$((TX2 - TX1))

RX_KB=$((RX / 1024))
TX_KB=$((TX / 1024))

if [ $RX_KB -gt 1024 ]; then
    RX="$((RX_KB / 1024))MB/s"
else
    RX="${RX_KB}KB/s"
fi

if [ $TX_KB -gt 1024 ]; then
    TX="$((TX_KB / 1024))MB/s"
else
    TX="${TX_KB}KB/s"
fi

printf "  %6s |   %6s\n" "$RX" "$TX"
