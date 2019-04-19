//
//  GoogleAnalytics.m
//  OpenCartClient
//
//  Created by Sam Chen on 01/09/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "GoogleAnalytics.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>

@implementation GoogleAnalytics

- (instancetype)init {
    self = [super init];

    if (self) {
        GAI *gai = [GAI sharedInstance];
        [gai trackerWithTrackingId:CONFIG_GOOGLE_TRACKING_APPID];
        gai.trackUncaughtExceptions = YES;
        gai.logger.logLevel = kGAILogLevelVerbose;
    }
    
    return self;
}

- (void)trackEvent:(NSString *)event label:(NSString *)label {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"api"
                                                          action:event
                                                           label:label
                                                           value:nil] build]];
}

- (void)trackVCStart:(NSString *)vc {
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:vc];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)trackVCEnd:(NSString *)vc {
    // TODO
}
@end
