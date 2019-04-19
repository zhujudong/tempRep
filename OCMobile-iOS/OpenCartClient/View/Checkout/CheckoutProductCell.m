//
//  CheckoutProductCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutProductCell.h"

static CGFloat const IMAGE_WIDTH = 90.0;

@interface CheckoutProductCell()

@property (strong, nonatomic) UIImageView *productImageView;
@property (strong, nonatomic) UILabel *nameLabel, *optionLabel, *totalLabel;

@end

@implementation CheckoutProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_productImageView) {
            _productImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
            [self.contentView addSubview:_productImageView];
            [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH)).priorityHigh();
                make.top.and.leading.equalTo(self.contentView).offset(10).priorityHigh();
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.numberOfLines = 0;
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            _nameLabel.font = [UIFont systemFontOfSize:12];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(IMAGE_WIDTH + 20);
                make.top.equalTo(self.contentView).offset(10);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_optionLabel) {
            _optionLabel = [UILabel new];
            _optionLabel.numberOfLines = 0;
            _optionLabel.font = [UIFont systemFontOfSize:12];
            _optionLabel.textColor = [UIColor colorWithHexString:@"C8C7CC" alpha:1];

            [self.contentView addSubview:_optionLabel];
            [_optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                make.top.equalTo(_nameLabel.mas_bottom).offset(5);
                make.trailing.equalTo(_nameLabel);
            }];
        }

        if (!_totalLabel) {
            _totalLabel = [UILabel new];
            _totalLabel.font = [UIFont systemFontOfSize:14];
            _totalLabel.textColor = [UIColor colorWithHexString:@"222222" alpha:1.0];

            [self.contentView addSubview:_totalLabel];
            [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                make.top.equalTo(_optionLabel.mas_bottom).offset(10);
            }];
        }
    }

    return self;
}


- (void)setProduct:(CheckoutProductItemModel *)product {
    _product = product;

    // Hide option label if the product has no option, remake layout constraints
    if (!_product.optionLabel.length) {
        [_optionLabel setHidden:YES];

        [_totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        }];
    } else {
        [_optionLabel setHidden:NO];

        [_totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_nameLabel);
            make.top.equalTo(_optionLabel.mas_bottom).offset(10);
        }];
    }

    [_productImageView lazyLoad:product.image];
    _nameLabel.text = product.name;
    _optionLabel.text = product.optionLabel;
    _totalLabel.text = [NSString stringWithFormat:@"%@ x %ld  = %@", product.priceFormat, (long)product.quantity, product.subtotalFormat];
}
@end
