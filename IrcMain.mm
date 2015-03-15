#import <Foundation/Foundation.h>
#import "ConnectionController.h"

@interface testClass : NSObject {}
@end

@implementation testClass

-(void)clientHasReceivedBytes:(IRCMessage*)message {

    NSLog(@"--> %@", message.prefix);

}

@end

int main(int argc, const char * argv[])
{
    @autoreleasepool{
    	
        testClass *c = [[testClass alloc] init];

        ConnectionController* client = [[ConnectionController alloc] init];
    	[client setHOST:@"irc.cracksby.kim"];
    	[client setPORT:6667];
    	[client setNick:@"Test"];
    	[client setName:@"Test"];
    	[client setPass:@"Test"];
    	[client setMode:0];

        [client setDelegate:c];

    	[NSThread detachNewThreadSelector:@selector(establishConnection) toTarget:client withObject:nil];

    	while(1){
    	   sleep(5); //KEEPIN' CONNECTION ALIVE
    	}
    }

    return 0;
}
