//
//  Customer.m
//  OpenCartClient
//
//  Created by Sam Chen on 10/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "Customer.h"
#import "AppDelegate.h"
#import <JSONModel/JSONHTTPClient.h>
#import "StatusModel.h"
#import "AccountAPI.h"

#define ACCOUNT_INFO_KEY @"account_info"
#define ACCESS_TOKEN_KEY @"access_token"

// Data struct
/*
 {
 "account_info": {
 "customer_id": 1,
 "firstname": "opencart.cn",
 "email": "support@opencart.cn",
 "telephone": "13988889999",
 "avatar": "http://app.opencartdemo.cn/image/app_image_cache/app/avatar/1-200x200.png",
 "social_avatar": "",
 "cart_number": 1,
 "access_token": "xxxxxx",
 "unpaid_orders": 1,
 "paid_orders": 1,
 "shipped_orders": 0,
 "unreviewed_order_products": 0
 }
 }
 */

@interface Customer()
@property (strong, nonatomic) AccountModel *account;
@end

@implementation Customer

+ (Customer *)sharedInstance {
    static Customer *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[Customer alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:ACCOUNT_INFO_KEY]) {
            _account = [[AccountModel alloc] initWithDictionary:[defaults objectForKey:ACCOUNT_INFO_KEY] error:nil];
        } else {
            _account = [[AccountModel alloc] init];
        }
    }
    return self;
}

- (AccountModel *)account {
    return _account;
}

- (void)save:(AccountModel *) account {
    if (account) {
        _account = account;

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[_account toDictionary] forKey:ACCOUNT_INFO_KEY];
        [defaults synchronize];

        NSData *json = [NSJSONSerialization dataWithJSONObject:[defaults objectForKey:ACCOUNT_INFO_KEY] options:0 error:nil];
        NSLog(@"Account updated: %@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"Accout object is nil");
    }

    [[Network sharedInstance] updateAccessTokenForHTTPHeaderField];
}

- (BOOL)isLogged {
    return (_account.customerId > 0);
}

- (void)logout {
    _account = [[AccountModel alloc] init];

    [self save:_account];

    NSLog(@"Account reset to default");
}

- (NSString *)accessToken {
    return _account.accessToken;
}

- (void)setAccessToken:(NSString *)accessToken {
    if (accessToken.length <= 0) {
        NSLog(@"accessToken is nil");
        return;
    }

    NSLog(@"New access token: %@", accessToken);

    _account.accessToken = accessToken;

    [self save:_account];
}

- (NSInteger)cartNumber {
    return _account.cartNumber;
}

- (void)resetCartNumber {
    _account.cartNumber = 0;
    [self save:_account];
}

- (NSInteger)addCartNumberBy:(NSInteger)number {
    NSInteger newCartNumber = [self cartNumber] + number;

    _account.cartNumber = newCartNumber;
    [self save:_account];

    return newCartNumber;
}

- (NSInteger)setCartNumber:(NSInteger)number {
    AccountModel *account = [self account];
    account.cartNumber = number;
    [self save:account];

    return number;
}

- (void)setAvatar:(NSString *)imageUrl {
    if (imageUrl.length <= 0) {
        NSLog(@"imageUrl is empty.");
        return;
    }

    _account.avatar = imageUrl;
    [self save:_account];
}

- (NSString *)avatar {
    return _account.avatar;
}

- (void)prepareAccessTokenWithBlock:(ResponseDataBlock)callback {
    if ([self accessToken].length <= 0) { //No access token
        NSLog(@"No Access token exists, request a new Access Token.");
        [[AccountAPI sharedInstance] requestNewAccessTokenWithBlock:callback];
    } else { // Access token exists, need to check if it's still valid.
        NSLog(@"Current access token: %@", [[Customer sharedInstance] accessToken]);
        if ([self isLogged]) {
            [[AccountAPI sharedInstance] refreshAccountInfoWithBlock:callback];
        } else { //Not logged in, check access token
            NSLog(@"Customer not logged in, validate access token.");
            [[AccountAPI sharedInstance] requestAccessTokenWithBlock:callback];
        }
    }
}

@end
