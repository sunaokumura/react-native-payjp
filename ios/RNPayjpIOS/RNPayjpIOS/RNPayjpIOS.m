//  PNPayjpIOS.m
#import "RNPayjpIOS.h"
#if __has_include("RCTConvert.h")
#import "RCTConvert.h"
#else
#import <React/RCTConvert.h>
#endif

@implementation RNPayjpIOS

NSString *publicKey;
PAYAPIClient *payjpClient;

- (instancetype)init
{
    self = [super init];
    self.publicKey = nil;
    self.payjpClient = nil;
    return self;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setPublicKey:(NSString *)publicKey){
    self.mPublicKey = publicKey;
}

RCT_EXPORT_METHOD(createToken:(NSString *)number
                  cvc:(NSString *)cvc
                  expMonth:(NSString *)expMonth
                  expYear:(NSString *)expYear
                  name:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve){
    self.payjpClient = [[PAYAPIClient alloc] initWithPublicKey:self.publicKey];
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
         
         if (!token) {
             resolve(token.identifer);
         }
     }];
}
@end
