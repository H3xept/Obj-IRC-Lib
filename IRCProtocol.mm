#import "IRCProtocol.h"

@implementation IRCProtocol

+(instancetype)sharedInstance{
	static IRCProtocol *privateProtocolController = nil;
	if(!privateProtocolController){
		privateProtocolController = [[self alloc] init];
	}
	return privateProtocolController;
}

-(uint8_t *)generateHandShake:(NSString*)nick Password:(NSString*)pass Mode:(int)mode RealName:(NSString*)name{

 	/* Previousy was used 
	NSData *data4 = [[NSData alloc] initWithData:[response4 dataUsingEncoding:NSASCIIStringEncoding]];
	replaced by uint8_t
	*/

	uint8_t *buf = (uint8_t *)[[NSString stringWithFormat:@"PASS %@\r\nNICK %@\r\nUSER %@ %d * :%@\r\n",pass,nick,nick,mode,name] UTF8String];
	return buf;

}

@end
