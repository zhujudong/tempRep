//
//  BaiduAnalytics.h
//  OpenCartClient
//
//  Created by Sam Chen on 01/09/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiduAnalytics : NSObject

- (void)trackEvent:(NSString *)event label:(NSString *)label;
- (void)trackVCStart:(NSString *)vc;
- (void)trackVCEnd:(NSString *)vc;
@end
