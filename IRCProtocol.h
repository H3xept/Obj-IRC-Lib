/*
*	Obj-IRC –– IRCProtocol.h
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

#import <Foundation/Foundation.h>

@class IRCMessage;

@interface IRCProtocol : NSObject{

}
+(instancetype)sharedInstance;
-(IRCMessage*)parse:(NSString*)dataStream;
-(NSString *)craftHandshakePacket:(NSString*)nick Password:(NSString*)pass Mode:(int)mode RealName:(NSString*)name;
@end