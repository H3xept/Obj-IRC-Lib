# Obj-IRC –– jndok's branch
Simple IRC protocol implementation, in *(almost)* pure Objective-C.

## A few warning words
Before you start dumping this lib into your code, please realize that is is purely an experimental thing I'm creating with a friend of mine. So expect bugs and random errors. Also, the library is basically useless in its current state. Every branch is still being created, mine supports only 2 commands (`handshake` and `ping`).<br><br>So please be patient and we'll deliver a nice work. Thank you!

## General explanation
There isn't really much to explain, but I'll get this done.<br>`ConnectionController.h` and `ConnectionController.mm` handle and mantain the general connection stuff (sockets, etc.). `IRCProtocol.h` and `IRCProtocol.mm` define some crafting rules for packets. These are just strings, the real work is done by the `ConnectionController`. Other files are self-explanatory.

### Available commands
There are 2 commands available:

* **Handshake** –– This is a combination of `PASS`, `NICK` and `USER`. Customizable. Basically this sets up the connection with the server.
* **PING** –– Keepalive. Sent automatically every 15 seconds (customizable in `ConnectionController.h`). Ensures the server doesn't drop you out after some inactivity.

## Planned updates
Adding the rest of the commands for now.

*Please not that this branch contains my own version of the library, which may differ significantly than H3xept's one or from the `master` branch.*
