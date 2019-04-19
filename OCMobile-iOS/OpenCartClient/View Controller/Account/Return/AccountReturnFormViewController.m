//
//  AccountReturnFormViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnFormViewController.h"
#import "LoginViewController.h"
#import "TextFieldOnlyCell.h"
#import "TextViewOnlyCell.h"
#import "SwitchOnOffCell.h"
#import "QuantitySelectorCell.h"
#import "ReturnReasonSelectorCell.h"
#import "GDTableFormFooterButtonView.h"

@interface AccountReturnFormViewController () {
}

@property (strong, nonatomic) NSString *telephone, *comment;
@property (assign, nonatomic) BOOL opened;
@property (assign, nonatomic) NSInteger returnReasonId;

@end

@implementation AccountReturnFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_return_form_title", nil);

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
    [self.tableView registerClass:[SwitchOnOffCell class] forCellReuseIdentifier:kCellIdentifier_SwitchOnOffCell];
    [self.tableView registerClass:[QuantitySelectorCell class] forCellReuseIdentifier:kCellIdentifier_QuantitySelectorCell];
    [self.tableView registerClass:[ReturnReasonSelectorCell class] forCellReuseIdentifier:kCellIdentifier_ReturnReasonSelectorCell];
    [self.tableView registerClass:[TextViewOnlyCell class] forCellReuseIdentifier:kCellIdentifier_TextViewOnlyCell];

    GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [confirmButtonView.button addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = confirmButtonView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    switch (indexPath.row) {
        case 0: {
            TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
            [cell setPlaceholder:NSLocalizedString(@"label_account_return_form_telephone", nil) value:_telephone];
            cell.textFieldValueChangedBlock = ^(NSString *value) {
                weakSelf.telephone = value;
            };

            return cell;
            break;
        }
        case 1: {
            SwitchOnOffCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SwitchOnOffCell forIndexPath:indexPath];
            [cell setLabel:NSLocalizedString(@"label_account_return_form_opened", nil) on:_opened];
            cell.swithValueChangedBlock = ^(BOOL value) {
                weakSelf.opened = value;
            };

            return cell;
            break;
        }
        case 2: {
            QuantitySelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_QuantitySelectorCell forIndexPath:indexPath];
            [cell setPlaceholder:NSLocalizedString(@"label_account_return_form_quantity", nil) value:_quantity];
            cell.quantityControl.minimum = 1;
            cell.quantityValueChangedBlock = ^(NSInteger value) {
                weakSelf.quantity = value;
            };

            return cell;
            break;
        }
        case 3: {
            ReturnReasonSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ReturnReasonSelectorCell forIndexPath:indexPath];
            cell.label.text = NSLocalizedString(@"label_account_return_form_reason", nil);
            cell.selectedValueChangedBlock = ^(NSInteger returnReasonId) {
                weakSelf.returnReasonId = returnReasonId;
            };

            return cell;
            break;
        }
        case 4: {
            TextViewOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextViewOnlyCell forIndexPath:indexPath];
            [cell setPlaceholder:NSLocalizedString(@"label_account_return_form_comment", nil) value:_comment];
            cell.textViewValueChangedBlock = ^(NSString *value) {
                weakSelf.comment = value;
            };

            return cell;
            break;
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (void)saveButtonClicked {
    [self.view endEditing:YES];

    //telephone
    if (!_telephone.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_return_enter_telephone", nil)];
        return;
    }

    //qty
    if (_quantity <= 0) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_return_enter_aty", nil)];
        return;
    }

    //return reason
    if (_returnReasonId <= 0) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_return_enter_reason", nil)];
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"order_product_id": [NSNumber numberWithInteger: _orderProductId],
                             @"telephone": _telephone,
                             @"opened": _opened ? @1 : @0,
                             @"quantity": [NSNumber numberWithInteger:_quantity],
                             @"return_reason_id": [NSNumber numberWithInteger:_returnReasonId],
                             @"comment": _comment ? _comment : @"",
                             };

    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:@"order_returns" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_return_submitted", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

@end
