//
//  AnalyticsManager.m
//  OpenCartClient
//
//  Created by Sam Chen on 01/09/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "AnalyticsManager.h"
#import "BaiduAnalytics.h"
#import "GoogleAnalytics.h"

@interface AnalyticsManager()
@property (strong, nonatomic) id analyticsDriver;
@end

@implementation AnalyticsManager

+ (AnalyticsManager *)sharedManager {
    static AnalyticsManager *_sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [[AnalyticsManager alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        if ([CONFIG_ANALYTICS_DRIVER isEqualToString:@"baidu"]) {
            _analyticsDriver = [(BaiduAnalytics *)[BaiduAnalytics alloc] init];
        } else if ([CONFIG_ANALYTICS_DRIVER isEqualToString:@"google"]) {
            _analyticsDriver = [(GoogleAnalytics *)[GoogleAnalytics alloc] init];
        }
    }

    return self;
}

- (void)trackEvent:(NSString *)event label:(NSString *)label {
    if (!_analyticsDriver) {
        return;
    }
    [_analyticsDriver trackEvent:event label:label];
}

- (void)trackVCStart:(NSString *)vc {
    if (!_analyticsDriver) {
        return;
    }
    [_analyticsDriver trackVCStart:vc];
}

- (void)trackVCEnd:(NSString *)vc {
    if (!_analyticsDriver) {
        return;
    }
    [_analyticsDriver trackVCEnd:vc];
}
@end
