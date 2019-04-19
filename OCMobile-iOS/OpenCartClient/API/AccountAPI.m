//
//  AccountAPI.m
//  OpenCartClient
//
//  Created by Sam Chen on 27/06/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "AccountAPI.h"
#import "Network.h"
#import "Customer.h"

@implementation AccountAPI

+ (AccountAPI *)sharedInstance {
    static AccountAPI *_sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[AccountAPI alloc] init];
    });

    return _sharedInstance;
}

- (void)requestNewAccessTokenWithBlock:(ResponseDataBlock)callback { // Ask for a different access token
    [[Customer sharedInstance] logout];
    [self requestAccessTokenWithBlock:callback];
}

- (void)refreshAccountInfoWithBlock:(ResponseDataBlock)callback {
    [[Network sharedInstance] GET:@"account/me" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (error) {
            [MBProgressHUD showToastToView:[UIApplication sharedApplication].keyWindow.rootViewController.view withMessage:error];

            if (callback) {
                callback(nil, error);
            }
        }

        if (data) {
            NSLog(@"Token valid for account. Account info updated.");
            AccountModel *account = [[AccountModel alloc] initWithDictionary:data error:nil];
            [[Customer sharedInstance] save:account];

            if (callback) {
                callback(data, nil);
            }
        }
    }];
}

- (void)requestAccessTokenWithBlock:(ResponseDataBlock)callback { // Check if current access token is valid
    [[Network sharedInstance] POST:@"account/token" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (error) {
            [MBProgressHUD showToastToView:[UIApplication sharedApplication].keyWindow.rootViewController.view withMessage:error];

            if (callback) {
                callback(nil, error);
            }
        }

        if ([data objectForKey:@"access_token"]) {
            NSString *accessToken = [data objectForKey:@"access_token"];
            NSLog(@"Requested new access token: %@", accessToken);
            [[Customer sharedInstance] setAccessToken:accessToken];

            if (callback) {
                callback(data, nil);
            }
        }
    }];
}
@end
