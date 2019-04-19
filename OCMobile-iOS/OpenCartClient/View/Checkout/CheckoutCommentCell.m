//
//  CheckoutCommentCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 07/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "CheckoutCommentCell.h"

@interface CheckoutCommentCell()
@property (strong, nonatomic) UILabel *titleLabel, *valueLabel;
@end

@implementation CheckoutCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont boldSystemFontOfSize:13];
            _titleLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            _titleLabel.text = NSLocalizedString(@"label_comment", nil);
            [_titleLabel sizeToFit];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(14);
                make.bottom.equalTo(self.contentView).offset(-14);
                make.leading.equalTo(self.contentView).offset(10);
                make.width.mas_equalTo(_titleLabel.bounds.size.width).priorityHigh();
            }];
        }
        
        if (!_valueLabel) {
            _valueLabel = [UILabel new];
            _valueLabel.font = [UIFont systemFontOfSize:12];
            _valueLabel.textAlignment = NSTextAlignmentRight;
            _valueLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_valueLabel];
            [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_titleLabel);
                make.leading.greaterThanOrEqualTo(_titleLabel.mas_trailing).offset(10);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setComment:(NSString *)comment {
    _comment = comment;

    _valueLabel.text = _comment.length ? _comment : NSLocalizedString(@"text_no_comment", nil);
}

@end
