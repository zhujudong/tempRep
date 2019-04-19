//
//  AccountResetPasswordByEmailViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountResetPasswordByEmailViewController.h"
#import "AccountResetPasswordViewController.h"
#import "GDSimpleTextField.h"

static CGFloat const TEXT_FIELD_HEIGHT = 44.0;

@interface AccountResetPasswordByEmailViewController ()
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) GDSimpleTextField *emailTextField;
@property (strong, nonatomic) UIButton *continueButton, *resetPasswordByMobileButton;
@end

@implementation AccountResetPasswordByEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_reset_password_title", nil);
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = NSLocalizedString(@"help_account_reset_password_email", nil);
    _tipLabel.numberOfLines = 0;
    _tipLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];

    _emailTextField = [[GDSimpleTextField alloc] init];
    _emailTextField.placeholder = NSLocalizedString(@"label_account_reset_password_email", nil);
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_emailTextField];
    [_emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipLabel.mas_bottom).offset(20);
        make.leading.equalTo(_tipLabel.mas_leading);
        make.trailing.equalTo(_tipLabel.mas_trailing);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
    }];

    _continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_continueButton setTitle:NSLocalizedString(@"button_continue", nil) forState:UIControlStateNormal];
    [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_continueButton setBackgroundColor:CONFIG_PRIMARY_COLOR];
    _continueButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    _continueButton.clipsToBounds = YES;
    [_continueButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_continueButton];
    [_continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailTextField.mas_bottom).mas_offset(20);
        make.leading.equalTo(_tipLabel.mas_leading);
        make.trailing.equalTo(_tipLabel.mas_trailing);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
    }];

    _resetPasswordByMobileButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_resetPasswordByMobileButton setTitle:NSLocalizedString(@"button_account_reset_password_mobile", nil) forState:UIControlStateNormal];
    [_resetPasswordByMobileButton setTitleColor:[UIColor colorWithHexString:@"808080" alpha:1.] forState:UIControlStateNormal];
    _resetPasswordByMobileButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_resetPasswordByMobileButton addTarget:self action:@selector(goToResetPasswordByMobileVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetPasswordByMobileButton];
    [_resetPasswordByMobileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_continueButton.mas_bottom).mas_offset(20);
        make.leading.equalTo(_tipLabel.mas_leading);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_emailTextField becomeFirstResponder];
}

- (void)submit {
    [self.view endEditing:YES];

    if (!_emailTextField.hasText) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_email", nil)];
        return;
    }

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    if ([emailTest evaluateWithObject:_emailTextField.text] == NO) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_email_invalid", nil)];
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"type":@"email",
                             @"account":_emailTextField.text,
                             };
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:@"account/reset_password" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_new_password_sent_email", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)goToResetPasswordByMobileVC {
    [self.view endEditing:YES];

    AccountResetPasswordViewController *nextVC = [AccountResetPasswordViewController new];
    [self.navigationController pushViewController:nextVC animated:YES];

    //Remove self from stack
    NSMutableArray *vcStack = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [vcStack removeObjectAtIndex:vcStack.count - 2];
    self.navigationController.viewControllers = vcStack;
}
@end
