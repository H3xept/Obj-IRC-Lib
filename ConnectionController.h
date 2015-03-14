#import <Foundation/Foundation.h>
#import "SharedDefine.h"

BOOL hasReceivedData;

@interface ConnectionController : NSObject <NSStreamDelegate> {
	NSInputStream *ingoingConnection;
	NSOutputStream *outgoingConnection;
	NSString* dataStream;
}
@property connectionState state;

-(void)establishConnection;
-(void)handleEventNone;
-(void)handleConnected;
-(void)handleBytesAvailable;
-(void)handleConnectionError;
-(void)handleDisconnected;
@end