#import "ConnectionController.h"
#import "SharedDefine.h"

#define HOST @"irc.saurik.com"
#define PORT 6667

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
				NSLog(@"DOPE!!");
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

 	NSLog(@"Sending handshake");

	uint8_t *buf1 = (uint8_t *)[[NSString stringWithFormat:@"PASS x\r\n"] UTF8String];
	//NSData *data4 = [[NSData alloc] initWithData:[response4 dataUsingEncoding:NSASCIIStringEncoding]];
	[outgoingConnection write:(const uint8_t *)buf1 maxLength:strlen((char *)buf1)];

	uint8_t *buf2 = (uint8_t *)[[NSString stringWithFormat:@"NICK x\r\n"] UTF8String];
	[outgoingConnection write:(const uint8_t *)buf2 maxLength:strlen((char *)buf2)];

	uint8_t *buf3 = (uint8_t *)[[NSString stringWithFormat:@"USER x 0 * :xx\r\n"] UTF8String];
	[outgoingConnection write:(const uint8_t *)buf3 maxLength:strlen((char *)buf3)];
 
}
@end










