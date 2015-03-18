#import <Foundation/Foundation.h>
#import "ConnectionController.h"

@interface testClass : NSObject {}
@end

@implementation testClass

-(void)clientHasReceivedBytes:(NSMutableArray*)messageArray{
    //DELEGATE METHOD OF CONNECTION CONTROLLER - NEEDS TO BE IMPLEMENTED
    //This method is called everytime an incoming buffer is received. 
    //The arg messageArray is an NSMutableArray containing all the messages in the current incoming buffer
    //(Usually you will receive an NSMutableArray with only one element)
    //The array contains instances of IRCMessage class, which contains splitted parts and the raw message (in case
    // the splitting goes wrong since it handles only simple messages).
    /* You can easily use an approach like this to parse every substring of messageArray:
    
for(IRCMessage* msg in messageArray){
    NSLog(@"[%@]",msg.command); //<----- Look at the IRCMessage.h file
    }

*/
}
@end

int main(int argc, const char * argv[])
{
    @autoreleasepool{
        
        testClass *c = [[testClass alloc] init];

        ConnectionController* client = [[ConnectionController alloc] init];
        [client setHOST:@"light.wa.us.SwiftIRC.net"]; //first server of google list 
        [client setPORT:6667];
        [client setNick:@"Test"];
        [client setName:@"Test"];
        [client setPass:@"Test"];
        [client setMode:0];
        [client setPrintIncomingStream:YES];
        [client setDelegate:c];
        [NSThread detachNewThreadSelector:@selector(establishConnection) toTarget:client withObject:nil]; //Connection handler has to be called in a separate thread (in the next updates you'll no longer be responsible of the thread)
        [client join:@"#example"];
        [client send:[NSString stringWithFormat:@":%@ PRIVMSG #example Test",client.nick]];
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