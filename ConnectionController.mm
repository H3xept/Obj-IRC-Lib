#import "ConnectionController.h"
#import "SharedDefine.h"

#define HOST @"irc.saurik.com"
#define PORT 6667

int p;

@interface ConnectionController()
-(const char*)simpleCStringConvert:(NSString*)string;
@end

@implementation ConnectionController

-(instancetype)init{
	self = [super init];
	self.state = kStateDisconnected;
	return self;
}

-(void)establishConnection
{
    CFReadStreamRef ingoingConnectionCF;
    CFWriteStreamRef outgoingConnectionCF;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)HOST, PORT, &ingoingConnectionCF, &outgoingConnectionCF);
    ingoingConnection = (NSInputStream *)ingoingConnectionCF;
    outgoingConnection = (NSOutputStream *)outgoingConnectionCF;

	[ingoingConnection setDelegate:self];
	[outgoingConnection setDelegate:self];

	[ingoingConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outgoingConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

	[ingoingConnection open];
	[outgoingConnection open];

	[[NSRunLoop currentRunLoop] run];
}


-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	switch(streamEvent){
		case NSStreamEventNone:
			[self handleEventNone];
			break;
		case NSStreamEventOpenCompleted:
			[self handleConnected];
			break;
		case NSStreamEventHasBytesAvailable:
			[self handleBytesAvailable];
			break;
		case NSStreamEventErrorOccurred:
			[self handleConnectionError];
			break;
		case NSStreamEventEndEncountered:
			[self handleDisconnected];
			break;
		case NSStreamEventHasSpaceAvailable:
			NSLog(@"SPACE!");
			break;
		}
}

-(void)handleEventNone
{
	printf("%s",IRC_NAME);
}

-(void)handleConnected
{	
	if(self.state == kStateDisconnected){
	const char* host = [HOST cStringUsingEncoding:[NSString defaultCStringEncoding]];
	NSLog(@"%s Connected to %s:%d",IRC_NAME,host,PORT);
	self.state = kStateConnected;
	}
}

-(void)handleBytesAvailable
{
	uint8_t buf[1024];
	int rLen; 
	while([ingoingConnection hasBytesAvailable]){
		rLen = [ingoingConnection read:buf maxLength:sizeof(buf)];
		if(rLen > 0){//GOT DATA
			__unused NSString* dataStream = [[NSString alloc] initWithBytes:buf length:rLen encoding:NSASCIIStringEncoding];
			NSLog(@"DATA? %@", [[NSString alloc] initWithBytes:buf length:rLen encoding:NSASCIIStringEncoding]);
			if(!hasReceivedData){
				hasReceivedData = YES;
				[self joinChat];
			}
		}
		if(dataStream){
			printf("%s %s",IRC_NAME,[self simpleCStringConvert:dataStream]);
		}
	}
}

-(void)handleConnectionError
{
	const char* host = [self simpleCStringConvert:HOST];
	printf("%s There was an error while connecting to <%s:%d>",IRC_NAME,host,PORT);
}

-(void)handleDisconnected
{
	const char* host = [self simpleCStringConvert:HOST];
	printf("%s Disconnected from <%s:%d>",IRC_NAME,host,PORT);
}

-(const char*)simpleCStringConvert:(NSString*)string
{
	const char* str = [string cStringUsingEncoding:[NSString defaultCStringEncoding]];
	return str;
}

-(void)joinChat{
	if(!p){
 	NSLog(@"UMH");

	NSString *response4  = @"PASS Try";
	NSData *data4 = [[NSData alloc] initWithData:[response4 dataUsingEncoding:NSASCIIStringEncoding]];
	[outgoingConnection write:(const uint8_t *)[data4 bytes] maxLength:[data4 length]];

	NSString *response  = @"NICK Try";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outgoingConnection write:(const uint8_t *)[data bytes] maxLength:[data length]];

	NSString *response2  = @"USER Try 0 * :Try";
	NSData *data2 = [[NSData alloc] initWithData:[response2 dataUsingEncoding:NSASCIIStringEncoding]];
	[outgoingConnection write:(const uint8_t *)[data2 bytes] maxLength:[data2 length]];

	NSString *response3  = @"JOIN #chat";
	NSData *data3 = [[NSData alloc] initWithData:[response3 dataUsingEncoding:NSASCIIStringEncoding]];
	[outgoingConnection write:(const uint8_t *)[data3 bytes] maxLength:[data3 length]];
	p = 1;
	sleep(2);
}
 
}
@end










