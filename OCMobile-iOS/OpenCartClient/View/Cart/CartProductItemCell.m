//
//  CartProductItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 17/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CartProductItemCell.h"
#import "GDUILabel.h"

@interface CartProductItemCell()
@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) UIImageView *productImageView;
@property (strong, nonatomic) UILabel *nameLabel, *optionLabel, *priceLabel, *totalLabel, *minimumLabel;
@property (strong, nonatomic) GDUILabel *errorLabel;
@property (strong, nonatomic) UIQuantityControl *quantityControl;

@property (strong, nonatomic) MASConstraint *priceLabelToOptionLabelBottomConstraint;
@property (strong, nonatomic) MASConstraint *errorLabelToTotalLabelBottomConstraint;
@end

@implementation CartProductItemCell
+ (NSString *)identifier {
    return @"CartProductItemCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_selectButton) {
            _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_selectButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [_selectButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
            [_selectButton addTarget:self action:@selector(toggleProductSeletionState) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_selectButton];
            [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(5);
                make.top.and.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(30);
            }];
        }

        if (!_productImageView) {
            _productImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];

            [self.contentView addSubview:_productImageView];
            [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_selectButton.mas_trailing).offset(5);
                make.size.mas_equalTo(CGSizeMake(90, 90));
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] init];
            _nameLabel.numberOfLines = 0;
            _nameLabel.font = [UIFont systemFontOfSize:12];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_productImageView.mas_trailing).offset(10);
                make.top.equalTo(self.contentView).offset(10);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_optionLabel) {
            _optionLabel = [[UILabel alloc] init];
            _optionLabel.numberOfLines = 0;
            _optionLabel.textColor = [UIColor colorWithHexString:@"C8C7CC" alpha:1];
            _optionLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_optionLabel];
            [_optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.trailing.equalTo(_nameLabel);
                make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            }];
        }

        if (!_priceLabel) {
            _priceLabel = [[UILabel alloc] init];
            _priceLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            _priceLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_priceLabel];
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                _priceLabelToOptionLabelBottomConstraint = make.top.equalTo(_optionLabel.mas_bottom).offset(4);
                make.top.greaterThanOrEqualTo(_nameLabel.mas_bottom).offset(4);
            }];
        }

        if (!_quantityControl) {
            _quantityControl = [UIQuantityControl new];
            _quantityControl.delegate = self;

            [self.contentView addSubview:_quantityControl];
            [_quantityControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(90, 30));
                make.top.equalTo(_priceLabel.mas_bottom).offset(5);
                make.leading.equalTo(_nameLabel);
            }];
        }

        if (!_minimumLabel) {
            _minimumLabel = [UILabel new];
            _minimumLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];
            _minimumLabel.textColor = [UIColor colorWithHexString:@"C8C7CC" alpha:1];

            [self.contentView addSubview:_minimumLabel];
            [_minimumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_quantityControl);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_totalLabel) {
            _totalLabel = [UILabel new];
            _totalLabel.font = [UIFont systemFontOfSize:14];
            _totalLabel.textColor = CONFIG_PRIMARY_COLOR;
            [self.contentView addSubview:_totalLabel];
        }

        if (!_errorLabel) {
            _errorLabel = [[GDUILabel alloc] init];
            _errorLabel.numberOfLines = 1;
            _errorLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            _errorLabel.backgroundColor = [UIColor colorWithHexString:@"f1f1f1" alpha:1];
            _errorLabel.font = [UIFont systemFontOfSize:11];
            _errorLabel.paddingTop = 4;
            _errorLabel.paddingBottom = 4;
            _errorLabel.paddingLeft = 6;
            _errorLabel.paddingRight = 6;
            [self.contentView addSubview:_errorLabel];
        }

        [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_nameLabel);
            make.top.equalTo(_quantityControl.mas_bottom).offset(5);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
        }];

        [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            _errorLabelToTotalLabelBottomConstraint = make.top.equalTo(_totalLabel.mas_bottom).offset(5);
            make.leading.equalTo(self.contentView).offset(10);
            make.trailing.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }

    return self;
}

- (void)toggleProductSeletionState {
    [_selectButton setSelected:!_selectButton.isSelected];

    if (_productSelectChangedBlock) {
        _productSelectChangedBlock(_selectButton.isSelected);
    }
}

- (void)quantityChangedTo:(NSInteger)number tag:(NSUInteger)tag {
    if (_quantityChangedBlock) {
        _quantityChangedBlock(number);
    }
}

- (void)setProduct:(CartProductItemModel *)product {
    _product = product;

    // Hide option label if the product has no option
    NSString *option = [_product.optionLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (option.length) {
        [_optionLabel setHidden:NO];
        _optionLabel.text = option;
        [_priceLabelToOptionLabelBottomConstraint activate];
    } else {
        [_optionLabel setHidden:YES];
        _optionLabel.text = nil;
        [_priceLabelToOptionLabelBottomConstraint deactivate];
    }

    [_productImageView lazyLoad:_product.image];
    _nameLabel.text = _product.name;
    _optionLabel.text = _product.optionLabel;
    _priceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_unit_price_with_number", nil), _product.priceFormat];
    _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_subtotal_with_number", nil), _product.subtotalFormat];

    _quantityControl.quantity = _product.quantity;
    _quantityControl.minimum = _product.minimum;

    if (_product.error.length > 0) {
        [_errorLabel setHidden:NO];
        _errorLabel.text = _product.error;
        [_errorLabelToTotalLabelBottomConstraint activate];
    } else {
        [_errorLabel setHidden:YES];
        _errorLabel.text = nil;
        [_errorLabelToTotalLabelBottomConstraint deactivate];
    }

    if (SCREEN_WIDTH > 350) { //Don't show mim qty label on < iPhone 5
        if (_product.minimum > 1) {
            _minimumLabel.hidden = NO;
            _minimumLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_minimum_qty", nil), _product.minimum];
        } else {
            _minimumLabel.hidden = YES;
        }
    } else {
        _minimumLabel.hidden = YES;
    }

    [_selectButton setSelected:_product.selected > 0];
}

- (void)setProductSelected: (BOOL) selected {
    [_selectButton setSelected:selected];
}

@end
