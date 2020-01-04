#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/scripts/helpers.sh

bluetooth_devices="#($CURRENT_DIR/scripts/bluetooth_devices.sh)"
bluetooth_devices_interpolation="\#{bluetooth_devices}"

set_tmux_option() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

do_interpolation() {
	local string=$1
	local all_interpolated=${string/$bluetooth_devices_interpolation/$bluetooth_devices}
	echo $all_interpolated
}

update_tmux_option() {
  local option=$1
  local option_value=$(get_tmux_option "$option")
  local new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
