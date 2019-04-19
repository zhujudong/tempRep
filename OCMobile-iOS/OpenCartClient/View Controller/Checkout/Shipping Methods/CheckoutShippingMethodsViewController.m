//
//  CheckoutShippingMethodsViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutShippingMethodsViewController.h"
#import "CheckoutShippingMethodCell.h"
#import "LoginViewController.h"

@interface CheckoutShippingMethodsViewController () {
    NSIndexPath *currentIndexPath;
}

@end

@implementation CheckoutShippingMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_checkout_shipping_method_title", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[CheckoutShippingMethodCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutShippingMethodCell];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

-(void)loadData {
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shippingMethods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckoutShippingMethodCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutShippingMethodCell forIndexPath:indexPath];
    
    CheckoutShippingMethodModel *shippingMethod = [_shippingMethods objectAtIndex:indexPath.row];
    
    [cell setShippingMethod:shippingMethod];
    
    if ([shippingMethod.code isEqualToString:_currentShippingMethodCode]) {
        currentIndexPath = indexPath;
        [cell setCheckImageHighlighted:YES];
    } else {
        [cell setCheckImageHighlighted:NO];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self requestChangeShippingMethodAPI:indexPath];
}

- (void)requestChangeShippingMethodAPI:(NSIndexPath *)indexPath {
    [MBProgressHUD showLoadingHUDToView:self.view];
    CheckoutShippingMethodCell *prevCheckedCell = (CheckoutShippingMethodCell*)[self.tableView cellForRowAtIndexPath:currentIndexPath];
    [prevCheckedCell setCheckImageHighlighted:NO];
    
    CheckoutShippingMethodCell *currentCheckedCell = (CheckoutShippingMethodCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [currentCheckedCell setCheckImageHighlighted:YES];
    
    
    CheckoutShippingMethodModel *shippingMethod = [_shippingMethods objectAtIndex:indexPath.row];
    
    NSDictionary *params = @{@"type": @"shipping",
                             @"value": shippingMethod.code};
    __weak typeof(self) weakSelf = self;
    
    [[Network sharedInstance] PUT:@"checkout" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_shipping_method_changed", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            
            CheckoutShippingMethodCell *prevCheckedCell = (CheckoutShippingMethodCell*)[weakSelf.tableView cellForRowAtIndexPath:currentIndexPath];
            [prevCheckedCell setCheckImageHighlighted:YES];
            
            CheckoutShippingMethodCell *currentCheckedCell = (CheckoutShippingMethodCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [currentCheckedCell setCheckImageHighlighted:NO];
        }
    }];
}
@end
