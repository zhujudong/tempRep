//
//  AccountPasswordViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 5/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountPasswordViewController.h"
#import "LoginViewController.h"
#import "Customer.h"
#import "TextFieldOnlyCell.h"
#import "GDTableFormFooterButtonView.h"

@interface AccountPasswordViewController ()
@property (strong, nonatomic) NSString *oldPassword, *password, *confirmPassword;
@end

@implementation AccountPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_password_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[TextFieldOnlyCell class] forCellReuseIdentifier:kCellIdentifier_TextFieldOnlyCell];

    GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [confirmButtonView.button addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = confirmButtonView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];

    __weak typeof(self) weakSelf = self;

    switch (indexPath.row) {
        case 0: {
            [cell setPlaceholder:NSLocalizedString(@"label_old_password", nil) value:nil];
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.oldPassword = value;
            };
            break;
        }
        case 1: {
            [cell setPlaceholder:NSLocalizedString(@"label_new_password", nil) value:nil];
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.password = value;
            };
            break;
        }
        case 2: {
            [cell setPlaceholder:NSLocalizedString(@"label_new_password_confirm", nil) value:nil];
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.confirmPassword = value;
            };
            break;
        }
    }

    cell.textField.secureTextEntry = YES;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)saveButtonClicked {
    [self.view endEditing:YES];

    // ===== old password =====
    if (!_oldPassword.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_enter_old_password", nil)];
        return;
    }

    // ===== new password =====
    if (!_password.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_enter_new_password", nil)];
        return;
    }

    // ===== confirm password =====
    if (!_confirmPassword.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_confirm", nil)];
        return;
    }

    // ===== compare new password =====
    if (![_confirmPassword isEqualToString:_password]) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_password_diff", nil)];
        return;
    }

    [self requestAPI:_oldPassword password:_password confirm:_confirmPassword];
}

- (void)requestAPI:(NSString *)oldPassword password:(NSString *)password confirm:(NSString *)confirm {
    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"old_password": oldPassword,
                             @"password": password,
                             @"confirm_password": confirm,
                             };
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] PUT:@"account/me/password" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];

            AccountModel *newAccount = [[AccountModel alloc] initWithDictionary:data error:nil];
            if (newAccount) {
                [[Customer sharedInstance] save:newAccount];
            }

            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_password_change_success", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}
@end
