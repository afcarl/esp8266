TTY=/dev/ttyUSB0
MYBOARD=sonoff

# remember to put the board in upload mode before running this
erase:
	esptool.py --port $(TTY) erase_flash

# remember to put the board in upload mode before running this
flash:
	# this works for sonoff, probably not for D1 Mini
	esptool.py --port $(TTY) write_flash -fs 1MB -fm dout 0x0 firmware/firmware-combined.bin

boot: kill-screen
	ampy -p $(TTY) put boot.py
	if [ -f wifi.ini ]; then ampy -p $(TTY) put wifi.ini; fi

libs: kill-screen
	#ampy -p $(TTY) mkdir libs
	ampy -p $(TTY) put libs/wemos_d1.py libs/wemos_d1.py
	ampy -p $(TTY) put libs/sonoff.py libs/sonoff.py
	ampy -p $(TTY) put libs/$(MYBOARD).py libs/myboard.py
	ampy -p $(TTY) put libs/led.py libs/led.py
	ampy -p $(TTY) put libs/button.py libs/button.py
	ampy -p $(TTY) put libs/potentiometer.py libs/potentiometer.py

standing_wave: kill-screen
	ampy -p $(TTY) put standing_wave/main.py main.py

analog: kill-screen
	ampy -p $(TTY) put analog/main.py main.py

potmotor: kill-screen
	ampy -p $(TTY) put potmotor/main.py main.py

button_demo: kill-screen
	ampy -p $(TTY) put libs/button.py main.py

button_relay: kill-screen
	ampy -p $(TTY) put button_relay/main.py main.py

smartplug: kill-screen
	~/micropython/mpy-cross/mpy-cross smartplug/smartplug.py
	ampy -p $(TTY) put smartplug/main.py main.py
	ampy -p $(TTY) put smartplug/smartplug.mpy smartplug.mpy

kill-screen:
	@if screen -ls | grep -q upython; then screen -X -S upython quit; fi

# use this to connect to the serial port
# to exit the screen, ctrl-A k
# DO NOT USE ctrl-A d, else the tty stays busy
screen:
	screen -S upython $(TTY) 115200

