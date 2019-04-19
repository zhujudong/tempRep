//
//  UIQuantityControl.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/12/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "UIQuantityControl.h"

@implementation UIQuantityControl

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;

        [self initializeControl];
    }

    return self;
}

- (void)initializeControl {
    //background border
    self.layer.borderColor = [UIColor colorWithHexString:@"686868" alpha:1].CGColor;
    self.layer.borderWidth = .5;
    self.layer.cornerRadius = 2.;
    self.clipsToBounds = YES;

    // Add minus button
    _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _minusBtn.frame = CGRectMake(0, 0, ceilf(self.frame.size.width / 3), self.frame.size.height);
    [_minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [_minusBtn setTitleColor:[UIColor colorWithHexString:@"686868" alpha:1] forState:UIControlStateNormal];
    [_minusBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateDisabled];
    _minusBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    _minusBtn.backgroundColor = [UIColor whiteColor];
    [_minusBtn addTarget:self action:@selector(didPressMinusBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_minusBtn];

    // Add plus button
    _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _plusBtn.frame = CGRectMake(ceilf(self.frame.size.width * 2 / 3), 0, ceilf(self.frame.size.width / 3), self.frame.size.height);
    [_plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [_plusBtn setTitleColor:[UIColor colorWithHexString:@"686868" alpha:1] forState:UIControlStateNormal];
    _plusBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    _plusBtn.backgroundColor = [UIColor whiteColor];
    [_plusBtn addTarget:self action:@selector(didPressPlusBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_plusBtn];

    // Add text field
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(ceilf(self.frame.size.width / 3) - 2.0f, 0, ceilf(self.frame.size.width / 3) + 4.0f, self.frame.size.height);
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.enabled = NO;
    _textField.font = [UIFont systemFontOfSize:12.];
    [self addSubview:_textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _minusBtn.frame = CGRectMake(0, 0, ceilf(self.frame.size.width / 3), self.frame.size.height);
    _plusBtn.frame = CGRectMake(ceilf(self.frame.size.width * 2 / 3), 0, ceilf(self.frame.size.width / 3), self.frame.size.height);
    _textField.frame = CGRectMake(ceilf(self.frame.size.width / 3) - 2.0f, 0, ceilf(self.frame.size.width / 3) + 4.0f, self.frame.size.height);
}

- (void)setQuantity:(NSInteger)quantity {
    _quantity = quantity;
    _textField.text = [NSString stringWithFormat:@"%ld", (long)_quantity];
}

- (void)didPressMinusBtn {
    if (_quantity > _minimum) {
        [self setQuantity:_quantity - 1];
        [self.delegate quantityChangedTo:_quantity tag:self.tag];
    }
}

- (void)didPressPlusBtn {
    if (_maximum != 0 && _quantity >= _maximum) {
        return;
    }

    [self setQuantity:_quantity + 1];
    [self.delegate quantityChangedTo:_quantity tag:self.tag];
}

@end
