#import <Foundation/Foundation.h>
#import "ConnectionController.h"

@interface testClass : NSObject {}
@end

@implementation testClass

-(void)clientHasReceivedBytes:(NSMutableArray*)messageArray{

}
@end

int main(int argc, const char * argv[])
{
    @autoreleasepool{
        
        testClass *c = [[testClass alloc] init];

        ConnectionController* client = [[ConnectionController alloc] init];
        [client setHOST:@"irc.saurik.com"]; //first server of google list 
        [client setPORT:6667];
        [client setNick:@"Test"];
        [client setName:@"Test"];
        [client setPass:@"Test"];
        [client setMode:0];
        [client setPrintIncomingStream:YES];
        [client setDelegate:c];
        [NSThread detachNewThreadSelector:@selector(establishConnection) toTarget:client withObject:nil]; //Connection handler has to be called in a separate thread (in the next updates you'll no longer be responsible of the thread)
        [client join:@"#example"];
        [client leaveChannel:@"#example"];
        while(1){
            sleep(5);
        }

    }

    return 0;
}

/*THIS IS AN UNSTABLE VERSION, USE IT CAREFULLY

//WRITTEN BY @H3xept & @Jndok

*/
