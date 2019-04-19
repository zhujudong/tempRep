//
//  ShareSDKManager.m
//  OpenCartClient
//
//  Created by Sam Chen on 15/10/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "ShareSDKManager.h"
#import <ShareSDK/ShareSDK.h>
#import <MOBFoundation/MOBFoundation.h>

@implementation ShareSDKManager

+ (ShareSDKManager *)sharedInstance {
    static ShareSDKManager *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[ShareSDKManager alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (CONFIG_SHARESDK_APP_KEY.length) {
            [MobSDK registerAppKey:CONFIG_SHARESDK_APP_KEY appSecret:CONFIG_SHARESDK_APP_SECRET];
        }
    }

    return self;
}

@end
