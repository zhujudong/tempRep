//
//  BaiduAnalytics.m
//  OpenCartClient
//
//  Created by Sam Chen on 01/09/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "BaiduAnalytics.h"
#import "BaiduMobStat.h"

@implementation BaiduAnalytics

- (instancetype)init {
    self = [super init];

    if (self) {
#if DEBUG
        [[BaiduMobStat defaultStat] startWithAppId:CONFIG_BAIDU_TRACKING_APPID_DEBUG];
        //[[BaiduMobStat defaultStat] setEnableDebugOn:YES];
#else
        [[BaiduMobStat defaultStat] startWithAppId:CONFIG_BAIDU_TRACKING_APPID_LIVE];
#endif
    }

    return self;
}

- (void)trackEvent:(NSString *)event label:(NSString *)label {
    [[BaiduMobStat defaultStat] logEvent:event eventLabel:label];
}

- (void)trackVCStart:(NSString *)vc {
    [[BaiduMobStat defaultStat] pageviewStartWithName:vc];
}

- (void)trackVCEnd:(NSString *)vc {
    [[BaiduMobStat defaultStat] pageviewEndWithName:vc];
}
@end
