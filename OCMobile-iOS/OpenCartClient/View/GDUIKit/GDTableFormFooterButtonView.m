//
//  GDTableFormFooterButtonView.m
//  OpenCartClient
//
//  Created by Sam Chen on 21/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDTableFormFooterButtonView.h"

@implementation GDTableFormFooterButtonView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        _button.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
        [_button clipsToBounds];
        _button.backgroundColor = CONFIG_PRIMARY_COLOR;
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
        }];
    }

    return self;
}

@end
