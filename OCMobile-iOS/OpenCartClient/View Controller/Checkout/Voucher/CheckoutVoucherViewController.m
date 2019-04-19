//
//  CheckoutVoucherViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutVoucherViewController.h"
#import "LoginViewController.h"
#import "GDSimpleTextField.h"

@interface CheckoutVoucherViewController ()
@property (strong, nonatomic) GDSimpleTextField *textField;
@property (strong, nonatomic) UIButton *confirmButton;

@end

@implementation CheckoutVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_checkout_voucher_title", nil);
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    
    _textField = [GDSimpleTextField new];
    _textField.placeholder = NSLocalizedString(@"toast_enter_voucher", nil);
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    if (_currentVoucherCode.length) {
        _textField.text = _currentVoucherCode;
    }
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    _confirmButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    [_confirmButton setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom).offset(20);
        make.leading.and.trailing.equalTo(_textField);
        make.height.mas_equalTo(44);
    }];
}

- (void)confirmButtonClicked {
    [self.view endEditing:YES];
    
    if (!_textField.hasText) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_enter_voucher", nil)];
        return;
    }
    [MBProgressHUD showLoadingHUDToView:self.view];
    
    NSDictionary *params = @{@"type": @"voucher",
                             @"value": _textField.text};
    __weak typeof(self) weakSelf = self;
    
    [[Network sharedInstance] PUT:@"checkout" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage: NSLocalizedString(@"toast_voucher_added", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}
@end
