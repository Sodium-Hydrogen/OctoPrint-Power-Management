# OctoPrint Power Management #

This is a script that will control a GPIO pin tied to a relay and disable the USB ports
on the Raspberry Pi to prevent the pi from powering the 3D printer.

--------------------
Since it isn't a good idea to give a web interface the ability to run super user commands
this script runs in the background as root waiting until the state.txt file is updated.
Once updated this script either will toggle the USB ports and, if enabled, a GPIO pin.

By default it is setup to toggle GPIO pin 2. You can change the pin in the power-manager.sh file
or disable it.

To change the pin, set `relay_gpio` to the pin you would like to use.

To disable GPIO control set `set_gpio` equal to false.

## Relay Installation ##
I suggest using a 3.3v logic level relay __That Can Handle The Max Amperage Of Your Printer.__ 5v logic level relay may not work with the Pi.

Cut the live wire (black) from the power cable and connect it to COM and NO. Leave the others untouched (white and green).

Connect the VCC to one of the RPi's 3.3v pins and GND to the RPi's ground pin.

I connected BCM 2 to the IN port.

An interactive pinout can be found [here](https://pinout.xyz/).

## Installation ##

Clone this repository to /home/pi/ if you don't want to change any files you don't have to.
```
$ git clone https://github.com/Sodium-Hydrogen/OctoPrint-Power-Management.git
```
Otherwise replace `/home/pi/OctoPrint-Power-Management` with where you installed it.
You will need to modify the `$path` variable to in `power-manager.sh`.
#### Command line ####
* Download and compile [hub-ctrl.c](https://github.com/codazoda/hub-ctrl.c).
* Copy the complied file `hub-ctrl` to this directory.
* From the command line you need to type `$ sudo crontab -e` and add `@reboot /home/pi/OctoPrint-Power-Management/power-manager.sh` to the last line.

#### OctoPrint Interface (Enclosure Plugin) ####
* Install the Octoprint plugin `Enclosure Plugin`.
* Under that plugin's settings add two new outputs, both should be `Shell Script`.
* For the power on button in the script section enter `echo 1 > /home/pi/OctoPrint-Power-Management/state.txt`
* Repeat for the power off button but enter a 0 instead of a 1 `echo 0 > ...` instead.

#### OctoPrint Interface (PSU Control) ####
* Install the Octoprint plugin `PSU Control`.
* Under that plugin's settings select system command for switching method.
* For the power on section enter `echo 1 > /home/pi/OctoPrint-Power-Management/state.txt`
* Repeat for the power off section but enter a 0 instead of a 1 `echo 0 > ...` instead.

#### Other Controls ####
If you are already using another control for psu control, et control a smart plug, then find the option for executing system commands and change the following:

* For the power on script section enter `echo 1 > /home/pi/OctoPrint-Power-Management/state.txt`
* Repeat for the power off but enter a 0 instead of a 1 `echo 0 > ...` instead.

<br>
Finally reboot your OctoPrint server for the changes to take effect.

# !Warning! #
You should remove write permissions to `power-manager.sh` and `hub-ctrl`
```
$ chmod -w power-manager.sh hub-ctrl
```


[this relay]: https://www.amazon.com/3V-Relay-Module-Optocoupler-Development/dp/B01M0E6SQM/ref=sr_1_3?keywords=3v+relay&qid=1552677200&s=gateway&sr=8-3

