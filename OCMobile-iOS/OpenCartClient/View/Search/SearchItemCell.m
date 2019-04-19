//
//  SearchItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "SearchItemCell.h"

@interface SearchItemCell()
@property (strong, nonatomic) UILabel *keywordLabel;
@end

@implementation SearchItemCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (!_keywordLabel) {
            _keywordLabel = [UILabel new];
            _keywordLabel.font = [UIFont systemFontOfSize:12];
            _keywordLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            _keywordLabel.backgroundColor = [UIColor colorWithHexString:@"F2F2F2" alpha:1];
            _keywordLabel.textAlignment = NSTextAlignmentCenter;

            [self.contentView addSubview:_keywordLabel];

            [_keywordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }

    return self;
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;

    _keywordLabel.text = _keyword;
}

@end
