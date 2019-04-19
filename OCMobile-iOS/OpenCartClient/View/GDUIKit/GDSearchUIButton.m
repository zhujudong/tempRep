//
//  GDSearchUIButton.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/16/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDSearchUIButton.h"

@implementation GDSearchUIButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.backgroundColor = [UIColor colorWithHexString:@"eeeeee" alpha:1.];
    self.layer.cornerRadius = 4.0;
    self.clipsToBounds = YES;

    [self setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];

    [self setTitle:NSLocalizedString(@"text_search_placeholder", nil) forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self setTitleColor:[UIColor colorWithHexString:@"606060" alpha:1.] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"606060" alpha:1.] forState:UIControlStateHighlighted];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);

    self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    return self;
}

@end
