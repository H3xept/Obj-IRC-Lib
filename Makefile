CC = clang

FRAMEWORKS = -framework Foundation

SOURCE = IrcMain.mm ConnectionController.mm IRCProtocol.mm

CFLAGS = -Wall -Werror -g $(SOURCE)
LDFLAGS = $(LIBRARIES) $(FRAMEWORKS)
OUT = -o main

all:
	$(CC) $(CFLAGS) $(LDFLAGS) $(OUT)
	
#-v verbose REMEBMER H3X!