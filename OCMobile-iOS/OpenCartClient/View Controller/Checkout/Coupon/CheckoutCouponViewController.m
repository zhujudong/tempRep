//
//  CheckoutCouponViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutCouponViewController.h"
#import "CheckoutCouponItemCell.h"
#import "LoginViewController.h"
#import "EmptyView.h"

@interface CheckoutCouponViewController () {
    NSIndexPath *currentIndexPath;
}

@end

@implementation CheckoutCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_checkout_coupon_title", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 90.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[CheckoutCouponItemCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutCouponItemCell];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_coupons.count <= 0) {
        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        emptyView.textLabel.text = NSLocalizedString(@"empty_coupon", nil);
        emptyView.iconImageView.image = [UIImage imageNamed:@"error"];
        emptyView.reloadButton.hidden = YES;
        
        self.tableView.backgroundView = emptyView;
    } else {
        self.tableView.backgroundView = nil;
    }
    
    return _coupons.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckoutCouponItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutCouponItemCell forIndexPath:indexPath];
    
    CheckoutCouponModel *coupon = [_coupons objectAtIndex:indexPath.row];
    [cell setCoupon:coupon];
    
    if ([coupon.code isEqualToString:_currentCouponCode]) {
        currentIndexPath = indexPath;
        [cell setImageHighlighted:YES];
    } else {
        [cell setImageHighlighted:NO];
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
    [self requestChangeCouponAPI:indexPath];
}

- (void)requestChangeCouponAPI:(NSIndexPath *)indexPath {
    [MBProgressHUD showLoadingHUDToView:self.view];
    CheckoutCouponItemCell *prevCheckedCell = (CheckoutCouponItemCell *)[self.tableView cellForRowAtIndexPath:currentIndexPath];
    [prevCheckedCell setImageHighlighted:NO];
    
    CheckoutCouponItemCell *currentCheckedCell = (CheckoutCouponItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [currentCheckedCell setImageHighlighted:YES];
    
    CheckoutCouponModel *coupon = [_coupons objectAtIndex:indexPath.row];
    NSDictionary *params = @{@"type": @"coupon",
                             @"value": coupon.code};
    __weak typeof(self) weakSelf = self;
    
    [[Network sharedInstance] PUT:@"checkout" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_coupon_changed", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            
            CheckoutCouponItemCell *prevCheckedCell = (CheckoutCouponItemCell *)[weakSelf.tableView cellForRowAtIndexPath:currentIndexPath];
            [prevCheckedCell setImageHighlighted:YES];
            
            CheckoutCouponItemCell *currentCheckedCell = (CheckoutCouponItemCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [currentCheckedCell setImageHighlighted:NO];
        }
    }];
}

@end
