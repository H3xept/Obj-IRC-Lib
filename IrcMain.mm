#import <Foundation/Foundation.h>
#import "ConnectionController.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool{
    	ConnectionController* client = [[ConnectionController alloc] init];
    	[NSThread detachNewThreadSelector:@selector(establishConnection) toTarget:client withObject:nil];

    	while(1){
    	sleep(5);
    	//KEEPIN' CONNECTION ALIVE
    	}
    }

    return 0;
}
