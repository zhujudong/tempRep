//
//  OptionGroupNameCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/9/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "OptionGroupNameCell.h"

@implementation OptionGroupNameCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        if (!_optionNameLabel) {
            _optionNameLabel = [UILabel new];
            _optionNameLabel.textColor = [UIColor blackColor];
            _optionNameLabel.font = [UIFont systemFontOfSize:14];

            [self addSubview:_optionNameLabel];
            [_optionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }

    return self;
}

@end
