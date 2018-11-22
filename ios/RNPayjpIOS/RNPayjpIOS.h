//  RNPayjpIOS.h
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import "RNPayjpIOS-Swift.h"

@interface RNPayjpIOS : NSObject <RCTBridgeModule>
{
    @private
    NSString *mPublicKey;
}

@property (nonatomic, strong) PAYAPIClient *payjpClient;

@end
