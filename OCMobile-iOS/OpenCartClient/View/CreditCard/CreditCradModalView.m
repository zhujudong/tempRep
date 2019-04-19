//
//  CreditCradModalView.m
//  afterschoollol
//
//  Created by Sam Chen on 10/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "CreditCradModalView.h"
#import <Stripe/Stripe.h>

static CGFloat const MODAL_HEIGHT = 240.0;
static CGFloat const MODAL_MARGIN = 20.0;
static CGFloat const MODAL_PADDING = 20.0;

@interface CreditCradModalView()<STPPaymentCardTextFieldDelegate>
@property (strong, nonatomic) UIView *modalMaskView;
@property (strong, nonatomic) UIView *modalView;
@property (strong, nonatomic) UILabel *modalTitleLabel;
@property (strong, nonatomic) STPPaymentCardTextField *paymentCardTextField;
@property (strong, nonatomic) UILabel *saveCardLabel;
@property (strong, nonatomic) UISwitch *saveCardSwitch;
@property (strong, nonatomic) UIButton *submitButton, *cancelButton;
@end

@implementation CreditCradModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    return self;
}

- (void)createView {
    if (!_modalMaskView) {
        _modalMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _modalMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _modalMaskView.alpha = 0.0;
        [self addSubview:_modalMaskView];
    }

    if (!_modalView) {
        CGRect frame = CGRectMake(MODAL_MARGIN, SCREEN_HEIGHT, SCREEN_WIDTH - (MODAL_MARGIN * 2), MODAL_HEIGHT);
        _modalView = [[UIView alloc] initWithFrame:frame];
        _modalView.backgroundColor = [UIColor whiteColor];
        _modalView.layer.cornerRadius = 8.0f;
        _modalView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _modalView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] CGColor];
        _modalView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        [self addSubview:_modalView];
    }

    if (!_modalTitleLabel) {
        _modalTitleLabel = [[UILabel alloc] init];
        _modalTitleLabel.text = NSLocalizedString(@"label_new_credit_card", nil);
        _modalTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_modalView addSubview:_modalTitleLabel];
        [_modalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_modalView).offset(MODAL_PADDING);
            make.centerX.equalTo(_modalView);
        }];
    }

    if (!_paymentCardTextField) {
        _paymentCardTextField = [[STPPaymentCardTextField alloc] init];
        self.paymentCardTextField.delegate = self;
        [_modalView addSubview:_paymentCardTextField];
        [_paymentCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_modalTitleLabel.mas_bottom).offset(MODAL_PADDING);
            make.leading.equalTo(_modalView).offset(MODAL_PADDING);
            make.trailing.equalTo(_modalView).offset(-MODAL_PADDING);
        }];
    }

    if (_saveCardEnabled && !_saveCardLabel) {
        _saveCardLabel = [[UILabel alloc] init];
        _saveCardLabel.text = NSLocalizedString(@"label_save_credit_card", nil);
        _saveCardLabel.font = [UIFont systemFontOfSize:13];
        [_modalView addSubview:_saveCardLabel];
        [_saveCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_paymentCardTextField);
            make.top.equalTo(_paymentCardTextField.mas_bottom).offset(20);
        }];
    }

    if (_saveCardEnabled && !_saveCardSwitch) {
        _saveCardSwitch = [[UISwitch alloc] init];
        [_saveCardSwitch setOn:YES];
        [_modalView addSubview:_saveCardSwitch];
        [_saveCardSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_saveCardLabel.mas_trailing).offset(10);
            make.centerY.equalTo(_saveCardLabel);
        }];
    }

    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:NSLocalizedString(@"button_cancel", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [self styleButton:_cancelButton];
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.borderColor = [[UIColor colorWithHexString:@"999999" alpha:1] CGColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_modalView addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_modalView).offset(MODAL_MARGIN);
            make.bottom.equalTo(_modalView).offset(-MODAL_MARGIN);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
    }

    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = CONFIG_PRIMARY_COLOR;
        [self styleButton:_submitButton];
        [_submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_modalView addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(_modalView).offset(-MODAL_MARGIN);
            make.centerY.equalTo(_cancelButton);
            make.size.equalTo(_cancelButton);
        }];
    }
}

- (void)show {
    [self createView];

    [UIView animateWithDuration:0.3 animations:^{
        _modalMaskView.alpha = 1.0;

        CGFloat y = (SCREEN_HEIGHT - MODAL_HEIGHT) / 2 - 50;
        CGRect frame = _modalView.frame;
        frame.origin.y = y;
        _modalView.frame = frame;
    } completion:^(BOOL finished) {
        [_paymentCardTextField becomeFirstResponder];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _modalMaskView.alpha = 0.0;

        CGFloat y = SCREEN_HEIGHT;
        CGRect frame = _modalView.frame;
        frame.origin.y = y;
        _modalView.frame = frame;

    } completion:^(BOOL finished) {
        [_modalMaskView removeFromSuperview];
        [_modalView removeFromSuperview];
        [self removeFromSuperview];

        _modalMaskView = nil;
        _modalView = nil;
        _paymentCardTextField = nil;

        if (_cancelButtonClickedBlock) {
            self.cancelButtonClickedBlock();
        }
    }];
}

- (void)styleButton:(UIButton *)button {
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.cornerRadius = 3;
}

- (void)cancelButtonClicked {
    if (_dismissable) {
        [self endEditing:YES];
        [self dismiss];
    } else {
        if (_cancelButtonClickedBlock) {
            self.cancelButtonClickedBlock();
        }
    }
}

- (void)submitButtonClicked {
    if (!_paymentCardTextField.isValid) {
        return;
    }
    
    [self endEditing:YES];

    if (self.submitButtonClickedBlock) {
        StripeNewCardModel *card = [[StripeNewCardModel alloc] init];
        card.cardNumber = _paymentCardTextField.cardNumber;
        card.expirationMonth = _paymentCardTextField.formattedExpirationMonth;
        card.expirationYear = _paymentCardTextField.formattedExpirationYear;
        card.cvc = _paymentCardTextField.cvc;
        card.saveCard = _saveCardSwitch.isOn;
        self.submitButtonClickedBlock(card);
    }
}

#pragma mark - STPPaymentCardTextFieldDelegate
- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    _submitButton.enabled = textField.isValid;
}
@end
