//
//  RegisterEmailViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 5/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "RegisterEmailViewController.h"
#import "RegisterViewController.h"
#import "Customer.h"
#import "LoginViewController.h"
#import "TextFieldOnlyCell.h"
#import "PasswordCell.h"
#import "SwitchOnOffCell.h"
#import "GDTableFormFooterButtonView.h"

@interface RegisterEmailViewController ()
@property (strong, nonatomic) NSString *fullname, *email, *password;
@property (assign, nonatomic) BOOL newsletter;
@end

@implementation RegisterEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_register_email_title", nil);

    //Create mobile register button on nav bar
    UIBarButtonItem *navRegisterByMobileButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"text_account_register_mobile_title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(navRegisterByMobileButtonClicked)];
    self.navigationItem.rightBarButtonItem = navRegisterByMobileButton;

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
    [self.tableView registerClass:[PasswordCell class] forCellReuseIdentifier:kCellIdentifier_PasswordCell];
    [self.tableView registerClass:[SwitchOnOffCell class] forCellReuseIdentifier:kCellIdentifier_SwitchOnOffCell];

    GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [confirmButtonView.button addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = confirmButtonView;

    _newsletter = YES;

    if (_social) {
        _fullname = _social.fullname;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //firstname, email, password, confirm, newsletter
    __weak typeof(self) weakSelf = self;

    switch (indexPath.row) {
        case 0: {
            TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
            [cell setPlaceholder:NSLocalizedString(@"label_account_register_firstname", nil) value:_fullname];
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.fullname = value;
            };

            return cell;
            break;
        }
        case 1: {
            TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
            [cell setPlaceholder:NSLocalizedString(@"toast_register_input_email", nil) value:_email];
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.email = value;
            };

            return cell;
            break;
        }
        case 2: {
            PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PasswordCell forIndexPath:indexPath];
            cell.text = _password;
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.password = value;
            };

            return cell;
            break;
        }
        case 3: {
            SwitchOnOffCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SwitchOnOffCell forIndexPath:indexPath];
            [cell setLabel:NSLocalizedString(@"label_account_register_newsletter", nil) on:_newsletter];
            cell.swithValueChangedBlock = ^(BOOL value) {
                weakSelf.newsletter = value;
            };

            return cell;
            break;
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)navRegisterByMobileButtonClicked {
    [self.view endEditing:YES];

    RegisterViewController *nextVC = [RegisterViewController new];
    nextVC.social = _social;
    [self.navigationController pushViewController:nextVC animated:YES];

    //Remove self from stack
    NSMutableArray *vcStack = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [vcStack removeObjectAtIndex:vcStack.count - 2];
    self.navigationController.viewControllers = vcStack;
}

- (void)registerButtonClicked {
    [self.view endEditing:YES];

    // ===== firstname =====
    if (!_fullname.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_firstname", nil)];
        return;
    }

    // ===== email =====
    if (!_email.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_email", nil)];
        return;
    }

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    if ([emailTest evaluateWithObject:_email] == NO) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_email_invalid", nil)];
        return;
    }

    // ===== password =====
    if (!_password.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_password", nil)];
        return;
    }

    // ===== confirm password =====
    //  if (!_confirm.length) {
    //    [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_confirm", nil)];
    //    return;
    //  }

    // ===== password and confirm compare =====
    //  if (![_password isEqualToString:_confirm]) {
    //    [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_password_diff", nil)];
    //    return;
    //  }

    // ===== Call register API =====
    NSDictionary *params = @{
                             @"type": @"email",
                             @"fullname": _fullname,
                             @"account": _email,
                             @"password": _password,
                             @"confirm_password": _password,
                             @"newsletter": [NSNumber numberWithInt:_newsletter ? 1 : 0],
                             @"social_provider": _social.provider ? _social.provider : @"",
                             @"social_uid": _social.uid ? _social.uid : @"",
                             };

    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:@"account/register" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            NSLog(@"New account registered.");
            AccountModel *account = [[AccountModel alloc] initWithDictionary:data error:nil];

            [[Customer sharedInstance] save:account];

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

@end
