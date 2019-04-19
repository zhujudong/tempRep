//
//  ProductSectionTitleCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/27/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductSectionTitleCell.h"

static CGFloat const TOP_BOTTOM_MARGIN = 14.0;

@interface ProductSectionTitleCell()
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation ProductSectionTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
            _titleLabel.font = [UIFont systemFontOfSize:14];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(TOP_BOTTOM_MARGIN);
                make.leading.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-TOP_BOTTOM_MARGIN);
            }];
        }
    }

    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    [super setAccessoryType:accessoryType];
}

@end
