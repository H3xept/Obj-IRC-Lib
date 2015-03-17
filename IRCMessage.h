#import <Foundation/Foundation.h>

@interface IRCMessage : NSObject{
	
}
@property (assign , nonatomic) NSString *prefix;
@property (assign , nonatomic) NSString *command;
@property (assign , nonatomic) NSString *params;
@property (assign , nonatomic) NSString *trailing;
@end