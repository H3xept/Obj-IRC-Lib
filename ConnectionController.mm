#import "ConnectionController.h"
#import "SharedDefine.h"
#import "IRCProtocol.h"

@interface ConnectionController()
-(const char*)simpleCStringConvert:(NSString*)string;
@end

@implementation ConnectionController

-(instancetype)init{
	self = [super init];
	self.state = kStateDisconnected;
	self.HOST = @"localhost";
	self.PORT = 6667;
	self.nick = @"User";
	self.name = @"User";
	self.pass = @"Pass";
	self.mode = 0;
	return self;
}

-(void)establishConnection
{
    CFReadStreamRef ingoingConnectionCF;
    CFWriteStreamRef outgoingConnectionCF;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)self.HOST, self.PORT, &ingoingConnectionCF, &outgoingConnectionCF);
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
			if(!self->authenticated){
					BOOL result = [self handShake];
					if(result==YES){
					self->authenticated = YES;
					
					[NSTimer scheduledTimerWithTimeInterval:110 target:self selector:@selector(ping) userInfo:nil repeats:YES];
				}
			}
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
		const char* host = [self.HOST cStringUsingEncoding:[NSString defaultCStringEncoding]];
		NSLog(@"%s Connected to %s:%d",IRC_NAME,host,self.PORT);
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
			dataStream = [[NSString alloc] initWithBytes:buf length:rLen encoding:NSASCIIStringEncoding];
		}
		if(dataStream){
			
			printf("%s %s",IRC_NAME,[self simpleCStringConvert:dataStream]);

			NSArray *arr = [dataStream componentsSeparatedByString:@"\n"];
			for (int i = 0; i < [arr count]; ++i) {
				if ([arr[i] hasPrefix:@"PING"]) {
					NSString *pingback = [arr[i] componentsSeparatedByString:@"PING :"][1];
					NSString *response = [NSString stringWithFormat:@"pong %@", pingback];
					[self send:response];

				}
			}

		}
	}
}

-(void)handleConnectionError
{
	const char* host = [self simpleCStringConvert:self.HOST];
	printf("%s There was an error while connecting to <%s:%d>",IRC_NAME,host,self.PORT);
}

-(void)handleDisconnected
{ 
	const char* host = [self simpleCStringConvert:self.HOST];
	printf("%s Disconnected from <%s:%d>",IRC_NAME,host,self.PORT);
}

-(const char*)simpleCStringConvert:(NSString*)string
{
	const char* str = [string cStringUsingEncoding:[NSString defaultCStringEncoding]];
	return str;
}

-(BOOL)handShake{
	uint8_t *sendStr = [[IRCProtocol sharedInstance] generateHandShake:self.nick Password:self.pass Mode:self.mode RealName:self.name];
	int conn = [outgoingConnection write:(const uint8_t *)sendStr maxLength:strlen((char *)sendStr)];

	if(conn != -1){
		return 1;
	}
	return 0;
}

-(BOOL)ping
{
	int conn = [self send:@"PING : KEEP-ALIVE"];
	if(conn != -1){
		return 1;
	}
	return 0;
}

-(BOOL)send:(NSString*)str
{
	if(self.state == kStateConnected){

	const uint8_t* buffer = (const uint8_t*)[[NSString stringWithFormat:@"%@\r\n",str] UTF8String];
	int conn = [outgoingConnection write:buffer maxLength:strlen((char *)buffer)];
	if(conn == 1)
		return 1;
	else
		return 0;

	}
	return 0;
}

@end








