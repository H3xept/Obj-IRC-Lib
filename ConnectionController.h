#define __DEBUG

#define CARRIAGE @"\r\n"
#define PING_TIME 110

#import <Foundation/Foundation.h>
#import "SharedDefine.h"
#import "IRCProtocol.h"
#import "IRCMessage.h"

@class IRCMessage;

@interface ConnectionController : NSObject <NSStreamDelegate> {
	NSInputStream *ingoingConnection;
	NSOutputStream *outgoingConnection;
	NSString* dataStream;
	NSMutableArray* parsedBuffer;
	BOOL authenticated;
	BOOL didSendPong;
	BOOL finishedRegistering;
}

@property (assign) id delegate;
@property connectionState state;
@property (assign) NSString* HOST;
@property (assign) int PORT;
@property (assign) NSString* nick;
@property (assign) NSString* name;
@property (assign) NSString* pass;
@property int mode;
@property BOOL printIncomingStream;

-(BOOL)getAuthenticated;

-(void)establishConnection;
-(void)handleEventNone;
-(void)handleConnected;
-(void)handleBytesAvailable;
-(void)handleConnectionError;
-(void)handleDisconnected;
-(int)send:(NSString*)cmd;
-(void)clientHasReceivedBytes:(NSMutableArray*)messageArray;
-(int)handshake;
-(int)ping;
-(int)join:(NSString*)channel;
-(void)endConnection;
-(void)leaveChannel:(NSString*)channel;

@end