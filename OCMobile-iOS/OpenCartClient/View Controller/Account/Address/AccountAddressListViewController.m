//
//  AccountAddressListViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountAddressListViewController.h"
#import "AccountAddressCell.h"
#import "AccountAddressListModel.h"
#import "AccountAddressItemModel.h"
#import "EmptyView.h"
#import "AccountAddressFormViewController.h"
#import "AccountAddressFormInternationalViewController.h"
#import "Customer.h"
#import "LoginViewController.h"
#import "GDRefreshNormalHeader.h"

@interface AccountAddressListViewController () {
    BOOL showHUD;
}
@property (strong, nonatomic) AccountAddressListModel *addressesModel;
@end

@implementation AccountAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Hide back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;

    showHUD = YES;
    self.title = NSLocalizedString(@"text_address_book", nil);

    UIBarButtonItem *navNewAddressButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_new_address", nil) style:UIBarButtonItemStylePlain target:self action:@selector(navNewAddressButtonClicked)];
    self.navigationItem.rightBarButtonItem = navNewAddressButton;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[AccountAddressCell class] forCellReuseIdentifier:kCellIdentifier_AccountAddressCell];

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)loadData {
    NSLog(@"Load addresses.");
    self.tableView.backgroundView = nil;
    if (showHUD) {
        showHUD = NO;
        [MBProgressHUD showLoadingHUDToView:self.view];
    }

    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"addresses" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([weakSelf.tableView.mj_header isRefreshing]) {
                [weakSelf.tableView.mj_header endRefreshing];
            }

            weakSelf.addressesModel = [[AccountAddressListModel alloc] initWithDictionary:data error:nil];

            if (weakSelf.addressesModel.addresses.count) {
                if (weakSelf.tableView.mj_header == nil) {
                    weakSelf.tableView.mj_header = [GDRefreshNormalHeader headerWithRefreshingBlock:^{
                        showHUD = YES;
                        [weakSelf loadData];
                    }];
                }
            } else {
                weakSelf.addressesModel = nil;
                showHUD = YES;
                weakSelf.tableView.mj_header = nil;
                EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.bounds.size.width, weakSelf.view.bounds.size.height)];
                emptyView.iconImageView.image = [UIImage imageNamed:@"empty_address"];
                emptyView.textLabel.text = NSLocalizedString(@"empty_no_address", nil);
                [emptyView.reloadButton addTarget:weakSelf action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
                weakSelf.tableView.backgroundView = emptyView;
            }
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            weakSelf.tableView.mj_header = nil;
            _addressesModel = nil;
            EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.bounds.size.width, weakSelf.view.bounds.size.height)];
            emptyView.iconImageView.image = [UIImage imageNamed:@"error"];
            emptyView.textLabel.text = NSLocalizedString(@"error_refresh_failed", nil);
            [emptyView.reloadButton addTarget:weakSelf action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
            weakSelf.tableView.backgroundView = emptyView;
        }

        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _addressesModel.addresses.count ? 1: 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressesModel.addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    AccountAddressItemModel *address = [_addressesModel.addresses objectAtIndex:indexPath.row];
    AccountAddressCell *cell = (AccountAddressCell*)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountAddressCell];

    [cell setAddress:address];

    cell.isDefaultButtonClickedBlock = ^(NSInteger addressId) {
        [weakSelf setDefaultAddress:addressId];
    };

    cell.editButtonClickedBlock = ^(AccountAddressItemModel *address) {
        [weakSelf goToAddressFormVC:address];
    };

    cell.deleteButtonClickedBlock = ^(AccountAddressItemModel *address) {
        [weakSelf deleteAddress:address];
    };

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountAddressItemModel *addressModel = [_addressesModel.addresses objectAtIndex:indexPath.row];

    [self goToAddressFormVC:addressModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)setDefaultAddress:(NSInteger)addressId {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    [[Network sharedInstance] POST:[NSString stringWithFormat:@"addresses/%ld/set_default", (long)addressId] params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [weakSelf loadData];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)deleteAddress:(AccountAddressItemModel *)address {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat: NSLocalizedString(@"alert_delete_address", nil), address.address1] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_delete_address", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self requestDeleteAddressAPI:address.addressId];
    }];

    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestDeleteAddressAPI:(NSInteger)addressId {
    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] DELETE:[NSString stringWithFormat:@"addresses/%ld", (long)addressId] params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [weakSelf loadData];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)goToAddressFormVC:(AccountAddressItemModel *)address {
    if (CONFIG_ADDRESS_CHINA_FORMAT == YES) {
        AccountAddressFormViewController *nextVC = [[AccountAddressFormViewController alloc] init];
        nextVC.address = address;
        nextVC.hideSetDefaultButton = address.isDefault;
        [self.navigationController pushViewController:nextVC animated:YES];
    } else {
        AccountAddressFormInternationalViewController *nextVC = [[AccountAddressFormInternationalViewController alloc] init];
        nextVC.address = address;
        nextVC.hideSetDefaultButton = address.isDefault;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

- (void)navNewAddressButtonClicked {
    if (CONFIG_ADDRESS_CHINA_FORMAT == YES) {
        AccountAddressFormViewController *nextViewController = [AccountAddressFormViewController new];
        [self.navigationController pushViewController:nextViewController animated:YES];
    } else {
        AccountAddressFormInternationalViewController *nextViewController = [AccountAddressFormInternationalViewController new];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

@end
