/*
*	Obj-IRC –– IRCProtocol.mm
*
*	This code is under the Apache 1.0 license.
*	Please not that this version may differ
*	significantly from other branches in the
*	repo.
*
*	---
*	
*	Currently implemented commands:
*	
*	- handshake
*	- ping
*
*/

#import "IRCProtocol.h"

@implementation IRCProtocol

+(instancetype)sharedInstance{
	static IRCProtocol *privateProtocolController = nil;
	if(!privateProtocolController){
		privateProtocolController = [[self alloc] init];
	}
	return privateProtocolController;
}

-(NSString *)craftHandshakePacket:(NSString*)nick Password:(NSString*)pass Mode:(int)mode RealName:(NSString*)name
{
	return [NSString stringWithFormat:@"PASS %@\r\nNICK %@\r\nUSER %@ %d * :%@", pass, nick, nick, mode, name];
}

@end
