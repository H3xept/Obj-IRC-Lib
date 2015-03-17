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

-(NSString *)craftJoinPacket:(NSString*)channel{
	return [NSString stringWithFormat:@"JOIN %@",channel];
}

-(NSMutableArray*)parse:(NSString*)dataStream{
	NSMutableArray* data = [[NSMutableArray alloc] init];
	for(NSString* msg in [dataStream componentsSeparatedByString:@"\r\n"]){

		if([[msg componentsSeparatedByString:@" "][0] hasPrefix:@":"] && ![msg isEqual:@""]){

			IRCMessage* msg = [[IRCMessage alloc] init];

			@try{
				msg.prefix = [dataStream componentsSeparatedByString:@" "][0];
			}@catch(NSException* e){}
			@try{
				msg.command = [dataStream componentsSeparatedByString:@" "][1];
			}@catch(NSException* e){}
			@try{
			msg.params = [dataStream componentsSeparatedByString:@" "][2];
			}@catch(NSException* e){}
			@try{
			msg.trailing = [dataStream componentsSeparatedByString:[NSString stringWithFormat:@"%@ :",msg.params]][1];
			}@catch(NSException* e){}

		}

	[data addObject:msg];

	}

	return data;
}

@end
