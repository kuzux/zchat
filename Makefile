LIBS:=-lzmq
CFLAGS:=-g -O2 -Wall -Werror
BINS:=server client

all: server client

.PHONY: all clean

server: server.c
	gcc $< -o $@ $(CFLAGS) $(LIBS)

client: client.c
	gcc $< -o $@ $(CFLAGS) $(LIBS)

clean:
	rm *.o $(BINS)

