#import <Foundation/Foundation.h>

@class IRCMessage;

@interface IRCProtocol : NSObject{

}
+(instancetype)sharedInstance;
-(IRCMessage*)parse:(NSString*)dataStream;
-(NSString *)craftHandshakePacket:(NSString*)nick Password:(NSString*)pass Mode:(int)mode RealName:(NSString*)name;
-(void)craftJoinPacket:(NSString*)channel;
@end