CC = gcc
CFLAGS = -g -Wall -Iinclude
SRCS = $(wildcard src/*.c)
TARGET = cshell

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET) -lm

clean:
	rm -f $(TARGET)
	rm -f history.txt

.PHONY: all clean
