#import <Foundation/Foundation.h>

@interface IRCProtocol : NSObject{
	
}
+(instancetype)sharedInstance;
-(uint8_t *)generateHandShake:(NSString*)nick Password:(NSString*)pass Mode:(int)mode RealName:(NSString*)name;
@end