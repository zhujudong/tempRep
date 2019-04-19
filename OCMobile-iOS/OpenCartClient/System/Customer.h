//
//  Customer.h
//  OpenCartClient
//
//  Created by Sam Chen on 10/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"

@interface Customer : NSObject

+ (Customer *)sharedInstance;

- (AccountModel *)account;
- (void)save:(AccountModel *)account;
- (void)prepareAccessTokenWithBlock:(ResponseDataBlock)callback;
- (BOOL)isLogged;
- (void)logout;
- (NSString *)accessToken;
- (void)setAccessToken:(NSString *)accessToken;
- (NSInteger)cartNumber;
- (void)resetCartNumber;
- (NSInteger)addCartNumberBy:(NSInteger)number;
- (NSInteger)setCartNumber:(NSInteger)number;
- (void)setAvatar:(NSString *)imageUrl;
- (NSString *)avatar;

@end
