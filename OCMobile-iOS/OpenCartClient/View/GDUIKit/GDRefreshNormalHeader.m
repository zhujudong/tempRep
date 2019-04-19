//
//  GDRefreshNormalHeader.m
//  OpenCartClient
//
//  Created by Sam Chen on 8/29/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDRefreshNormalHeader.h"

@implementation GDRefreshNormalHeader

- (void)prepare {
    [super prepare];

    // Set Font size
    self.stateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];

    // Use English text
    if ([[System sharedInstance] isSimplifiedChineseLanguage] == NO) {
        [self setTitle:@"Pull to refresh" forState:MJRefreshStateIdle];
        [self setTitle:@"Release ro refresh" forState:MJRefreshStatePulling];
        [self setTitle:@"Loading..." forState:MJRefreshStateRefreshing];

        // Hide Last update time label
        self.lastUpdatedTimeLabel.hidden = YES;
    }
}

@end
