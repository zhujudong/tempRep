//
//  AccountWishlistCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountWishlistCell.h"
#import "GDStrikeThroughLabel.h"


static CGFloat const GUTTER=  10.0;

@interface AccountWishlistCell()
@property (strong, nonatomic) UIImageView *productImageView;
@property (strong, nonatomic) UILabel *nameLabel, *priceLabel;
@property (strong, nonatomic) GDStrikeThroughLabel *oldPriceLabel;
@end

@implementation AccountWishlistCell

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
                make.size.mas_equalTo(CGSizeMake(100, 100));
                make.top.and.leading.equalTo(self.contentView).offset(GUTTER);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.numberOfLines = 0;
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(GUTTER);
                make.leading.equalTo(_productImageView.mas_trailing).offset(GUTTER);
                make.trailing.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_priceLabel) {
            _priceLabel = [UILabel new];
            _priceLabel.font = [UIFont systemFontOfSize:13];
            _priceLabel.textColor = CONFIG_PRIMARY_COLOR;

            [self.contentView addSubview:_priceLabel];
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_oldPriceLabel) {
            _oldPriceLabel = [GDStrikeThroughLabel new];
            _oldPriceLabel.font = [UIFont systemFontOfSize:12];
            _oldPriceLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
            
            [self.contentView addSubview:_oldPriceLabel];
            [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-GUTTER);
                make.centerY.equalTo(_priceLabel);
            }];
        }
    }

    return self;
}

- (void)setProduct:(AccountWishlistProductItemModel *)product {
    _product = product;

    [_productImageView lazyLoad:_product.image];
    _nameLabel.text = _product.name;
    _priceLabel.text = _product.special != nil ? _product.special : _product.priceFormat;
    _oldPriceLabel.text = _product.special == nil ? nil : _product.priceFormat;
}

@end
