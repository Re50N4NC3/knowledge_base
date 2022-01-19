# ESP 8266
- [ESP 8266](#esp-8266)
  - [ESP and Micropython first steps](#esp-and-micropython-first-steps)
    - [Good tutorials and docs](#good-tutorials-and-docs)
    - [Flashing micropython](#flashing-micropython)
    - [REPL](#repl)
    - [Disable debug output](#disable-debug-output)
    - [Files in ESP](#files-in-esp)
    - [Upload local file to ESP](#upload-local-file-to-esp)
    - [Infinite loop](#infinite-loop)

## ESP and Micropython first steps
### Good tutorials and docs
- [Docs](https://docs.micropython.org/en/latest/esp8266/tutorial/) 
- [Ampy](https://blog.glugmvit.com/getting-started-with-ampy/)

### Flashing micropython
Here it will be done through`esptool`. Also you need to do it only once in the beggining.

_All references to **pip**, might require **pip3** or other way around_ 

Install `esptool`:
```console
pip3 install esptool
```

Erase flash if needed:
```console
esptool.py --port /dev/ttyUSB0 erase_flash
```

If there are any problems with esptool installation or usage, always try sudo first.
For Ubuntu, port reference should always be _/dev/ttyUSB0_. List a _dev_ directory if that's not the case, and compare list of ports while ESP is connected and disconnected.

[Download or pull the firmware](http://micropython.org/download/#esp8266) (.bin file):
- [512 kiB flash](https://micropython.org/download/esp8266-512k/)
- [1 MiB flash](https://micropython.org/download/esp8266-1m/)
- [2 MiB flash](https://micropython.org/download/esp8266/)

Deploy the firmware using:
```console
esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash --flash_size=detect 0 esp8266-20170108-v1.8.7.bin
```

[(Really good docs tutorial if needed)](https://docs.micropython.org/en/latest/esp8266/tutorial/intro.html)

### REPL
Install picocom:
```console
sudo apt install picocom
```

Connect to the ESP REPL:
```console
sudo picocom /dev/ttyUSB0 -b115200
```

To enter paste mode press `ctrl + E`

To exit REPL use: `ctrl + A -> ctrl + Q`

### Disable debug output
For convinience disable ESP debug output by typing in REPL:
```python
>> import esp
>> esp.osdebug(None)
```

### Files in ESP
ESP contains two main files `boot.py` and `main.py`. Boot runs once during boot, and main executes rest of the code. Boot shouldn't contain anything high level or computationally expensive. Connection, and one time variable initialization or library imports are also fine.

It's a good idea to put this piece of code into `boot.py`, so you don't have to redo this every time you reboot ESP. It should already be here, just uncomment it.

### Upload local file to ESP
First install ampy:
```console
sudo pip3 install adafruit-ampy
```

Then you can access `ampy` commands to run and upload local files to ESP:
- run file on ESP:
```console
sudo ampy --port /dev/ttyUSB0 run test.py
```

- put file to ESP:
```console
sudo ampy --port /dev/ttyUSB0 put test.py
```

- get file to local computer from ESP:
```console
sudo ampy --port /dev/ttyUSB0 get boot.py
```
Use `>` after command, to save command output to file locally `above_command > somefile.py`  (normally it just prints output to the console)

- list files in ESP:
```console
sudo ampy --port /dev/ttyUSB0 ls
```

- remove file or directory from ESP :
```console
sudo ampy --port /serial/port rm test.py
sudo ampy --port /serial/port rmdir /foo/bar
```

Remember, you can upload any file to ESP, so references to `.HTML`, `.js`, etc. files, for sake of code readability are fine. 

### Infinite loop
- Take care when wriring code that uses infinite loops, add visual indicators to parts of the code, and add delays after or between code runs
- Test code first in REPL, were it's easier to stop loops
- Add pysical button to interrupt code
- Add delay between loops while testing
- Remember to add garbage collection, so you won't be locked out from connecting again to the ESP
