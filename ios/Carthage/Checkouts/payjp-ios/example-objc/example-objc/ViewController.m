//
//  ViewController.m
//  example-objc
//
//  Created by Tatsuya Kitagawa on 2017/12/08.
//  Copyright © 2017年 PAY, Inc. All rights reserved.
//

#import "ViewController.h"

@import PAYJP;

NSString * const PAYJPPublicKey = @"pk_test_0383a1b8f91e8a6e3ea0e2a9";

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextField *fieldCardNumber;
@property (nonatomic, weak) IBOutlet UITextField *fieldCardCvc;
@property (nonatomic, weak) IBOutlet UITextField *fieldCardMonth;
@property (nonatomic, weak) IBOutlet UITextField *fieldCardYear;
@property (nonatomic, weak) IBOutlet UITextField *fieldCardName;
@property (nonatomic, weak) IBOutlet UILabel *labelTokenId;

@property (nonatomic, strong) PAYAPIClient *payjpClient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payjpClient = [[PAYAPIClient alloc] initWithPublicKey:PAYJPPublicKey];
    
    // You can set the locale of error message like this.
    self.payjpClient.locale = [NSLocale currentLocale];
}

#pragma MARK: - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self createToken];
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    } else if (indexPath.section == 2) {
        [self getToken];
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }
}

#pragma MARK: - fetch

- (void)createToken {
    NSString *number = self.fieldCardNumber.text;
    NSString *cvc = self.fieldCardCvc.text;
    NSString *month = self.fieldCardMonth.text;
    NSString *year = self.fieldCardYear.text;
    NSString *name = self.fieldCardName.text;
    NSLog(@"input number=%@, cvc=%@, month=%@, year=%@ name=%@", number, cvc, month, year, name);
    __weak typeof(self) wself = self;
    [self.payjpClient createTokenWith:number
                                  cvc:cvc
                      expirationMonth:month
                       expirationYear:year
                                 name:name
                    completionHandler:
     ^(NSError *error, PAYToken *token) {
         APIError *apiError = (APIError *)error;
         if (apiError) {
             id<PAYErrorResponseType> errorResponse = apiError.payError;
             NSLog(@"[errorResponse] %@", errorResponse.description);
         }
         
         if (!token) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 wself.labelTokenId.text = nil;
                 [wself showError:error];
             });
             return;
         }
         
         NSLog(@"token = %@", [wself displayToken:token]);
         dispatch_async(dispatch_get_main_queue(), ^{
             wself.labelTokenId.text = token.identifer;
             [wself.tableView reloadData];
             [wself showToken:token];
         });
     }];
}

- (void)getToken {
    NSString *tokenId = self.labelTokenId.text;
    NSLog(@"tokenId=%@", tokenId);
    __weak typeof(self) wself = self;
    [self.payjpClient getTokenWith:tokenId completionHandler:
     ^(NSError *error, PAYToken *token) {
         if (!token) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 wself.labelTokenId.text = nil;
                 [wself showError:error];
             });
             return;
         }
         
         NSLog(@"token = %@", [wself displayToken:token]);
         dispatch_async(dispatch_get_main_queue(), ^{
             wself.labelTokenId.text = token.identifer;
             [wself.tableView reloadData];
             [wself showToken:token];
         });
     }];
}

#pragma MARK: - Alert

- (void)showToken:(PAYToken *)token {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"success"
                                message:[self displayToken:token]
                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleCancel
                      handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showError:(NSError *)error {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"error"
                                message:error.localizedDescription
                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleCancel
                      handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma MARK: - misc

- (NSString *)displayToken:(PAYToken *)token {
    return [NSString stringWithFormat:@"id=%@,\ncard.id=%@,\ncard.last4=%@,\ncard.exp=%hhu/%hu\ncard.name=%@",
            token.identifer, token.card.identifer, token.card.last4Number, token.card.expirationMonth, token.card.expirationYear, token.card.name];
}

@end
