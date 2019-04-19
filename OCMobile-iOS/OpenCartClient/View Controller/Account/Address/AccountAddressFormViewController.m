//
//  AccountAddressFormViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountAddressFormViewController.h"
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
    CellIndexLocation,
    CellIndexAddress,
    CellIndexDefault
};

@interface AccountAddressFormViewController ()
@end

@implementation AccountAddressFormViewController

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
    [self.tableView registerClass:[TextViewOnlyCell class] forCellReuseIdentifier:kCellIdentifier_TextViewOnlyCell];
    [self.tableView registerClass:[SwitchOnOffCell class] forCellReuseIdentifier:kCellIdentifier_SwitchOnOffCell];
    [self.tableView registerClass:[LocationSelectorCell class] forCellReuseIdentifier:kCellIdentifier_LocationSelectorCell];

    GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [confirmButtonView.button addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = confirmButtonView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hideSetDefaultButton ? 5 : 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    if (indexPath.row == CellIndexFullname) {
        TextFieldOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextFieldOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"label_enter_fullname", nil) value:weakSelf.address.fullname];
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
        [cell setPlaceholder:NSLocalizedString(@"label_enter_postcode", nil) value:weakSelf.address.postcode];
        cell.textFieldValueChangedBlock = ^(NSString *value) {
            weakSelf.address.postcode = value;
        };
        return cell;
    }

    if (indexPath.row == CellIndexLocation) {
        LocationSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LocationSelectorCell forIndexPath:indexPath];
        [cell setAddress:[weakSelf.address copy]];
        cell.viewController = weakSelf;
        cell.locationValueChangedBlock = ^(AccountAddressItemModel *address) {
            weakSelf.address.countryId = address.countryId;
            weakSelf.address.zoneId = address.zoneId;
            weakSelf.address.cityId = address.cityId;
            weakSelf.address.countyId = address.countyId;
        };
        return cell;
    }

    if (indexPath.row == CellIndexAddress) {
        TextViewOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextViewOnlyCell forIndexPath:indexPath];
        [cell setPlaceholder:NSLocalizedString(@"toast_enter_address1", nil) value:weakSelf.address.address1];
        cell.textViewValueChangedBlock = ^(NSString *value) {
            weakSelf.address.address1 = value;
        };
        return cell;
    }

    if (indexPath.row == CellIndexDefault) {
        SwitchOnOffCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SwitchOnOffCell forIndexPath:indexPath];
        [cell setLabel:NSLocalizedString(@"label_default_address", nil) on:weakSelf.address.isDefault];
        cell.swithValueChangedBlock = ^(BOOL value) {
            weakSelf.address.isDefault = value;
        };
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)saveButtonClicked {
    [self.view endEditing:YES];

    //===== fullname =====
    if (_address.fullname.length < 1) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_register_input_firstname", nil)];
        return;
    }

    //===== telephone =====
    if (_address.telephone.length < 1) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_return_enter_telephone", nil)];
        return;
    }

    //===== country/zone/city =====
    if (_address.countryId < 1 || _address.zoneId < 1 || _address.cityId < 1 || _address.countyId < 1) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_select_location", nil)];
        return;
    }

    //===== address1 =====
    if (_address.address1.length < 1) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_enter_address1", nil)];
        return;
    }

    // Call API
    [MBProgressHUD showLoadingHUDToView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if (_address.addressId) {
        [params setObject: [NSNumber numberWithInteger:_address.addressId] forKey:@"address_id"];
    }

    [params setObject:_address.fullname forKey:@"fullname"];
    [params setObject:_address.telephone ? _address.telephone : @"" forKey:@"telephone"];
    [params setObject: [NSNumber numberWithInteger:_address.countryId] forKey:@"country_id"];
    [params setObject: [NSNumber numberWithInteger:_address.zoneId] forKey:@"zone_id"];
    [params setObject: [NSNumber numberWithInteger:_address.cityId] forKey:@"city_id"];
    [params setObject:_address.city ? _address.city : @"" forKey:@"city"];
    [params setObject: [NSNumber numberWithInteger:_address.countyId] forKey:@"county_id"];
    [params setObject:_address.postcode ? _address.postcode : @"" forKey:@"postcode"];
    [params setObject:_address.address1 forKey:@"address_1"];
    [params setObject: [NSNumber numberWithInt:_address.isDefault] forKey:@"default"];

    __weak typeof(self) weakSelf = self;

    // Edit address
    if (_address.addressId) {
        NSString *requestUrl = [NSString stringWithFormat:@"addresses/%ld", (long)_address.addressId];
        [[Network sharedInstance] PUT:requestUrl params:params callback:^(NSDictionary *data, NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            if (data) {
                [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_address_save_success", nil)];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }

            if (error) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    } else { // Add address
        [[Network sharedInstance] POST:@"addresses" params:params callback:^(NSDictionary *data, NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];

            if (data) {
                [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_new_address_save_success", nil)];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }

            if (error) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    }
}
@end
