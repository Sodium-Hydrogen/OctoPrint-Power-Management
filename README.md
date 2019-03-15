# OctoPrint Power Management #

This is a script that will control a GPIO pin tied to a relay and disable the USB ports
on the Raspberry Pi to prevent the pi from powering the 3D printer.
<br>
I used [this relay].
<br>
Cut the live wire from the power cable and connect it to COM and NO. Leave the others untouched.
<br>
Connect the VCC to one of the RPi's 3.3v pins and GND to the RPi's ground pin.
<br>
I connected BCM 2 to the IN port.
<br>
An interactive pinout can be found [here](https://pinout.xyz/).

--------------------
Since it isn't a good idea to give a web interface the ability to run super user commands
this script runs in the background as root waiting until the state.txt file is updated.
Once updated this script either will toggle the USB ports and, if enabled, a GPIO pin.
<br>
By default it is setup to toggle GPIO pin 2. You can change the pin in the power-manager.sh file
or disable it.
<br>
To change the pin, set `relay_gpio` to the pin you would like to use.
<br>
To disable GPIO control set `set_gpio` equal to false.

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

#### OctoPrint Interface ####
* Install the Octoprint plugin `Enclosure Plugin`.
* Under that plugin's settings add two new outputs, both should be `Shell Script`.
* For the power off button in the script section enter `echo 0 > /home/pi/OctoPrint-Power-Management/state.txt`
* Repeat for the power on button but type `echo 1 > ...` instead.

<br>
Finally reboot your OctoPrint server for the changes to take effect.


[this relay]: https://www.amazon.com/3V-Relay-Module-Optocoupler-Development/dp/B01M0E6SQM/ref=sr_1_3?keywords=3v+relay&qid=1552677200&s=gateway&sr=8-3

