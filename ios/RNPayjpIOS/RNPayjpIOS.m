//  PNPayjpIOS.m
#import "RNPayjpIOS.h"
#if __has_include("RCTConvert.h")
#import "RCTConvert.h"
#else
#import <React/RCTConvert.h>
#endif

@implementation RNPayjpIOS

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setPublicKey:(NSString *)key){
    mPublicKey = key;
}

static void extracted(RCTPromiseResolveBlock resolve, PAYToken *token) {
    resolve(token.identifer);
}

RCT_EXPORT_METHOD(createToken:(NSString *)number
                  cvc:(NSString *)cvc
                  expMonth:(NSString *)expMonth
                  expYear:(NSString *)expYear
                  name:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    NSLog(@"createToken has called!!");
    self.payjpClient = [[PAYAPIClient alloc] initWithPublicKey:mPublicKey];
    self.payjpClient.locale = [NSLocale currentLocale];
    [self.payjpClient createTokenWith:number
                                  cvc:cvc
                      expirationMonth:expMonth
                       expirationYear:expYear
                                 name:name
                    completionHandler:
     ^(NSError *error, PAYToken *token) {
         APIError *apiError = (APIError *)error;
         if (apiError) {
             resolve(@"error");
         }
         
         if (token != nil) {
             resolve(token.identifer);
         }
     }];
}
@end
