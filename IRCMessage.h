#import <Foundation/Foundation.h>

@interface IRCMessage : NSObject{
	
}
@property (assign) NSString *prefix;
@property (assign) NSString *command;
@property (assign) NSString *params;
@property (assign) NSString *trailing;
@end