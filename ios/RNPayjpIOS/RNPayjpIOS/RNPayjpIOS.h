//  RNPayjpIOS.h
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import PAYJP;

@interface RNPayjpIOS : NSObject <RCTBridgeModule>

@end
