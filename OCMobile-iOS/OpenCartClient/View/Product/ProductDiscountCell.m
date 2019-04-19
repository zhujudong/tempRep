//
//  ProductDiscountCell.m
//  iWant Mall
//
//  Created by Sam Chen on 20/03/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "ProductDiscountCell.h"

static CGFloat const GUTTER = 14.0;

@interface ProductDiscountCell()
@property (strong, nonatomic) UILabel *keyLabel, *valueLabel;
@property (strong, nonatomic) UIView *sepLine;
@end

@implementation ProductDiscountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7" alpha:1.];

        if (!_keyLabel) {
            _keyLabel = [UILabel new];
            _keyLabel.numberOfLines = 1;
            _keyLabel.font = [UIFont systemFontOfSize:13];
            _keyLabel.text = NSLocalizedString(@"label_discount", nil);
            _keyLabel.textColor = CONFIG_PRIMARY_COLOR;

            [self.contentView addSubview:_keyLabel];
            [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
//                make.top.equalTo(self.contentView).offset(GUTTER);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_sepLine) {
            _sepLine = [[UIView alloc] init];
            _sepLine.backgroundColor = CONFIG_DEFAULT_SEPARATOR_LINE_COLOR;
            [self.contentView addSubview:_sepLine];
            [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_keyLabel.mas_trailing). offset(10);
                make.centerY.equalTo(self.contentView);
                make.height.equalTo(_keyLabel.mas_height);
                make.width.mas_equalTo(0.5);
            }];
        }

        if (!_valueLabel) {
            _valueLabel = [UILabel new];
            _valueLabel.numberOfLines = 0;
            _valueLabel.font = [UIFont systemFontOfSize:11];
            _valueLabel.adjustsFontSizeToFitWidth = YES;
            _valueLabel.minimumScaleFactor = 0.5;
            _valueLabel.textColor = [UIColor colorWithHexString:@"848687" alpha:1];
            _valueLabel.textAlignment = NSTextAlignmentLeft;

            [self.contentView addSubview:_valueLabel];
            [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_sepLine.mas_trailing).offset(10);
                make.trailing.lessThanOrEqualTo(self.contentView).offset(-6);
                make.top.equalTo(self.contentView).offset(GUTTER);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }
    }

    return self;
}

- (void)setProduct:(ProductDetailModel *)product {
    _product = product;
//    _valueLabel.text = [_product convertDiscountsDataToMultiLineString];
}

@end
