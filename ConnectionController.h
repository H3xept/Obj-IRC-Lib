/*
*	Obj-IRC –– ConnectionController.h
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

#define __DEBUG

#define CARRIAGE @"\r\n"
#define PING_TIME 110

#import <Foundation/Foundation.h>
#import "SharedDefine.h"

@interface ConnectionController : NSObject <NSStreamDelegate> {
	NSInputStream *ingoingConnection;
	NSOutputStream *outgoingConnection;
	NSString* dataStream;
	NSMutableArray* parsedBuffer;
	BOOL authenticated;
}

@property connectionState state;
@property (assign) NSString* HOST;
@property (assign) int PORT;
@property (assign) NSString* nick;
@property (assign) NSString* name;
@property (assign) NSString* pass;
@property int mode;

-(void)establishConnection;
-(void)handleEventNone;
-(void)handleConnected;
-(void)handleBytesAvailable;
-(void)handleConnectionError;
-(void)handleDisconnected;
-(BOOL)send:(NSString*)cmd;

-(int)handShake;
-(int)ping;

@end