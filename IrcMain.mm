#import <Foundation/Foundation.h>
#import "ConnectionController.h"

@interface testClass : NSObject {}
@end

@implementation testClass

-(void)clientHasReceivedBytes:(NSMutableArray*)messageArray{
    //Delegate method of ConnectionController class.
}
@end

int main(int argc, const char * argv[])
{
    @autoreleasepool{
        
        testClass *c = [[testClass alloc] init];

        ConnectionController* client = [[ConnectionController alloc] init];

        [client setHost:@"irc.saurik.com"]; //first server of google list 
        [client setPort:6667];
        [client setNick:@"Test"];
        [client setName:@"Test"];
        [client setPass:@"Test"];
        [client setMode:0];
        [client setPrintIncomingStream:YES];
        [client setDelegate:c];

        [client connect];

        [client join:@"#example"];
        [client leaveChannel:@"#example"];

        while(1){
            sleep(5); //Just to keep alive.
        }

    }

    return 0;
}

/*THIS IS AN UNSTABLE VERSION, USE IT CAREFULLY

//WRITTEN BY @H3xept & @Jndok

*/
