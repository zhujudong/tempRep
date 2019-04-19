//
//  CartTotalItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/29/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CartTotalItemCell.h"

static CGFloat const GUTTER = 10.0;

@implementation CartTotalItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        
        if (!_keyLabel) {
            _keyLabel = [UILabel new];
            _keyLabel.font = [UIFont systemFontOfSize:14];
            _keyLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            
            [self.contentView addSubview:_keyLabel];
            [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(GUTTER);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }
        
        if (!_valueLabel) {
            _valueLabel = [UILabel new];
            _valueLabel.font = [UIFont systemFontOfSize:14];
            
            [self.contentView addSubview:_valueLabel];
            [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.trailing.equalTo(self.contentView).offset(-GUTTER);
            }];
        }
    }
    
    return self;
}

@end
