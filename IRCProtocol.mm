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
	for(NSString* msgLine in [dataStream componentsSeparatedByString:@"\r\n"]){

		if([[msgLine componentsSeparatedByString:@" "][0] hasPrefix:@":"] && ![msgLine isEqual:@""]){

			IRCMessage* msg = [[IRCMessage alloc] init];

			@try{
				msg.prefix = [msgLine componentsSeparatedByString:@" "][0];
				if([msg.prefix hasPrefix:@":"]){
					NSMutableArray* tempPrefix =(NSMutableArray*)[msg.prefix componentsSeparatedByString:@":"];
					[tempPrefix removeObjectAtIndex:0];
					msg.prefix = tempPrefix[0];
					//NSLog(@"RCULO -> %@",msg.prefix);
				}
			}@catch(NSException* e){}
			@try{
				msg.command = [msgLine componentsSeparatedByString:@" "][1];
				//NSLog(@"RCULO -> %@",msg.command);
			}@catch(NSException* e){}
			@try{
				msg.params = [msgLine componentsSeparatedByString:@" "][2];
				//NSLog(@"RCULO -> %@",msg.params);
			}@catch(NSException* e){}
			@try{
				msg.trailing = [msgLine componentsSeparatedByString:[NSString stringWithFormat:@"%@ :",msg.params]][1];
				//NSLog(@"RCULO -> %@",msg.trailing);
			}@catch(NSException* e){}

			[data addObject:msg];
		}

	}

	return data;
}

@end
