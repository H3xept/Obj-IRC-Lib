#import "Protocol.h"

@implementation Protocol

+(instancetype)sharedInstance{
	static Protocol privateProtocolController = nil;
	if(!privateProtocolController){
		privateProtocolController = [[self alloc] init];
	}
	return privateProtocolController;
}

-(void)handShake{

 	/* Previousy was used 
	NSData *data4 = [[NSData alloc] initWithData:[response4 dataUsingEncoding:NSASCIIStringEncoding]];
	replaced by uint8_t
	*/

	uint8_t *buf1 = (uint8_t *)[[NSString stringWithFormat:@"PASS x\r\n"] UTF8String];
	[outgoingConnection write:(const uint8_t *)buf1 maxLength:strlen((char *)buf1)];

	uint8_t *buf2 = (uint8_t *)[[NSString stringWithFormat:@"NICK x\r\n"] UTF8String];
	[outgoingConnection write:(const uint8_t *)buf2 maxLength:strlen((char *)buf2)];

	uint8_t *buf3 = (uint8_t *)[[NSString stringWithFormat:@"USER x 0 * :xx\r\n"] UTF8String];
	[outgoingConnection write:(const uint8_t *)buf3 maxLength:strlen((char *)buf3)];

}

@end