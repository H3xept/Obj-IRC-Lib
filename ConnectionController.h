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
-(BOOL)handShake;
-(BOOL)ping;
-(BOOL)send:(NSString*)str;
@end