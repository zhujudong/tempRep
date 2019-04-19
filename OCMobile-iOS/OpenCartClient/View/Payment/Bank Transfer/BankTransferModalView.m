//
//  BankTransferModalView.m
//  YITAYO
//
//  Created by Sam Chen on 27/09/2017.
//  Copyright © 2017 itpanda.com.au. All rights reserved.
//

#import "BankTransferModalView.h"

static CGFloat const MODAL_HEIGHT = 280.0;
static CGFloat const MODAL_MARGIN = 20.0;
static CGFloat const MODAL_PADDING = 20.0;

@interface BankTransferModalView()
@property (strong, nonatomic) UIView *modalMaskView;
@property (strong, nonatomic) UIView *modalView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *theCopyButton;
@end

@implementation BankTransferModalView

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

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"title_bank_info", nil);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"555555" alpha:1];
        [_modalView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.leading.equalTo(_modalView).offset(MODAL_PADDING);
        }];

    }

    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor = CONFIG_PRIMARY_COLOR;
        _submitButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
        [_submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_modalView addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_modalView).offset(-MODAL_PADDING);
            make.leading.equalTo(_modalView).offset(MODAL_PADDING);
            make.trailing.equalTo(_modalView).offset(-MODAL_PADDING);
            make.height.mas_equalTo(44.0);
        }];
    }

    if (!_theCopyButton) {
        _theCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _theCopyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_theCopyButton setTitle:NSLocalizedString(@"button_copy_bank_info", nil) forState:UIControlStateNormal];
        [_theCopyButton setTitleColor:[UIColor colorWithHexString:@"0095ff" alpha:1] forState:UIControlStateNormal];
        [_theCopyButton addTarget:self action:@selector(theCopyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_modalView addSubview:_theCopyButton];
        [_theCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_modalView);
            make.bottom.equalTo(_submitButton.mas_top).offset(-10);
        }];
    }

    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.userInteractionEnabled = NO;
        _textView.font = [UIFont boldSystemFontOfSize:14];
        _textView.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
        _textView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1" alpha:1];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_bankTransferInfo];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle};
        [attributedString addAttributes:dict range:NSMakeRange(0, [_bankTransferInfo length])];
        _textView.attributedText = attributedString;

        [_modalView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(_theCopyButton.mas_top).offset(-10);
            make.leading.trailing.equalTo(_submitButton);
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
        //
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
        [_textView removeFromSuperview];
        [_submitButton removeFromSuperview];
        [self removeFromSuperview];

        _modalMaskView = nil;
        _modalView = nil;
        _textView = nil;
        _submitButton = nil;

        if (self.submitButtonClickedBlock) {
            self.submitButtonClickedBlock();
        }
    }];
}

- (void)submitButtonClicked {
    [self dismiss];
}

- (void)theCopyButtonClicked {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textView.text;
    [MBProgressHUD showToastToView:self withMessage:NSLocalizedString(@"toast_bank_info_copied", nil)];
}

@end
