//
//  GDRefreshAutoNormalFooter.m
//  OpenCartClient
//
//  Created by Sam Chen on 8/29/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDRefreshAutoNormalFooter.h"

@implementation GDRefreshAutoNormalFooter

- (void)prepare {
    [super prepare];

    // Set Font size
    self.stateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];

    // Use English text
    if ([[System sharedInstance] isSimplifiedChineseLanguage] == NO) {
        [self setTitle:@"Drag up to load more" forState:MJRefreshStateIdle];
        [self setTitle:@"Release to load more" forState:MJRefreshStatePulling];
        [self setTitle:@"Loading more..." forState:MJRefreshStateRefreshing];
        [self setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
    }
}

@end
