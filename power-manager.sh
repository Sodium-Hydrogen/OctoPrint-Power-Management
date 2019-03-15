# This script is meant to run on octopi.

# Path to repo
path=/home/pi/OctoPrint-Power-Management

# If true this script will also control
# the gpio pins for power relay
set_gpio=true
# This is the gpio number that the relay is
# connected to 
relay_gpio=2
gpio_path=/sys/class/gpio


running=true

que_exit() {
	echo "Killing OctoPrint-Power-Management"
	running=false
}

trap que_exit INT TERM

old_state=$(cat $path/state.txt)
$path/hub-ctrl -h 1 -P 2 -p $old_state

echo "Setting state $old_state"

if $set_gpio; then
	echo $relay_gpio > $gpio_path/export
	echo "out" > $gpio_path/gpio$relay_gpio/direction
	echo $old_state > $gpio_path/gpio$relay_gpio/value
fi

cleanup_gpio() {
	if $set_gpio; then
		echo $relay_gpio > $gpio_path/unexport
	fi
}

trap cleanup_gpio EXIT


while $running; do
	state=$(cat $path/state.txt)
	if [ "$old_state" != "$state" ]; then
		$path/hub-ctrl -h 1 -P 2 -p $state
		if $set_gpio; then
			echo $state > $gpio_path/gpio$relay_gpio/value
		fi
		old_state=$state
		echo "Setting state $old_state"
	fi
done

