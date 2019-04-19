//
//  AccountAddressFormViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountAddressFormInternationalViewController.h"
#import "LoginViewController.h"
#import "TextFieldOnlyCell.h"
#import "TextViewOnlyCell.h"
#import "SwitchOnOffCell.h"
#import "LocationSelectorCell.h"
#import "GDTableFormFooterButtonView.h"

typedef NS_ENUM(NSInteger, CellIndex) {
    CellIndexFullname,
    CellIndexTelephone,
    CellIndexPostcode,
    CellIndexCity,
    CellIndexLocation,
    CellIndexAddress1,
    CellIndexAddress2,
    CellIndexDefault
};

@interface AccountAddressFormInternationalViewController ()
@end

@implementation AccountAddressFormInternationalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(_address ? @"text_edit_address" : @"text_new_address", nil);

    if (!_address) {
        _address = [[AccountAddressItemModel alloc] init];
    }

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
    [self.tableView registerClass:[SwitchOnOffCell class] forCellReuseIdentifier:kCellIdentifier_SwitchOnOffCell];
    [self.tableView registerClass:[LocationSelectorCell class] forCellReuseIdentifier:kCellIdentifier_LocationSelectorCell];

    GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [confirmButtonView.button addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = confirmButtonView;
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hideSetDefaultButton ? 7 : 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    if (indexPath.row == CellIndexFullname) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"label_enter_fullname", nil) value:_address.fullname];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.address.fullname = value;
        };
        return cell;
    }

    if (indexPath.row == CellIndexTelephone) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"label_enter_telephone", nil) value:weakSelf.address.telephone];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.address.telephone = value;
        };
        return cell;
    }

    if (indexPath.row == CellIndexPostcode) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"label_enter_postcode", nil) value:_address.postcode];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.address.postcode = value;
        };

        return cell;
    }

    if (indexPath.row == CellIndexLocation) {
        LocationSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LocationSelectorCell forIndexPath:indexPath];
        [cell setAddress:[_address copy]];
        cell.viewController = weakSelf;
        cell.locationValueChangedBlock = ^(AccountAddressItemModel *address) {
            weakSelf.address.countryId = address.countryId;
            weakSelf.address.zoneId = address.zoneId;
            weakSelf.address.cityId = address.cityId;
            weakSelf.address.countyId = address.countyId;
        };
        return cell;
    }

    if (indexPath.row == CellIndexCity) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"label_input_city", nil) value:_address.city];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.address.city = value;
        };
        return cell;
    }

    if (indexPath.row == CellIndexAddress1) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"toast_enter_address1", nil) value:_address.address1];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.address.address1 = value;
        };
        return cell;
    }

    if (indexPath.row == CellIndexAddress2) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"toast_enter_address2", nil) value:_address.address2];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.address.address2 = value;
        };
        return cell;
    }

    if (indexPath.row == CellIndexDefault) {
        SwitchOnOffCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SwitchOnOffCell forIndexPath:indexPath];
        [cell setLabel:NSLocalizedString(@"label_default_address", nil) on:_address.isDefault];
        cell.swithValueChangedBlock = ^(BOOL value) {
            weakSelf.address.isDefault = value;
        };
        return cell;
    }

    return nil;
}

#pragma mark - actions
- (void)saveButtonClicked {
    [self.view endEditing:YES];

    //===== fullname =====
    if (!_address.fullname.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_fullname", nil)];
        return;
    }

    //===== telephone =====
    if (!_address.telephone.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_return_enter_telephone", nil)];
        return;
    }

        //===== City =====
    if (!_address.city.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_input_city", nil)];
        return;
    }

    //===== country/zone =====
    if (!_address.countryId || !_address.zoneId) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_select_location", nil)];
        return;
    }

    //===== address1 =====
    if (!_address.address1.length) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_enter_address1", nil)];
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (_address.addressId) {
        [parameters setObject: [NSNumber numberWithInteger:_address.addressId] forKey:@"address_id"];
    }

    [parameters setObject:_address.fullname forKey:@"fullname"];
    [parameters setObject:_address.telephone forKey:@"telephone"];
    [parameters setObject: [NSNumber numberWithInteger:_address.countryId] forKey:@"country_id"];
    [parameters setObject: [NSNumber numberWithInteger:_address.zoneId] forKey:@"zone_id"];
    [parameters setObject:_address.city forKey:@"city"];
    [parameters setObject:_address.postcode ? _address.postcode : @"" forKey:@"postcode"];
    [parameters setObject:_address.address1 forKey:@"address_1"];
    [parameters setObject:_address.address2 ? _address.address2 : @"" forKey:@"address_2"];
    [parameters setObject: [NSNumber numberWithInt:_address.isDefault] forKey:@"default"];

    if (_address.addressId) { // Edit address
        __weak typeof(self) weakSelf = self;

        [[Network sharedInstance] PUT:[NSString stringWithFormat:@"addresses/%ld", (long)_address.addressId] params:parameters callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_address_save_success", nil)];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }

            if (error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    } else { // Add address
        __weak typeof(self) weakSelf = self;

        [[Network sharedInstance] POST:@"addresses" params:parameters callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_new_address_save_success", nil)];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }

            if (error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    }
}
@end
