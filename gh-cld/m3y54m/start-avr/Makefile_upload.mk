PROGRAM_NAME = blink
SRC_DIR = src
BUILD_DIR = build
TARGET_DEVC = atmega328p
PROGRAMMER = arduino

COMPILE = avr-gcc -mmcu=$(TARGET_DEVC) -Wall -Os -o $(BUILD_DIR)/$(PROGRAM_NAME).elf $(SRC_DIR)/$(PROGRAM_NAME).c

all: $(PROGRAM_NAME)

# Upload the built program (hex file) to Atmega328P using 
upload: $(PROGRAM_NAME)
	avrdude -c $(PROGRAMMER) -p m328p -U flash:w:$(BUILD_DIR)/$(PROGRAM_NAME).hex