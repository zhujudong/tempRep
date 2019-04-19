//
//  ProductNameCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/13/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductNameCell.h"
#import "GDStrikeThroughLabel.h"

static CGFloat const SPACE = 10.0;

@interface ProductNameCell()
@property (strong, nonatomic) UILabel *nameLabel, *priceLabel, *rewardLabel;
@property (strong, nonatomic) GDStrikeThroughLabel *oldPriceLabel;
@end

@implementation ProductNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        
        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.numberOfLines = 0;
            _nameLabel.font = [UIFont systemFontOfSize:14];
            _nameLabel.textColor = [UIColor blackColor];
            
            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(SPACE);
                make.trailing.equalTo(self.contentView).offset(-SPACE);
            }];
        }
        
        if (!_priceLabel) {
            _priceLabel = [UILabel new];
            _priceLabel.font = [UIFont boldSystemFontOfSize:16];
            _priceLabel.textColor = CONFIG_PRIMARY_COLOR;
            
            [self.contentView addSubview:_priceLabel];
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nameLabel.mas_bottom).offset(7);
                make.leading.equalTo(_nameLabel);
                make.bottom.equalTo(self.contentView).offset(-SPACE);
            }];
        }
        
        if (!_oldPriceLabel) {
            _oldPriceLabel = [GDStrikeThroughLabel new];
            _oldPriceLabel.font = [UIFont systemFontOfSize:14];
            _oldPriceLabel.textColor = [UIColor colorWithHexString:@"cccccc" alpha:1];
            
            [self.contentView addSubview:_oldPriceLabel];
            [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_priceLabel.mas_trailing).offset(SPACE);
                make.centerY.equalTo(_priceLabel);
            }];
        }
        
        if (!_rewardLabel) {
            _rewardLabel = [UILabel new];
            _rewardLabel.font = [UIFont systemFontOfSize:12];
            _rewardLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];
            
            [self.contentView addSubview:_rewardLabel];
            [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-SPACE);
                make.centerY.equalTo(_priceLabel);
            }];
        }
    }
    
    return self;
}

- (void)setProduct:(ProductDetailModel *)product {
    _product = product;
    
    _nameLabel.text = _product.name;
    _priceLabel.text = _product.special ? _product.specialFormat : _product.priceFormat;
    
    if (_product.special) {
        _oldPriceLabel.text = _product.priceFormat;
    } else {
        _oldPriceLabel.text = nil;
    }
    
    if (_product.points > 0) {
        _rewardLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_rewards", nil), _product.points];
    } else {
        _rewardLabel.text = nil;
    }
}
@end
