//
//  LoginViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RegisterEmailViewController.h"
#import "GDUILabel.h"
#import "Customer.h"
#import "UITabBarController+CartNumber.h"
#import "AccountResetPasswordViewController.h"
#import "AccountConnectViewController.h"
#import "AccountSocialModel.h"
#import "AppDelegate.h"
#import "AccountAPI.h"
#import "RDVTabBarController+CartNumber.h"
#import "LoginInternationalMobileViewController.h"
#import <ShareSDK/ShareSDK+Base.h>
#import "WXApi.h"
#import "CallingCodeModel.h"

static CGFloat const TEXT_FIELD_HEIGHT = 46.0;
static CGFloat const INPUT_TITLE_WIDTH_CN = 60.0;
static CGFloat const INPUT_TITLE_WIDTH_EN = 90.0;

@interface LoginViewController () {
}

@property (strong, nonatomic) UITextField *usernameTextField, *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton, *registerButton, *resetPasswordButton;
@property (strong, nonatomic) UIButton *wechatLoginButton, *qqLoginButton, *weiboLoginButton, *facebookLoginButton, *twitterLoginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_account_login_title", nil);
    
    if (_social == nil) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_small"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonClicked)];
    }
    
    if (CONFIG_MOBILE_INTERNATIONAL == YES) {
        UIBarButtonItem *navLoginInternationalMobileButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"text_telephone_login", nil) style:UIBarButtonItemStylePlain target:self action:@selector(navLoginInternationalMobileButtonClicked)];
        self.navigationItem.rightBarButtonItem = navLoginInternationalMobileButton;
    }
    
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    
    // Close keyboard on click
    UITapGestureRecognizer *backgroundViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewClicked:)];
    [self.view addGestureRecognizer:backgroundViewTap];
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1];
    [self.view addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.leading.and.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
    
    GDUILabel *usernameLabel = [self commonLabel:NSLocalizedString(@"text_account_login_username", nil)];
    usernameLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:usernameLabel];
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([[System sharedInstance] isSimplifiedChineseLanguage] ? INPUT_TITLE_WIDTH_CN : INPUT_TITLE_WIDTH_EN, TEXT_FIELD_HEIGHT));
        make.leading.equalTo(self.view);
    }];
    
    _usernameTextField = [self commonTextField:CONFIG_MOBILE_INTERNATIONAL ?  NSLocalizedString(@"label_account_login_username", nil) : NSLocalizedString(@"label_account_login_username_telephone", nil)];
    [self.view addSubview:_usernameTextField];
    [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(usernameLabel.mas_trailing);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
        make.top.equalTo(usernameLabel);
    }];
    
    UIView *middleLine = [UIView new];
    middleLine.backgroundColor = CONFIG_DEFAULT_SEPARATOR_LINE_COLOR;
    [self.view addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.leading.and.trailing.equalTo(self.view);
        make.top.equalTo(usernameLabel.mas_bottom);
    }];
    
    UILabel *passwordLabel = [self commonLabel:NSLocalizedString(@"text_account_login_password", nil)];
    passwordLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleLine.mas_bottom);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
        make.leading.equalTo(usernameLabel);
        make.width.equalTo(usernameLabel);
    }];
    
    _passwordTextField = [self commonTextField:NSLocalizedString(@"label_account_login_password", nil)];
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_usernameTextField);
        make.trailing.equalTo(_usernameTextField.mas_trailing);
        make.height.mas_equalTo(_usernameTextField.mas_height);
        make.top.equalTo(passwordLabel);
    }];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1];
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.leading.and.trailing.equalTo(self.view);
        make.top.equalTo(passwordLabel.mas_bottom);
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
        make.top.equalTo(bottomLine.mas_bottom).mas_offset(20);
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
    }];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_registerButton setTitle:NSLocalizedString(@"button_account_login_register", nil) forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor colorWithHexString:@"808080" alpha:1.] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).mas_offset(20);
        make.leading.equalTo(_loginButton.mas_leading);
    }];
    
    _resetPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_resetPasswordButton setTitle:NSLocalizedString(@"button_account_login_reset_password", nil) forState:UIControlStateNormal];
    [_resetPasswordButton setTitleColor:[UIColor colorWithHexString:@"808080" alpha:1.] forState:UIControlStateNormal];
    _resetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_resetPasswordButton addTarget:self action:@selector(resetPasswordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetPasswordButton];
    [_resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).mas_offset(20);
        make.trailing.equalTo(_loginButton.mas_trailing);
    }];
    
    if (CONFIG_SOCIAL_LOGIN_ENABLED) {
        [self createSocialLoginSection];
    }
    
    // Need generate a new access token when the customer is logged, or there is no access token.
    if (self.requestNewAccessToken == YES || [[Customer sharedInstance] accessToken].length <= 0 || [[Customer sharedInstance] isLogged]) {
        [[AccountAPI sharedInstance] requestNewAccessTokenWithBlock:^(NSDictionary *data, NSString *error) {
            // TODO
        }];
    }
    
    // Debug
#ifdef DEBUG
    self.usernameTextField.text = @"sam.chen@opencart.cn";
    self.passwordTextField.text = @"123456";
#endif

}

- (void)createSocialLoginSection {
    if (_social) {
        return;
    }

    // Social login buttons
    NSMutableArray *loginButtons = [[NSMutableArray alloc] init];

    //QQ login button
    if (CONFIG_SHARESDK_QQ_ENABLED) {
        _qqLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_qqLoginButton setImage:[UIImage imageNamed:@"social_login_qq"] forState:UIControlStateNormal];
        [_qqLoginButton addTarget:self action:@selector(qqLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [loginButtons addObject:_qqLoginButton];
    }

    // Wechat login button
    if (CONFIG_SHARESDK_WECHAT_ENABLED && [WXApi isWXAppInstalled]) {
        _wechatLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wechatLoginButton setImage:[UIImage imageNamed:@"social_login_wechat"] forState:UIControlStateNormal];
        [_wechatLoginButton addTarget:self action:@selector(wechatLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [loginButtons addObject:_wechatLoginButton];
    }

    //Weibo login button
    if (CONFIG_SHARESDK_WEIBO_ENABLED) {
        _weiboLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weiboLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_weiboLoginButton addTarget:self action:@selector(weiboLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_weiboLoginButton setImage:[UIImage imageNamed:@"social_login_weibo"] forState:UIControlStateNormal];
        [loginButtons addObject:_weiboLoginButton];
    }

    // Facebook login button
    if (CONFIG_SHARESDK_FACEBOOK_ENABLED) {
        _facebookLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_facebookLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_facebookLoginButton addTarget:self action:@selector(facebookLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_facebookLoginButton setImage:[UIImage imageNamed:@"social_login_facebook"] forState:UIControlStateNormal];
        [loginButtons addObject:_facebookLoginButton];
    }

    // Twitter login button
    if (CONFIG_SHARESDK_TWITTER_ENABLED) {
        _twitterLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twitterLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_twitterLoginButton addTarget:self action:@selector(twitterLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_twitterLoginButton setImage:[UIImage imageNamed:@"social_login_twitter"] forState:UIControlStateNormal];
        [loginButtons addObject:_twitterLoginButton];
    }

    if (loginButtons.count < 1) {
        return;
    }

    // Social login section
    UILabel *socialLabel = [UILabel new];
    socialLabel.text = NSLocalizedString(@"label_account_login_social", nil);
    socialLabel.font = [UIFont systemFontOfSize:12];
    socialLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

    [self.view addSubview:socialLabel];
    [socialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-100);
        make.centerX.equalTo(self.view);
    }];

    UIView *socialLabelLeftLine = [UIView new];
    socialLabelLeftLine.backgroundColor = [UIColor colorWithHexString:@"cccccc" alpha:1];
    [self.view addSubview:socialLabelLeftLine];
    [socialLabelLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.height.mas_equalTo(0.5);
        make.trailing.equalTo(socialLabel.mas_leading).offset(-20);
        make.centerY.equalTo(socialLabel);
    }];

    UIView *socialLabelRightLine = [UIView new];
    socialLabelRightLine.backgroundColor = [UIColor colorWithHexString:@"cccccc" alpha:1];
    [self.view addSubview:socialLabelRightLine];
    [socialLabelRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(0.5);
        make.leading.equalTo(socialLabel.mas_trailing).offset(20);
        make.centerY.equalTo(socialLabel);
    }];

    // social stack view
    UIStackView *socialStackView = [[UIStackView alloc] init];
    socialStackView.distribution = UIStackViewDistributionEqualCentering;
    socialStackView.axis = UILayoutConstraintAxisHorizontal;
    socialStackView.spacing = 12;
    [self.view addSubview:socialStackView];
    [socialStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(socialLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];

    for (UIView *loginButton in loginButtons) {
        [socialStackView addArrangedSubview:loginButton];
    }
}

- (GDUILabel *)commonLabel:(NSString *)text {
    GDUILabel *label = [GDUILabel new];
    label.text = text;
    label.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
    label.backgroundColor = [UIColor whiteColor];
    label.paddingLeft = 10;
    label.paddingRight = 10;
    label.font = [UIFont systemFontOfSize:14];
    
    return label;
}

- (UITextField *)commonTextField:(NSString *)placeholder {
    UITextField *textField = [UITextField new];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = placeholder;
    
    return textField;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_social) {
        [_registerButton setHidden:YES];
        
        [_qqLoginButton setHidden:YES];
        [_wechatLoginButton setHidden:YES];
        [_weiboLoginButton setHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[_usernameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

#pragma mark - Actions

- (void)navLoginInternationalMobileButtonClicked {
    [self.view endEditing:YES];

    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] GET:@"settings/base" params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            return;
        }

        if (data) {
            NSArray *rawCallingCodes = [data objectForKey:@"calling_codes"];
            if (rawCallingCodes.count < 1) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:@"没有可用的注册手机区号，请联系管理员"];
                return;
            }

            NSArray *callingCodes = [CallingCodeModel arrayOfModelsFromDictionaries:rawCallingCodes error:nil];

            if (callingCodes.count < 1) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:@"没有可用的注册手机区号，请联系管理员"];
                return;
            }

            LoginInternationalMobileViewController *nextVC = [[LoginInternationalMobileViewController alloc] init];
            nextVC.callingCodes = callingCodes;
            [weakSelf.navigationController pushViewController:nextVC animated:YES];
        }
    }];
}

- (void)closeButtonClicked {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void)backgroundViewClicked:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

- (void)loginButtonClicked {
    [self.view endEditing:YES];
    
    //===== username =====
    if (_usernameTextField.hasText == NO) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_login_input_account", nil)];
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
    
    NSDictionary *params = @{@"account": _usernameTextField.text,
                             @"password": _passwordTextField.text,
                             @"social_provider": _social.provider ? _social.provider : @"",
                             @"social_uid": _social.uid ? _social.uid : @"",
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

- (void)registerButtonClicked {
    [self.view endEditing:YES];

    if (CONFIG_MOBILE_INTERNATIONAL == YES) {
        [self prepareCallingCodesForRegisterVC];
    } else {
        RegisterViewController *nextVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

- (void)resetPasswordButtonClicked {
    [self.view endEditing:YES];

    if (CONFIG_MOBILE_INTERNATIONAL) {
        [self prepareCallingCodesForResetPasswordVC];
    } else {
        AccountResetPasswordViewController *nextViewController = [[AccountResetPasswordViewController alloc] init];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark - Social login actions
- (void)wechatLoginButtonClicked {
    NSLog(@"Wechat login button clicked.");
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat result:^(NSError *error) {
        //
    }];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSLog(@"User data: %@",user.description);
            NSDictionary *userData = user.rawData;
            
            AccountSocialModel *social = [[AccountSocialModel alloc] init];
            social.provider = @"wechat";
            social.uid = user.uid;
            social.unionid = [userData objectForKey:@"unionid"] ? [userData objectForKey:@"unionid"] : @"";
            social.avatar = user.icon ? user.icon : @"";
            social.fullname = user.nickname ? user.nickname : @"";
            social.access_token = user.credential.token;
            
            [weakSelf connectInternalAccountTo:social];
        } else {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_account_login_wechat", nil)];
        }
    }];
}

- (void)qqLoginButtonClicked {
    NSLog(@"QQ login button clicked.");
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSLog(@"User data: %@",user.description);
            NSDictionary *userData = user.rawData;
            
            AccountSocialModel *social = [[AccountSocialModel alloc] init];
            social.provider = @"qq";
            social.uid = user.uid;
            social.unionid = @"";
            social.avatar = [userData objectForKey:@"figureurl_qq_2"] ? [userData objectForKey:@"figureurl_qq_2"] : user.icon;
            social.fullname = user.nickname ? user.nickname : @"";
            social.access_token = user.credential.token;
            
            [self connectInternalAccountTo:social];
        } else {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_account_login_qq", nil)];
        }
    }];
}

- (void)weiboLoginButtonClicked {
    NSLog(@"Weibo login button clicked.");
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSLog(@"User data: %@",user.description);
            NSDictionary *userData = user.rawData;
            
            AccountSocialModel *social = [[AccountSocialModel alloc] init];
            social.provider = @"weibo";
            social.uid = user.uid;
            social.unionid = @"";
            social.avatar = [userData objectForKey:@"avatar_large"] ? [userData objectForKey:@"avatar_large"] : user.icon;
            social.fullname = user.nickname ? user.nickname : @"";
            social.access_token = user.credential.token;
            
            [self connectInternalAccountTo:social];
        } else {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_account_login_weibo", nil)];
        }
    }];
}

- (void)facebookLoginButtonClicked {
    NSLog(@"Facebook login button clicked.");
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    [ShareSDK cancelAuthorize:SSDKPlatformTypeFacebook result:^(NSError *error) {
        //
    }];

    [ShareSDK getUserInfo:SSDKPlatformTypeFacebook onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSLog(@"%@", error);
        NSLog ( @"%@" ,[user rawData]);

        if (state == SSDKResponseStateSuccess) {
            AccountSocialModel *social = [[AccountSocialModel alloc] init];
            social.provider = @"facebook";
            social.uid = user.uid;
            social.unionid = @"";
            social.avatar = user.icon;
            social.fullname = user.nickname ? user.nickname : @"";
            social.access_token = user.credential.token;

            [self connectInternalAccountTo:social];
        } else {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_account_login_facebook", nil)];
        }
    }];
}

- (void)twitterLoginButtonClicked {
    NSLog(@"Twitter login button clicked.");
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    [ShareSDK getUserInfo:SSDKPlatformTypeTwitter onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSLog(@"%@", error);
        NSLog ( @"%@" ,[user rawData]);

        if (state == SSDKResponseStateSuccess) {
            AccountSocialModel *social = [[AccountSocialModel alloc] init];
            social.provider = @"twitter";
            social.uid = user.uid;
            social.unionid = @"";
            social.avatar = user.icon;
            social.fullname = user.nickname ? user.nickname : @"";
            social.access_token = user.credential.token;

            [self connectInternalAccountTo:social];
        } else {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_account_login_twitter", nil)];
        }
    }];
}

- (void)connectInternalAccountTo:(AccountSocialModel *)social {
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] POST:[NSString stringWithFormat:@"callbacks/social/%@", social.provider] params:[social toDictionary] callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (data) {
            //User exists, update account and pop back.
            AccountModel *account = [[AccountModel alloc] initWithDictionary:data error:nil];
            if (account) {
                [[Customer sharedInstance] save:account];
            }
            [weakSelf closeButtonClicked];
        }
        
        if (error) {
            if ([error isEqualToString:@"401"]) {
                //User not existed, proceed to next step.
                NSLog(@"Social account needs to connect an internal account.");
                
                AccountConnectViewController *nextVC = [[AccountConnectViewController alloc] init];
                nextVC.social = social;
                [weakSelf.navigationController pushViewController:nextVC animated:YES];
            } else {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }
    }];
}

- (void)popViewController {
    [self.rdv_tabBarController updateCartNumber];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    if (_social) {
        //Remove login from stack
        NSMutableArray *vcStack = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        [vcStack removeObjectsInRange:NSMakeRange(vcStack.count - 3, 2)];
        self.navigationController.viewControllers = vcStack;
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prepareCallingCodesForRegisterVC {
    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] GET:@"settings/base" params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            return;
        }

        if (data) {
            NSArray *rawCallingCodes = [data objectForKey:@"calling_codes"];
            if (rawCallingCodes.count < 1) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:@"没有可用的注册手机区号，请联系管理员"];
                return;
            }

            NSArray *callingCodes = [CallingCodeModel arrayOfModelsFromDictionaries:rawCallingCodes error:nil];

            if (callingCodes.count < 1) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:@"没有可用的注册手机区号，请联系管理员"];
                return;
            }

            RegisterViewController *nextVC = [[RegisterViewController alloc] init];
            nextVC.callingCodes = callingCodes;
            [weakSelf.navigationController pushViewController:nextVC animated:YES];
        }
    }];
}

- (void)prepareCallingCodesForResetPasswordVC {
    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] GET:@"settings/base" params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            return;
        }

        if (data) {
            NSArray *rawCallingCodes = [data objectForKey:@"calling_codes"];
            if (rawCallingCodes.count < 1) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:@"没有可用的注册手机区号，请联系管理员"];
                return;
            }

            NSArray *callingCodes = [CallingCodeModel arrayOfModelsFromDictionaries:rawCallingCodes error:nil];

            if (callingCodes.count < 1) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:@"没有可用的注册手机区号，请联系管理员"];
                return;
            }

            AccountResetPasswordViewController *nextVC = [[AccountResetPasswordViewController alloc] init];
            nextVC.callingCodes = callingCodes;
            [self.navigationController pushViewController:nextVC animated:YES];
        }
    }];
}
@end
