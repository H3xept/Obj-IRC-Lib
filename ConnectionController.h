#define __DEBUG

#define CARRIAGE @"\r\n"
#define PING_TIME 110

#import <Foundation/Foundation.h>
#import "SharedDefine.h"
#import "IRCProtocol.h"
#import "IRCMessage.h"

@interface ConnectionController : NSObject <NSStreamDelegate> {
	NSInputStream *ingoingConnection;
	NSOutputStream *outgoingConnection;
	NSString* dataStream;
	NSMutableArray* parsedBuffer;
	BOOL authenticated;
	NSMutableArray* cmdQueue;
	BOOL didSendPong;
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

-(void)establishConnection;
-(void)handleEventNone;
-(void)handleConnected;
-(void)handleBytesAvailable;
-(void)handleConnectionError;
-(void)handleDisconnected;
-(int)send:(NSString*)cmd;
-(void)clientHasReceivedBytes:(IRCMessage*)message;
-(int)handshake;
-(int)ping;
-(void)endConnection;

@end