#!/bin/bash

notify-send -u normal "`curl -u ${IP_TOKEN}: ipinfo.io -H 'Cache-Control: no-cache' 2>/dev/null | sed -e /\[{}\]/d -e 's/  "/"/g'`"

