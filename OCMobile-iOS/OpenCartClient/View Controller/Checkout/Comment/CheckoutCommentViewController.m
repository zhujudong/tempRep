//
//  CheckoutCommentViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 07/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "CheckoutCommentViewController.h"
#import "LoginViewController.h"
#import "GCPlaceholderTextView.h"

@interface CheckoutCommentViewController ()
@property (strong, nonatomic) GCPlaceholderTextView *textView;
@property (strong, nonatomic) UIButton *confirmButton;

@end

@implementation CheckoutCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_checkout_comment_title", nil);
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    _textView = [GCPlaceholderTextView new];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = CONFIG_DEFAULT_SEPARATOR_LINE_COLOR.CGColor;
    _textView.placeholder = NSLocalizedString(@"placeholder_comment_input", nil);
    _textView.text = _comment;

    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(160);
    }];

    _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    _confirmButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    [_confirmButton setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(20);
        make.leading.and.trailing.equalTo(_textView);
        make.height.mas_equalTo(40);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (void)confirmButtonClicked {
    [self.view endEditing:YES];

    if (!_textView.hasText) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_enter_comment", nil)];
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"type": @"comment",
                             @"value": _textView.text};
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] PUT:@"checkout" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage: NSLocalizedString(@"toast_comment_added", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

@end
