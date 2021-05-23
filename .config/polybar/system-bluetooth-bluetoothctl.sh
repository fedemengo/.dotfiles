#!/bin/sh

status=1

bluetooth_print() {
    bluetoothctl | while read -r line; do
        if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then

			connected=0
            #printf "on"
            #printf "#1"
			if bluetoothctl show | tr -s ' ' | grep -q "Powered: no"; then
				status=0
			else
				status=1
			fi

            devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
            counter=0

            echo "$devices_paired" | while read -r line; do
                device_info=$(bluetoothctl info "$line")

                if echo "$device_info" | grep -q "Connected: yes"; then
					connected=1

                    device_alias=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)

                    if [ $counter -gt 0 ]; then
                        printf ", %s" "$device_alias"
                    else
                        printf " %s" "$device_alias"
                    fi

                    counter=$((counter + 1))
                fi
            done

            #printf '\n'
			#echo "enabled"
			if [ "$status" == "1" ]; then
				if [ "$connected" == "0" ]; then
					printf "enabled"
				fi
				printf '\n'
				#echo "enabled"
			else
				echo "disabled"
			fi

        else
            echo "off"
        fi
    done
}

bluetooth_toggle_force() {
	if [ "$(systemctl is-active "bluetooth.service")" == "inactive" ]; then
		sudo systemctl start bluetooth.service
	else
		sudo systemctl stop bluetooth.service
	fi
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on > /dev/null
        sleep 1

        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl connect "$line" > /dev/null
        done
    else
        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl disconnect "$line" > /dev/null
        done

        bluetoothctl power off > /dev/null
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
	--force)
		bluetooth_toggle_force
		;;
    *)
        bluetooth_print
        ;;
esac

