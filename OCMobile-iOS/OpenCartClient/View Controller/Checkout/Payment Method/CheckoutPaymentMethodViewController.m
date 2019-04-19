//
//  CheckoutPaymentMethodViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutPaymentMethodViewController.h"
#import "CheckoutPaymentMethodCell.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"

@interface CheckoutPaymentMethodViewController () {
    NSIndexPath *currentIndexPath;
}
@end

@implementation CheckoutPaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_checkout_payment_method_title", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[CheckoutPaymentMethodCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutPaymentMethodCell];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)loadData {
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _paymentMethods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckoutPaymentMethodCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutPaymentMethodCell forIndexPath:indexPath];
    
    CheckoutPaymentMethodModel *paymentMethod = [_paymentMethods objectAtIndex:indexPath.row];
    
    [cell setPaymentMethod:paymentMethod];
    
    if (paymentMethod.code == _currentPaymentMethodCode) {
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
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckoutPaymentMethodModel *paymentMethod = [_paymentMethods objectAtIndex:indexPath.row];
    
    //Detect if Wechat installed, or cannot use weichat pay.
    if (paymentMethod.code == PaymentGatewayTypeWechat && ![WXApi isWXAppInstalled]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error_weixin_not_installed_title", nil) message:NSLocalizedString(@"error_weixin_not_installed_message", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_ok", nil) style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        });
        
        return;
    }
    
    if (paymentMethod.code == PaymentGatewayTypePaypal && [[[System sharedInstance] currencyCode] isEqualToString:@"CNY"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error_paypal_no_rmb_title", nil) message:NSLocalizedString(@"error_paypal_no_rmb_message", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_ok", nil) style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        });
        
        return;
    }
    
    [self requestChangePaymentMethodAPI:indexPath];
}

- (void)requestChangePaymentMethodAPI:(NSIndexPath *)indexPath {
    [MBProgressHUD showLoadingHUDToView:self.view];
    CheckoutPaymentMethodCell *prevCheckedCell = (CheckoutPaymentMethodCell*)[self.tableView cellForRowAtIndexPath:currentIndexPath];
    [prevCheckedCell setCheckImageHighlighted:NO];
    
    CheckoutPaymentMethodCell *currentCheckedCell = (CheckoutPaymentMethodCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [currentCheckedCell setCheckImageHighlighted:YES];
    
    CheckoutPaymentMethodModel *paymentMethod = [_paymentMethods objectAtIndex:indexPath.row];
    
    NSDictionary *params = @{@"type": @"payment",
                             @"value": [PaymentGateWay convertToNSString:paymentMethod.code]};
    __weak typeof(self) weakSelf = self;
    
    [[Network sharedInstance] PUT:@"checkout" params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_payment_method_changed", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            
            CheckoutPaymentMethodCell *prevCheckedCell = (CheckoutPaymentMethodCell*)[weakSelf.tableView cellForRowAtIndexPath:currentIndexPath];
            [prevCheckedCell setCheckImageHighlighted:YES];
            
            CheckoutPaymentMethodCell *currentCheckedCell = (CheckoutPaymentMethodCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [currentCheckedCell setCheckImageHighlighted:NO];
        }
    }];
}

@end
