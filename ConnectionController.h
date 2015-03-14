#import <Foundation/Foundation.h>
#import "SharedDefine.h"

@interface ConnectionController : NSObject <NSStreamDelegate> {
	NSInputStream *ingoingConnection;
	NSOutputStream *outgoingConnection;
	NSString* dataStream;
}
@property connectionState state;
@property (assign) NSString* HOST;
@property (assign) int PORT;

-(void)establishConnection;
-(void)handleEventNone;
-(void)handleConnected;
-(void)handleBytesAvailable;
-(void)handleConnectionError;
-(void)handleDisconnected;
@end