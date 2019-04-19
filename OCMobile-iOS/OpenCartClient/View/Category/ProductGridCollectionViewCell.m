//
//  ProductGridCollectionViewCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductGridCollectionViewCell.h"
#import "UIImage+SoldOutImage.h"

static CGFloat const GUTTER = 6.0;

@interface ProductGridCollectionViewCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel, *priceLabel;
@property (strong, nonatomic) GDStrikeThroughLabel *priceOldLabel;
@end

@implementation ProductGridCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        if (!_imageView) {
            _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];

            [self.contentView addSubview:_imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.equalTo(self.contentView);
                make.height.equalTo(_imageView.mas_width);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.textColor = [UIColor colorWithHexString:@"222222" alpha:1];
            _nameLabel.font = [UIFont boldSystemFontOfSize:12];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView.mas_bottom).offset(GUTTER);
                make.leading.equalTo(self.contentView).offset(GUTTER);
                make.trailing.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_priceLabel) {
            _priceLabel = [UILabel new];
            _priceLabel.font = [UIFont boldSystemFontOfSize:13];
            _priceLabel.textColor = CONFIG_PRIMARY_COLOR;

            [self.contentView addSubview:_priceLabel];
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nameLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(self.contentView).offset(GUTTER);
            }];
        }

        if (!_priceOldLabel) {
            _priceOldLabel = [GDStrikeThroughLabel new];
            _priceOldLabel.font = [UIFont systemFontOfSize:12];
            _priceOldLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_priceOldLabel];
            [_priceOldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_priceLabel.mas_trailing).offset(10);
                make.centerY.equalTo(_priceLabel);
            }];
        }
    }

    return self;
}

- (void)setProduct:(ProductGridItemModel *)product {
    _product = product;

    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_product.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                  placeholderImage:[UIImage imageNamed:@"placeholder"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             if (!image) {
                                 return;
                             }

                             // Add a sold out label on top of image
                             if (CONFIG_OUT_OF_STOCK_STAMP) {
                                 if (_product.quantity <= 0) {
                                     _imageView.image = [image drawImageWithSoldOutOverlay:image];
                                 }
                             }

                             if (cacheType == SDImageCacheTypeNone) {
                                 _imageView.alpha = 0.1;
                                 [UIView animateWithDuration:CONFIG_IMAGE_FADE_IN_DURATION animations:^{
                                     _imageView.alpha = 1.0;
                                 }];
                             }
                         }];

    _nameLabel.text = _product.name;

    if (_product.special) {
        _priceLabel.text = _product.specialFormat;
        _priceOldLabel.text = _product.priceFormat;
    } else {
        _priceLabel.text = _product.priceFormat;
        _priceOldLabel.text = nil;
    }
}

@end
