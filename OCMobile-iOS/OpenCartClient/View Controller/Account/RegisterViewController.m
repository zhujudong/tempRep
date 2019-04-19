//
//  RegisterViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 5/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterEmailViewController.h"
#import "MBProgressHUD.h"
#import "Customer.h"
#import "NBPhoneNumberUtil.h"
#import "VerificationTextFieldWithButtonCell.h"
#import "TextFieldOnlyCell.h"
#import "MobileInputCell.h"
#import "PasswordCell.h"
#import "SwitchOnOffCell.h"
#import "GDTableFormFooterButtonView.h"
#import "SendSMSButton.h"
#import "GDCountrySelectViewController.h"

typedef NS_ENUM(NSInteger, RowIndex) {
    RowIndexMobile,
    RowIndexSMSCode,
    RowIndexFullname,
    RowIndexPassword,
    RowIndexNewsletter,
};

@interface RegisterViewController () {
}
//telephone, sms, firstname, password, confirm, newsletter
@property (strong, nonatomic) NSString *regionCode, *telephone, *sms, *fullname, *password;
@property (assign, nonatomic) BOOL newsletter;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Hide back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;

    self.title = NSLocalizedString(@"text_account_register_mobile_title", nil);

    UIBarButtonItem *navRegisterByEmailButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"text_account_register_email_title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(navRegisterByEmailButtonClicked)];
    self.navigationItem.rightBarButtonItem = navRegisterByEmailButton;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[TextFieldOnlyCell class] forCellReuseIdentifier:kCellIdentifier_TextFieldOnlyCell];
    [self.tableView registerClass:[MobileInputCell class] forCellReuseIdentifier:kCellIdentifier_MobileInputCell];
    [self.tableView registerClass:[PasswordCell class] forCellReuseIdentifier:kCellIdentifier_PasswordCell];
    [self.tableView registerClass:[SwitchOnOffCell class] forCellReuseIdentifier:kCellIdentifier_SwitchOnOffCell];
    [self.tableView registerClass:[VerificationTextFieldWithButtonCell class] forCellReuseIdentifier:kCellIdentifier_VerificationTextFieldWithButtonCell];

    GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [confirmButtonView.button addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = confirmButtonView;

    _newsletter = YES;

    if (CONFIG_MOBILE_INTERNATIONAL) {
        CallingCodeModel *firstCallingCode = [_callingCodes firstObject];
        _regionCode = firstCallingCode.code;
    }

    if (_social) {
        _fullname = _social.fullname;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    if (indexPath.row == RowIndexMobile) {
        MobileInputCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MobileInputCell forIndexPath:indexPath];

        cell.callingCodes = _callingCodes;
        cell.regionCode = _regionCode;
        cell.mobileNumber = _telephone;

        cell.mobileNumberChangedBlock = ^(NSString *telephone) {
            weakSelf.telephone = telephone;
        };

        cell.regionButtonClickedBlock = ^() {
            GDCountrySelectViewController *countrySelectVC = [[GDCountrySelectViewController alloc] init];
            countrySelectVC.callingCodes = _callingCodes;
            countrySelectVC.countrySelectedBlock = ^(NSString *regionCode) {
                _regionCode = regionCode;
                [weakSelf regionCodeChanged];
            };

            [self presentViewController:countrySelectVC animated:YES completion:nil];
        };

        return cell;
    }

    if (indexPath.row == RowIndexSMSCode) {
        VerificationTextFieldWithButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_VerificationTextFieldWithButtonCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"toast_register_input_sms_code", nil) value:_sms];
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.sendSMSButtonClickedBlock = ^(SendSMSButton *button) {
            [weakSelf sendSMSButtonClicked:button];
        };

        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.sms = value;
        };

        return cell;
    }

    if (indexPath.row == RowIndexFullname) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"label_account_register_firstname", nil) value:_fullname];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.fullname = value;
        };

        return cell;
    }

    if (indexPath.row == RowIndexPassword) {
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PasswordCell forIndexPath:indexPath];
        [cell setText:_password];

        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.password = value;
        };

        return cell;
    }

    if (indexPath.row == RowIndexNewsletter) {
        SwitchOnOffCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SwitchOnOffCell forIndexPath:indexPath];
        [cell setLabel:NSLocalizedString(@"label_account_register_newsletter", nil) on:_newsletter];
        cell.swithValueChangedBlock = ^(BOOL value) {
            weakSelf.newsletter = value;
        };

        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)navRegisterByEmailButtonClicked {
    [self.view endEditing:YES];

    RegisterEmailViewController *nextVC = [RegisterEmailViewController new];
    nextVC.social = _social;
    [self.navigationController pushViewController:nextVC animated:YES];

    //Remove self from stack
    NSMutableArray *vcStack = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [vcStack removeObjectAtIndex:vcStack.count - 2];
    self.navigationController.viewControllers = vcStack;
}

- (void)sendSMSButtonClicked:(SendSMSButton *)sender {
    SendSMSButton *sendSmsButton = (SendSMSButton *)sender;
    [self.view endEditing:YES];

    if (!_telephone.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_telephone_invalid", nil)];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    //First step. check if telephone exists.
    [[Network sharedInstance] POST:@"account/check_account" params:@{@"account": _telephone} callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            //200 手机号已存在，不能注册
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_register_telephone_taken", nil)];
        }

        if (error) {
            //不存在，发送短信
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:_telephone forKey:@"telephone"];

            if (CONFIG_MOBILE_INTERNATIONAL == YES) {
                [params setValue:self.regionCode forKey:@"region_code"];
            }

            [[Network sharedInstance] POST:@"account/send_sms" params:params callback:^(NSDictionary *data, NSString *error) {
                if (data) { //SMS success
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                    [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_register_sms_sent", nil)];
                    [sendSmsButton disableButtonAndCountdownFor:60];
                }

                if (error) { // SMS error
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                    [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_register_sms_sent_error", nil)];
                }
            }];
        }
    }];
}

- (void)registerButtonClicked {
    [self.view endEditing:YES];

    // ===== telephone =====
    if (!_telephone.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_telephone", nil)];
        return;
    }

    // ===== sms code =====
    if (!_sms.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_sms_code", nil)];
        return;
    }

    // ===== firstname =====
    if (!_fullname.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_firstname", nil)];
        return;
    }

    // ===== password =====
    if (!_password.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_password", nil)];
        return;
    }

    // ===== Call register API =====
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"telephone" forKey:@"type"];
    [params setValue:_telephone forKey:@"account"];
    [params setValue:_sms forKey:@"sms_code"];
    [params setValue:_fullname forKey:@"fullname"];
    [params setValue:_password forKey:@"password"];
    [params setValue:_password forKey:@"confirm_password"];
    [params setValue:_newsletter ? @1 : @0 forKey:@"newsletter"];
    [params setValue:_social.provider ? _social.provider : @"" forKey:@"social_provider"];
    [params setValue:_social.uid ? _social.uid : @"" forKey:@"social_uid"];

    if (CONFIG_MOBILE_INTERNATIONAL == YES) {
        [params setValue:self.regionCode forKey:@"region_code"];
    }

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    [[Network sharedInstance] POST:@"account/register" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            AccountModel *account = [[AccountModel alloc] initWithDictionary:data error:nil];
            if (account) {
                [[Customer sharedInstance] save:account];
            }

            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_register_success", nil)];

            // Dismiss popup navigation controller
            [self dismissViewControllerAnimated:YES completion:^{
                //
            }];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)regionCodeChanged {
    MobileInputCell *cell = (MobileInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:RowIndexMobile inSection:0]];

    cell.regionCode = _regionCode;
}

@end
