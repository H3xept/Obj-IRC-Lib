/*
*	Obj-IRC –– ConnectionController.mm
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

#import "ConnectionController.h"
#import "SharedDefine.h"
#import "IRCProtocol.h"

@interface ConnectionController()
-(const char*)simpleCStringConvert:(NSString*)string;
@end

@implementation ConnectionController

-(instancetype)init 
{
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
			if(!self->authenticated) {
				int result = [self handshake];
				if(result == 0) {
#ifdef __DEBUG
	fprintf(stdout, "[+] Handshake successful!\n");
#endif	
					self->authenticated = YES;

					[NSTimer scheduledTimerWithTimeInterval:PING_TIME target:self selector:@selector(ping) userInfo:nil repeats:YES];
				} else if(result == 1) {
					fprintf(stderr, "[!] Handshake has failed. Cooldown for 10 secs...\n");
					sleep(10);
				} else if(result == -1) {
					fprintf(stderr, "[!] Handshake has failed. Please connect to the server first.\n");
				}
			}
			
			break;
	}
}

-(void)handleEventNone
{
	
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
			
			printf("%s", [self simpleCStringConvert:dataStream]);

			NSArray *arr = [dataStream componentsSeparatedByString:@"\n"];
			for (int i = 0; i < [arr count]; ++i) {
				if ([arr[i] hasPrefix:@"PING"]) {
					NSString *pingback = [arr[i] componentsSeparatedByString:@"PING :"][1];
					[self send:[NSString stringWithFormat:@"PONG :%@", pingback]];
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

-(BOOL)send:(NSString*)cmd
{
	if(self.state == kStateConnected){
		const uint8_t* buffer = (const uint8_t*)[[NSString stringWithFormat:@"%@%@", cmd, CARRIAGE] UTF8String];
		if([outgoingConnection write:buffer maxLength:strlen((char *)buffer)] == 0)
			return(0);
		else
			return(1);
	}

	return(-1);
}

-(int)handshake
{

#ifdef __DEBUG
	fprintf(stdout, "[+] Sending handshake...\n");
#endif

	NSString *hndshk_packet = [[IRCProtocol sharedInstance] craftHandshakePacket:self.nick Password:self.pass Mode:self.mode RealName:self.name];
	if([self send:hndshk_packet] == -1) {
		fprintf(stderr, "[!] Error: Are you connected?\n");
		return -1;
	}

	return 0;
}

-(int)ping
{

	int conn = [self send:@"PING :hey!"];
	if(conn != -1){
		return 1;
	}
	return 0;
}

@end