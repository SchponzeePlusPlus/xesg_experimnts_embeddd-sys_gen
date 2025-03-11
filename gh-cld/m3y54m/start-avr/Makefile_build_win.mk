PROGRAM_NAME = blink
PRJ_SRC_MAIN_DIR = src
BUILD_DIR = build
TARGET_DEVC = atmega328p
PROGRAMMER = arduino

ARDUINO_CORE_PATH = C:\Program Files (x86)\Arduino\hardware\arduino\avr\cores\arduino

PRJ_SRC_MAIN = $(PROGRAM_NAME).c
OBJECTS = $(PROGRAM_NAME).o

MAIN_SOURCE = $(PRJ_SRC_MAIN_DIR)/$(PRJ_SRC_MAIN)
MAIN_OBJECT = $(OBJ_DIR)/$(OBJECTS)

COMPILE = avr-gcc -mmcu=$(TARGET_DEVC) -Wall -Os -o $(BUILD_DIR)/$(PROGRAM_NAME).elf $(PRJ_SRC_MAIN_DIR)/$(PROGRAM_NAME).c

# Tune the lines below only if you know what you are doing:

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE)

# symbolic targets:

all: main.hex

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

# Create the build directory
$(BUILD_DIR):
	mkdir -pv $(BUILD_DIR)

$(MAIN_OBJECT): $(MAIN_SOURCE)
	$(COMPILE) -c $< -o $@

# Compile and build the program for Atmega328P
$(PROGRAM_NAME): $(BUILD_DIR)
	$(COMPILE)
	avr-objcopy -j .text -j .data -O ihex $(BUILD_DIR)/$(PROGRAM_NAME).elf $(BUILD_DIR)/$(PROGRAM_NAME).hex
