//
//  CheckoutShippingAddressViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutShippingAddressViewController.h"
#import "ShippingAddressItemCell.h"
#import "EmptyView.h"
#import "AccountAddressFormViewController.h"
#import "AccountAddressListModel.h"
#import "AccountAddressItemModel.h"
#import "LoginViewController.h"
#import "AccountAddressFormInternationalViewController.h"

@interface CheckoutShippingAddressViewController () {
    BOOL showHUD;
    AccountAddressListModel *addressesModel;
    NSIndexPath *currentAddressIndexPath;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation CheckoutShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showHUD = YES;
    
    self.title = NSLocalizedString(@"text_checkout_shipping_address_title", nil);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100.;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    _tableView.separatorColor = CONFIG_DEFAULT_SEPARATOR_LINE_COLOR;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_tableView registerClass:[ShippingAddressItemCell class] forCellReuseIdentifier:kCellIdentifier_ShippingAddressItemCell];
    
    UIBarButtonItem *navNewAddressButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_checkout_shipping_address_new", nil) style:UIBarButtonItemStylePlain target:self action:@selector(navNewAddressButtonClicked)];
    self.navigationItem.rightBarButtonItem = navNewAddressButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestAPI];
}

- (void)requestAPI {
    _tableView.backgroundView = nil;
    
    if (showHUD) {
        showHUD = NO;
        [MBProgressHUD showLoadingHUDToView:self.view];
    }
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"addresses" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            addressesModel = [[AccountAddressListModel alloc] initWithDictionary:data error:nil];
            
            if (addressesModel.addresses.count > 0) {
                [weakSelf.tableView reloadData];
            } else {
                EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
                emptyView.iconImageView.image = [UIImage imageNamed:@"empty_address"];
                emptyView.textLabel.text = NSLocalizedString(@"empty_no_address", nil);
                [emptyView.reloadButton addTarget:weakSelf action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];
                weakSelf.tableView.backgroundView = emptyView;
            }
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addressesModel.addresses.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    ShippingAddressItemCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ShippingAddressItemCell forIndexPath:indexPath];
    
    AccountAddressItemModel *address = [addressesModel.addresses objectAtIndex:indexPath.row];
    
    [cell setAddress:address];
    
    if (address.addressId == weakSelf.selectedAddressId) {
        [cell setCheckImageHighlighted:YES];
        currentAddressIndexPath = indexPath;
    } else {
        [cell setCheckImageHighlighted:NO];
    }
    
    cell.editButtonClickedBlock = ^(AccountAddressItemModel *address) {
        [weakSelf goToEditAddressViewController:address];
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self requestChangeShippingAddressAPI:indexPath];
}

- (void)requestChangeShippingAddressAPI:(NSIndexPath *)indexPath {
    [MBProgressHUD showLoadingHUDToView:self.view];
    ShippingAddressItemCell *prevCheckedCell = (ShippingAddressItemCell *)[self.tableView cellForRowAtIndexPath:currentAddressIndexPath];
    
    [prevCheckedCell setCheckImageHighlighted:NO];
    
    ShippingAddressItemCell *currentCheckedCell = (ShippingAddressItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [currentCheckedCell setCheckImageHighlighted:YES];
    
    AccountAddressItemModel *address = [addressesModel.addresses objectAtIndex:indexPath.row];
    
    NSDictionary *params = @{@"type": @"address",
                             @"value": [NSNumber numberWithInteger:address.addressId]};
    
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] PUT:@"checkout" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"message_shipping_address_changed", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            
            ShippingAddressItemCell *prevCheckedCell = (ShippingAddressItemCell *)[weakSelf.tableView cellForRowAtIndexPath:currentAddressIndexPath];
            [prevCheckedCell setCheckImageHighlighted:YES];
            
            ShippingAddressItemCell *currentCheckedCell = (ShippingAddressItemCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [currentCheckedCell setCheckImageHighlighted:NO];
        }
    }];
}

- (void)navNewAddressButtonClicked {
    if (CONFIG_ADDRESS_CHINA_FORMAT == YES) {
        AccountAddressFormViewController *nextVC = [AccountAddressFormViewController new];
        [self.navigationController pushViewController:nextVC animated:YES];
    } else {
        AccountAddressFormInternationalViewController *nextVC = [AccountAddressFormInternationalViewController new];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

- (void)goToEditAddressViewController:(AccountAddressItemModel *)address  {
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
@end
