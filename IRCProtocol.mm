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

-(void)craftJoinPacket:(NSString*)channel{
	return [NSString stringWithFormat:@"JOIN %@",channel];
}

-(IRCMessage*)parse:(NSString*)dataStream{
	if([[dataStream componentsSeparatedByString:@" "][0] hasPrefix:@":"]){

		IRCMessage* message = [[IRCMessage alloc] init];
		try{
			message.prefix = [dataStream componentsSeparatedByString:@" "][0];
		}catch(NSException* e){}
		try{
			message.command = [dataStream componentsSeparatedByString:@" "][1];
		}catch(NSException* e){}
		try{
		message.params = [dataStream componentsSeparatedByString:@" "][2];
		}catch(NSException* e){}
		try{
		message.trailing = [dataStream componentsSeparatedByString:[NSString stringWithFormat:@"%@ :",message.params]][1];
		}catch(NSException* e){}
		return message;
	}
	return nil;
}

@end
