# Obj-IRC
Simple IRC protocol implementation, in *(almost)* pure Objective-C.

## A few warning words
Before you start dumping this lib into your code, please realize that is is purely an experimental thing I'm creating with a friend of mine. So expect bugs and random errors. Also, the library is basically useless in its current state. 
<br><br>So please be patient and we'll deliver a nice work. Thank you!

## General explanation
There isn't really much to explain, but I'll get this done.<br>`ConnectionController.h` and `ConnectionController.mm` handle and mantain the general connection stuff (sockets, etc.). `IRCProtocol.h` and `IRCProtocol.mm` define some crafting rules for packets. These are just strings, the real work is done by the `ConnectionController`. Other files are self-explanatory.
