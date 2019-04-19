//
//  CategoryAllCollectionReusableViewHeader.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/31/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryAllCollectionReusableViewHeader.h"

@implementation CategoryAllCollectionReusableViewHeader

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        if (!_separatorView) {
            _separatorView = [UIView new];
            _separatorView.backgroundColor = [UIColor blackColor];
            
            [self addSubview:_separatorView];
            [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(4, 12));
                make.leading.equalTo(self);
                make.centerY.equalTo(self);
            }];
        }
        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont systemFontOfSize:14];
            _nameLabel.textColor = [UIColor blackColor];
            
            [self addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_separatorView.mas_trailing).offset(5);
                make.trailing.equalTo(self).offset(-5);
                make.centerY.equalTo(self);
            }];
        }
    }
    
    return self;
}

@end
