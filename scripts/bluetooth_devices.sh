CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

headphone_icon="🎧"
keyboard_icon="⌨️"

docker_icon_default() {
	if is_osx; then
		echo "$docker_icon_osx"
	else
		echo "$docker_icon"
	fi
}

devices_json() {
  result=""

  if is_osx; then
		if command_exists "jq"; then
      json="$(system_profiler SPBluetoothDataType -json -detailLevel basic | jq --compact-output '.SPBluetoothDataType[0].device_title | map([.[].device_minorClassOfDevice_string, .[].device_isconnected, .[].device_batteryPercent])')"
      json=$(echo "${json}" | jq -c 'map({ type: .[0], connected: .[1], battery: .[2] })')

      for row in $(echo "${json}" | jq -r '.[] | @base64'); do
        _jq() {
          echo ${row} | base64 --decode | jq -r ${1}
        }

        connected=$(_jq '.connected')
        class=$(_jq '.type')
        battery=$(_jq '.battery')
        compare="attrib_Yes"

        if [ "$connected" = "attrib_Yes" ]; then
          if [ "$class" = "Headphones" ]; then
            result="${result} ${headphone_icon}"
          elif  [[ $class == *"Keyboard"* ]]; then
            result="${result} ${keyboard_icon}"
          fi

          if [ "$battery" != "null" ]; then
            result="${result}  ${battery}"
          fi
        fi

        result="${result}"
      done
    fi
  fi

  echo "$result"
}

main() {
  devices_json
}
main
