//
//  LoginInternationalMobileViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 30/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "LoginInternationalMobileViewController.h"
#import "NBPhoneNumberUtil.h"
#import "GDSimpleTextField.h"
#import "GDCountrySelectViewController.h"
#import "AccountModel.h"
#import "Customer.h"

static CGFloat const TEXT_FIELD_HEIGHT = 46.0;
static CGFloat const REGION_BUTTON_WIDTH = 100.0;

@interface LoginInternationalMobileViewController ()
@property (strong, nonatomic) NSString *regionCode;
@property (strong, nonatomic) GDSimpleTextField *telephoneTextField, *passwordTextField;
@property (strong, nonatomic) UIButton *regionButton, *loginButton;
@end

@implementation LoginInternationalMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    self.title = NSLocalizedString(@"text_telephone_login", nil);

    CallingCodeModel *firstCallingCode = [_callingCodes firstObject];
    _regionCode = firstCallingCode.code;

    _regionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _regionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_regionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _regionButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _regionButton.backgroundColor = [UIColor whiteColor];
    _regionButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    _regionButton.layer.borderColor = [UIColor colorWithHexString:@"C8C6CC" alpha:1].CGColor;
    _regionButton.layer.borderWidth = 0.5;
    [_regionButton setTitle:[NSString stringWithFormat:@"%@ +%@", firstCallingCode.name, firstCallingCode.code] forState:UIControlStateNormal];

    [_regionButton addTarget:self action:@selector(regionButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_regionButton];
    [_regionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(REGION_BUTTON_WIDTH, TEXT_FIELD_HEIGHT));
    }];

    _telephoneTextField = [[GDSimpleTextField alloc] init];
    _telephoneTextField.placeholder = NSLocalizedString(@"label_account_login_telephone", nil);
    _telephoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_telephoneTextField];
    [_telephoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_regionButton);
        make.leading.equalTo(_regionButton.mas_trailing).offset(10);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.equalTo(_regionButton);
    }];

    _passwordTextField = [[GDSimpleTextField alloc] init];
    _passwordTextField.placeholder = NSLocalizedString(@"label_account_login_password", nil);
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_regionButton.mas_bottom).offset(20);
        make.leading.equalTo(_regionButton);
        make.trailing.equalTo(_telephoneTextField);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
    }];

    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginButton setTitle:NSLocalizedString(@"button_account_login", nil) forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:CONFIG_PRIMARY_COLOR];
    _loginButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    _loginButton.clipsToBounds = YES;
    [_loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).mas_offset(20);
        make.leading.equalTo(_regionButton);
        make.trailing.equalTo(_telephoneTextField);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_telephoneTextField becomeFirstResponder];
}

#pragma mark - Actions
- (void)regionButtonClicked {
    __weak typeof(self) weakSelf = self;
    GDCountrySelectViewController *countrySelectVC = [[GDCountrySelectViewController alloc] init];
    countrySelectVC.callingCodes = _callingCodes;

    countrySelectVC.countrySelectedBlock = ^(NSString *regionCode) {
        weakSelf.regionCode = regionCode;
        for (CallingCodeModel *callingCode in weakSelf.callingCodes) {
            if ([callingCode.code isEqualToString:regionCode]) {
                [weakSelf.regionButton setTitle:[NSString stringWithFormat:@"%@ +%@",callingCode.name, callingCode.code] forState:UIControlStateNormal];
                break;
            }
        }
    };

    [self presentViewController:countrySelectVC animated:YES completion:nil];
}

- (void)loginButtonClicked {
    [self.view endEditing:YES];

    //===== telephone =====
    if (_telephoneTextField.hasText == NO) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"label_account_login_telephone", nil)];
        return;
    }

    //===== password =====
    if (_passwordTextField.hasText == NO) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_login_input_password", nil)];
        return;
    }

    // Call API
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"account": _telephoneTextField.text,
                             @"region_code": _regionCode,
                             @"password": _passwordTextField.text,
                             };

    [[Network sharedInstance] POST:@"account/login" params:params callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        if (data) {
            AccountModel *account = [[AccountModel alloc] initWithDictionary:data error:nil];

            if (account) {
                [[Customer sharedInstance] save:account];
                [weakSelf closeButtonClicked];
            } else {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_account_login_error_format", nil)];
            }
        }

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)closeButtonClicked {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
