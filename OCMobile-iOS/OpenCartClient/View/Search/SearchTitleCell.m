//
//  SearchTitleCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "SearchTitleCell.h"

@interface SearchTitleCell()
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation SearchTitleCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.text = NSLocalizedString(@"label_search_keyword_title", nil);
            _titleLabel.font = [UIFont systemFontOfSize:14];
            _titleLabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];

            [self addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self).mas_offset(10);
                make.centerY.equalTo(self);
            }];
        }
    }

    return self;
}

@end
