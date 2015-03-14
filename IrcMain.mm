#import <Foundation/Foundation.h>
#import "ConnectionController.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool{
    	ConnectionController* client = [[ConnectionController alloc] init];
    	[client setHOST:@"irc.saurik.com"];
    	[client setPORT:6667];
    	[client setNick:@"Test"];
    	[client setName:@"Test"];
    	[client setPass:@"Test"];
    	[client setMode:0];
    	[NSThread detachNewThreadSelector:@selector(establishConnection) toTarget:client withObject:nil];
    	sleep(5);
       	[client handShake];

    	while(1){
    	sleep(5);
    	//KEEPIN' CONNECTION ALIVE
    	}
    }

    return 0;
}
