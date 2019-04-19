//
//  AccountOrderInfoProductCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderInfoProductCell.h"

@interface AccountOrderInfoProductCell()
@property (strong, nonatomic) UIImageView *productImageView;
@property (strong, nonatomic) UILabel *nameLabel, *optionLabel, *totalLabel;
@property (strong, nonatomic) UIButton *returnButton;
@end

@implementation AccountOrderInfoProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_productImageView) {
            _productImageView = [UIImageView new];
            [self.contentView addSubview:_productImageView];
            [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(90);
                make.top.and.leading.equalTo(self.contentView).offset(10);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.numberOfLines = 0;
            _nameLabel.font = [UIFont systemFontOfSize:12];
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.leading.equalTo(_productImageView.mas_trailing).offset(10);
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
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_totalLabel) {
            _totalLabel = [UILabel new];
            [self.contentView addSubview:_totalLabel];
            _totalLabel.font = [UIFont systemFontOfSize:14];
            _totalLabel.textColor = CONFIG_PRIMARY_COLOR;
            [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                make.top.equalTo(_optionLabel.mas_bottom).offset(5);
            }];
        }

        if (!_returnButton) {
            _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_returnButton setTitle:NSLocalizedString(@"button_cell_account_order_info_product_return", nil) forState:UIControlStateNormal];
            _returnButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [_returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _returnButton.backgroundColor = CONFIG_PRIMARY_COLOR;
            _returnButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
            [self.contentView addSubview:_returnButton];
            [_returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_totalLabel.mas_bottom).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
                make.trailing.equalTo(self.contentView).offset(-10);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(70);
            }];
        }
    }

    return self;
}

- (void)setProduct:(AccountOrderInfoProductItemModel *)product {
    _product = product;

    [_productImageView sd_setImageWithURL:[NSURL URLWithString:[_product.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                         placeholderImage:[UIImage imageNamed:@"placeholder"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if (image && cacheType == SDImageCacheTypeNone) {
                                        _productImageView.alpha = 0.1;
                                        [UIView animateWithDuration:CONFIG_IMAGE_FADE_IN_DURATION
                                                         animations:^{
                                                             _productImageView.alpha = 1.0;
                                                         }];
                                    }
                                }];

    _nameLabel.text = _product.name;
    _optionLabel.text = _product.option;
    _totalLabel.text = [NSString stringWithFormat:@"%@ x %ld", _product.price, (long)_product.quantity];



    [_returnButton addTarget:self action:@selector(returnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setReturnButtonHidden:(BOOL)hidden {
    [_returnButton setHidden:hidden];
}

- (void)returnButtonClicked {
    if (_returnButtonClickedBlock) {
        _returnButtonClickedBlock(_product);
    }
}
@end
