#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
screen -S ddns -p 0 -X quit
screen -S "ddns" -U -m -d bash update-home-ip-cf.sh
