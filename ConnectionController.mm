#import "ConnectionController.h"
#import "SharedDefine.h"

#define HOST @"localhost"
#define PORT 8000

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
	uint8_t* buf;
	NSLog(@"SIZE -> %lu",sizeof(buf));
}

-(void)handleConnectionError
{
	const char* host = [HOST cStringUsingEncoding:[NSString defaultCStringEncoding]];
	printf("%s There was an error while connecting to <%s:%d>",IRC_NAME,host,PORT);
}

-(void)handleDisconnected
{
	const char* host = [HOST cStringUsingEncoding:[NSString defaultCStringEncoding]];
	printf("%s Disconnected from <%s:%d>",IRC_NAME,host,PORT);
}

@end










