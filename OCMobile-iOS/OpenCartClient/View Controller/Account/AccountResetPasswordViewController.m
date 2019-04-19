//
//  AccountResetPasswordViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountResetPasswordViewController.h"
#import "AccountResetPasswordByEmailViewController.h"
#import "LoginViewController.h"
#import "NBPhoneNumberUtil.h"
#import "GDSimpleTextField.h"
#import "GDCountrySelectViewController.h"

static CGFloat const TEXT_FIELD_HEIGHT = 44.0;
static CGFloat const REGION_BUTTON_WIDTH = 100.0;

@interface AccountResetPasswordViewController ()
@property (strong, nonatomic) NSString *regionCode;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) GDSimpleTextField *telephoneTextField, *smsTextField;
@property (strong, nonatomic) UIButton *regionButton, *smsButton, *continueButton,*resetPasswordByEmailButton;
@end

@implementation AccountResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    self.title = NSLocalizedString(@"text_account_reset_password_title", nil);

    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = NSLocalizedString(@"help_account_reset_password_mobile", nil);
    _tipLabel.numberOfLines = 0;
    _tipLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];

    if (CONFIG_MOBILE_INTERNATIONAL) {
        CallingCodeModel *firstCallingCode = [_callingCodes firstObject];
        _regionCode = firstCallingCode.code;
        _regionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _regionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_regionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _regionButton.backgroundColor = [UIColor whiteColor];
        _regionButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _regionButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
        _regionButton.layer.borderColor = [UIColor colorWithHexString:@"C8C6CC" alpha:1].CGColor;
        _regionButton.layer.borderWidth = 0.5;
        [_regionButton setTitle:[NSString stringWithFormat:@"%@ +%@", firstCallingCode.name, firstCallingCode.code] forState:UIControlStateNormal];

        [_regionButton addTarget:self action:@selector(regionButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:_regionButton];
        [_regionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipLabel.mas_bottom).offset(20);
            make.leading.equalTo(_tipLabel.mas_leading);
            make.size.mas_equalTo(CGSizeMake(REGION_BUTTON_WIDTH, TEXT_FIELD_HEIGHT));
        }];
    }

    _telephoneTextField = [[GDSimpleTextField alloc] init];
    _telephoneTextField.placeholder = NSLocalizedString(@"label_account_reset_password_mobile", nil);
    _telephoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_telephoneTextField];
    [_telephoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (CONFIG_MOBILE_INTERNATIONAL) {
            make.top.equalTo(_regionButton);
            make.leading.equalTo(_regionButton.mas_trailing).offset(10);
            make.trailing.equalTo(_tipLabel.mas_trailing);
            make.height.equalTo(_regionButton);
        } else {
            make.top.equalTo(_tipLabel.mas_bottom).offset(20);
            make.leading.equalTo(_tipLabel.mas_leading);
            make.trailing.equalTo(_tipLabel.mas_trailing);
            make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
        }
    }];

    _smsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_smsButton setTitle:NSLocalizedString(@"button_account_reset_password_sms", nil) forState:UIControlStateNormal];
    [_smsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _smsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_smsButton setBackgroundColor:[UIColor blackColor]];
    _smsButton.layer.cornerRadius = 4;
    _smsButton.clipsToBounds = YES;
    [_smsButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smsButton];
    [_smsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_telephoneTextField.mas_bottom).offset(20);
        make.trailing.equalTo(_tipLabel.mas_trailing);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
    }];

    _smsTextField = [[GDSimpleTextField alloc] init];
    _smsTextField.placeholder = NSLocalizedString(@"label_account_reset_password_sms", nil);
    _smsTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_smsTextField];
    [_smsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_smsButton.mas_top);
        make.leading.equalTo(_tipLabel.mas_leading);
        make.trailing.equalTo(_smsButton.mas_leading).mas_offset(-20);
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
        make.top.equalTo(_smsTextField.mas_bottom).mas_offset(20);
        make.leading.equalTo(_tipLabel.mas_leading);
        make.trailing.equalTo(_tipLabel.mas_trailing);
        make.height.mas_equalTo(TEXT_FIELD_HEIGHT);
    }];

    _resetPasswordByEmailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_resetPasswordByEmailButton setTitle:NSLocalizedString(@"button_account_reset_password_email", nil) forState:UIControlStateNormal];
    [_resetPasswordByEmailButton setTitleColor:[UIColor colorWithHexString:@"808080" alpha:1.] forState:UIControlStateNormal];
    _resetPasswordByEmailButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_resetPasswordByEmailButton addTarget:self action:@selector(goToResetPasswordByEmailVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetPasswordByEmailButton];
    [_resetPasswordByEmailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_continueButton.mas_bottom).mas_offset(20);
        make.leading.equalTo(_tipLabel.mas_leading);
    }];
}

- (void)sendSMS {
    [self.view endEditing:YES];

    if (_telephoneTextField.hasText == NO) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_telephone_invalid", nil)];
        return;
    }

    __weak typeof(self) weakSelf = self;

    [MBProgressHUD showLoadingHUDToView:self.view];
    //First step. check if telephone exists.
    [[Network sharedInstance] POST:@"account/check_account" params:@{@"account": _telephoneTextField.text} callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            //手机号存在，发短信
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:weakSelf.telephoneTextField.text forKey:@"telephone"];

            if (CONFIG_MOBILE_INTERNATIONAL == YES) {
                [params setValue:self.regionCode forKey:@"region_code"];
            }

            [[Network sharedInstance] POST:@"account/send_sms" params:params callback:^(NSDictionary *data, NSString *error) {
                if (data) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                    [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_register_sms_sent", nil)];
                    [weakSelf sendSMSButtonCountdown];
                }

                if (error) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                    [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_register_sms_sent_error", nil)];
                }
            }];
        }

        if (error) {
            //手机号不存在，报错
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_telephone_not_registered", nil)];
        }
    }];
}

-(void)sendSMSButtonCountdown {
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_smsButton setTitle:NSLocalizedString(@"button_account_reset_password_sms", nil) forState:UIControlStateNormal];
                _smsButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                //[UIView beginAnimations:nil context:nil];
                //[UIView setAnimationDuration:1];
                [_smsButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"text_register_sms_wait", nil), strTime] forState:UIControlStateNormal];
                //[UIView commitAnimations];
                _smsButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)submit {
    [self.view endEditing:YES];

    if (!_telephoneTextField.hasText) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_telephone", nil)];
        return;
    }

    // ===== sms code =====
    if (!_smsTextField.hasText) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_sms_code", nil)];
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"telephone" forKey:@"type"];
    [params setValue:_telephoneTextField.text forKey:@"account"];
    [params setValue:_smsTextField.text forKey:@"sms_code"];

    if (CONFIG_MOBILE_INTERNATIONAL == YES) {
        [params setValue:self.regionCode forKey:@"region_code"];
    }

    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:@"account/reset_password" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_new_password_sent", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)goToResetPasswordByEmailVC {
    [self.view endEditing:YES];

    AccountResetPasswordByEmailViewController *nextVC = [AccountResetPasswordByEmailViewController new];
    [self.navigationController pushViewController:nextVC animated:YES];
    
    //Remove self from stack
    NSMutableArray *vcStack = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [vcStack removeObjectAtIndex:vcStack.count - 2];
    self.navigationController.viewControllers = vcStack;
}

- (void)regionButtonClicked {
    GDCountrySelectViewController *countrySelectVC = [[GDCountrySelectViewController alloc] init];
    countrySelectVC.callingCodes = _callingCodes;

    __weak typeof(self) weakSelf = self;
    countrySelectVC.countrySelectedBlock = ^(NSString *regionCode) {
        weakSelf.regionCode = regionCode;

        for (CallingCodeModel *callingCode in weakSelf.callingCodes) {
            if ([callingCode.code isEqualToString:weakSelf.regionCode]) {
                [weakSelf.regionButton setTitle:[NSString stringWithFormat:@"%@ +%@",callingCode.name, callingCode.code] forState:UIControlStateNormal];
                break;
            }
        }
    };

    [self presentViewController:countrySelectVC animated:YES completion:nil];
}
@end
