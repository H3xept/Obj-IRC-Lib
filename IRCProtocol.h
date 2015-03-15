#import <Foundation/Foundation.h>

@class IRCMessage;

@interface IRCProtocol : NSObject{

}
+(instancetype)sharedInstance;
-(uint8_t *)generateHandShake:(NSString*)nick Password:(NSString*)pass Mode:(int)mode RealName:(NSString*)name;
-(IRCMessage*)parse:(NSString*)dataStream;
@end