#import "IRCProtocol.h"
#import "IRCMessage.h"

@implementation IRCProtocol

+(instancetype)sharedInstance{
	static IRCProtocol *privateProtocolController = nil;
	if(!privateProtocolController){
		privateProtocolController = [[self alloc] init];
	}
	return privateProtocolController;
}

-(NSString *)craftHandshakePacket:(NSString*)nick Password:(NSString*)pass Mode:(int)mode RealName:(NSString*)name
{
	return [NSString stringWithFormat:@"PASS %@\r\nNICK %@\r\nUSER %@ %d * :%@", pass, nick, nick, mode, name];
}

-(IRCMessage*)parse:(NSString*)dataStream{
	if([[dataStream componentsSeparatedByString:@" "][0] hasPrefix:@":"]){

		IRCMessage* message = [[IRCMessage alloc] init];

		message.prefix = [dataStream componentsSeparatedByString:@" "][0];
		message.command = [dataStream componentsSeparatedByString:@" "][1];
		message.params = [dataStream componentsSeparatedByString:@" "][2];
		message.trailing = [dataStream componentsSeparatedByString:[NSString stringWithFormat:@"%@ :",message.params]][1];

		return message;
	}
	return nil;
}

@end
