PROGRAM_NAME = blink

ARDUINO_CORE_PATH = /usr/share/arduino/hardware/arduino/avr/cores/arduino

PRJ_SRC_MAIN_DIR = src
PRJ_SRC_MAIN = blink.c
PRJ_SRC_MAIN_PATH = $(PRJ_SRC_MAIN_DIR)/$(PRJ_SRC_MAIN)

BUILD_DIR = build

# Create the build directory
# $(BUILD_DIR):
# 	mkdir -pv $(BUILD_DIR)

TARGET_DEVC = atmega328p
#CLOCK = 9830400
FUSES = -U hfuse:w:0xde:m -U lfuse:w:0xff:m -U efuse:w:0x05:m

PROGRAMMER = -c arduino -b 115200 -P /dev/cu.usbmodem*
AVRDUDE = avrdude $(PROGRAMMER) -p $(TARGET_DEVC)

# Clock speed is defined in source code (?)
COMPILE = avr-gcc -Wall -Os -mmcu=$(TARGET_DEVC)
#COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(TARGET_DEVC)
# Not compiling w/ Arduino libs
#COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(TARGET_DEVC) -I$(ARDUINO_CORE_PATH)
#COMPILE = avr-gcc -mmcu=$(TARGET_DEVC) -Wall -Os -o $(BUILD_DIR)/$(PROGRAM_NAME).elf $(PRJ_SRC_MAIN_DIR)/$(PROGRAM_NAME).c

PRJ_MAIN_OBJS = blink.o
PRJ_MAIN_OBJS_DIR = $(BUILD_DIR)/obj





PRJ_MAIN_OBJS_PATH = $(PRJ_MAIN_OBJS_DIR)/$(PRJ_MAIN_OBJS)

# Tune the lines below only if you know what you are doing:

# symbolic targets:

#clean:
# 	rm -rf $(BUILD_DIR)

.PHONY: all clean flash

# All main build files
all: main.hex

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

$(PRJ_MAIN_OBJS_DIR):
	mkdir -pv $(PRJ_MAIN_OBJS_DIR)



$(PRJ_MAIN_OBJS_PATH): $(PRJ_SRC_MAIN_PATH) | $(PRJ_MAIN_OBJS_DIR)
	$(COMPILE) -c $< -o $@

flash: all
	$(AVRDUDE) -U flash:w:main.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

# Xcode uses the Makefile targets "", "clean" and "install"
install: flash fuse

# if you use a bootloader, change the command below appropriately:
load: all
	bootloadHID main.hex

# Remove specific files
clean:
	rm -rf main.hex main.elf $(PRJ_MAIN_OBJS_DIR)/*

# file targets:
main.elf: $(PRJ_MAIN_OBJS_PATH)
	$(COMPILE) -o main.elf $(PRJ_MAIN_OBJS_PATH)

main.hex: main.elf FORCE
	rm -f main.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-size --format=avr --mcu=$(TARGET_DEVC) main.elf
# If you have an EEPROM section, you must also create a hex file for the
# EEPROM and add it to the "flash" target.

# Targets for code debugging and analysis:
disasm:	main.elf
	avr-objdump -d main.elf

cpp:
	$(COMPILE) -E $(PRJ_SRC_MAIN)

FORCE: