//
//  AccountEditViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 5/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountEditViewController.h"
#import "Customer.h"
#import "AccountModel.h"
#import "LoginViewController.h"
#import "TextFieldOnlyCell.h"

#import "GDTableFormFooterButtonView.h"

typedef NS_ENUM(NSInteger, RowIndex) {
    RowIndexFirstname,
    RowIndexEmail,
    RowIndexTelephone,
};

@interface AccountEditViewController ()
@end

@implementation AccountEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_edit", nil);

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
        case RowIndexFirstname: {
            [cell setPlaceholder:NSLocalizedString(@"text_account_edit_firstname", nil) value:_firstname];
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.firstname = value;
            };
            break;
        }
        case RowIndexEmail: {
            [cell setPlaceholder:NSLocalizedString(@"text_account_edit_email", nil) value:_email];
            if (_email.length) {
                [cell setDisabled];
            }
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.email = value;
            };
            break;
        }
        case RowIndexTelephone: {
            [cell setPlaceholder:NSLocalizedString(@"text_account_edit_telephone", nil) value:_telephone];
            if (_telephone.length) {
                [cell setDisabled];
            }
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.telephone = value;
            };
            break;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)saveButtonClicked {
    [self.view endEditing:YES];

    // ===== firstname =====
    if (!_firstname.length) {
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

    // ===== telephone =====
    if (!_telephone.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_telephone", nil)];
        return;
    }

    [self requestAPI];
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"firstname": _firstname,
                             @"email": _email,
                             @"telephone": _telephone,
                             };

    [[Network sharedInstance] PUT:@"account/me" params:params callback:^(NSDictionary *data, NSString *error) {
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            return;
        }

        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            AccountModel *account = [[AccountModel alloc] initWithDictionary:data error:nil];

            if (account) {
                [[Customer sharedInstance] save:account];
            }

            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_account_edit_success", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
