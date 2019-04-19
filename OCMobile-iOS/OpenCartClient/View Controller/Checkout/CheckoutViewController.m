//
//  CheckoutViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CheckoutProductItemModel.h"
#import "CheckoutTotalItemModel.h"
#import "CheckoutConfirmResponseModel.h"
#import "CheckoutAddressCell.h"
#import "CheckoutAddressEmptyCell.h"
#import "CheckoutProductCell.h"
#import "CheckoutSimpleCell.h"
#import "CheckoutCommentCell.h"
#import "CheckoutTotalItemCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CheckoutShippingAddressViewController.h"
#import "CheckoutPaymentMethodViewController.h"
#import "CheckoutShippingMethodsViewController.h"
#import "CheckoutCouponViewController.h"
#import "CheckoutRewardsViewController.h"
#import "CheckoutCommentViewController.h"
#import "CheckoutPaymentWeChatModel.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
#import "LoginViewController.h"
#import "Customer.h"
#import "CheckoutVoucherViewController.h"
#import "PaymentResultViewController.h"
#import "GDUILabel.h"
#import "PaymentConnectViewController.h"

static CGFloat const CHECKOUT_BUTTON_HEIGHT = 50.0;
static CGFloat const CHECKOUT_BUTTON_WIDTH = 120.0;

typedef NS_ENUM(NSInteger, SectionIndex) {
    SectionIndexShippingAddress,
    SectionIndexProduct,
    SectionIndexShippingMethod,
    SectionIndexPaymentMethod,
    SectionIndexDiscount, //voucher/coupon/rewards/comment
    SectionIndexTotal,
};

typedef NS_ENUM(NSInteger, DiscountCellIndex) {
    DiscountCellIndexVoucher,
    DiscountCellIndexCoupon,
    DiscountCellIndexRewards,
    DiscountCellIndexComment,
};

@interface CheckoutViewController () {
}

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) GDUILabel *totalLabel;
@property(strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) NSString *orderId;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_checkout_title", nil);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100.;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    _tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, CHECKOUT_BUTTON_HEIGHT, 0));
    }];
    
    [_tableView registerClass:[CheckoutAddressEmptyCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutAddressEmptyCell];
    [_tableView registerClass:[CheckoutAddressCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutAddressCell];
    [_tableView registerClass:[CheckoutProductCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutProductCell];
    [_tableView registerClass:[CheckoutSimpleCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutSimpleCell];
    [_tableView registerClass:[CheckoutCommentCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutCommentCell];
    [_tableView registerClass:[CheckoutTotalItemCell class] forCellReuseIdentifier:kCellIdentifier_CheckoutTotalItemCell];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_confirmButton setTitle:NSLocalizedString(@"button_checkout_submit", nil) forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _confirmButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CHECKOUT_BUTTON_WIDTH);
        make.height.mas_equalTo(CHECKOUT_BUTTON_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
    
    _totalLabel = [[GDUILabel alloc] init];
    _totalLabel.paddingLeft = 10;
    _totalLabel.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    _totalLabel.font = [UIFont systemFontOfSize:17];
    _totalLabel.textColor = [UIColor colorWithHexString:@"F3F4F6" alpha:1];
    _totalLabel.text = NSLocalizedString(@"label_checkout_total_calculating", nil);
    [self.view addSubview:_totalLabel];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CHECKOUT_BUTTON_HEIGHT);
        make.leading.equalTo(self.view.mas_leading);
        make.bottom.equalTo(self.view.mas_bottom);
        make.trailing.equalTo(_confirmButton.mas_leading);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_pushedFromCart == NO) {
        [self loadData];
    } else {
        _pushedFromCart = NO;
        [self updateUI];
    }
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    
    [[Network sharedInstance] GET:@"checkout" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            weakSelf.checkout = [[CheckoutModel alloc] initWithDictionary:data error:nil];
            [weakSelf updateUI];
        }
        
        if (error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:error];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf updateUI];
        }
    }];
}

- (void)updateUI {
    if (_checkout.products.count > 0) {
        _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_checkout_bottom_total", nil), _checkout.totalFormat];
    } else {
        _totalLabel.text = @"";
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_checkout.products.count) {
        return 0;
    }
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_checkout.products.count) {
        return 0;
    }

    switch (section) {
        case SectionIndexShippingAddress:
            return 1;
        case SectionIndexProduct:
            return _checkout.products.count;
        case SectionIndexShippingMethod:
            return 1;
        case SectionIndexPaymentMethod:
            return 1;
        case SectionIndexDiscount:
            return 4;
        case SectionIndexTotal:
            return _checkout.totals.count;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;

    if (section == SectionIndexShippingAddress) {
        if (_checkout.addressId  > 0) { // Has address
            return [self createCheckoutAddressCell:indexPath];
        }

        // No address
        return [self createCheckoutAddressEmptyCell:indexPath];
    }

    if (section == SectionIndexProduct) {
        return [self createCheckoutProductCell:indexPath];
    }

    if (section == SectionIndexShippingMethod) {
        return [self createShippingMethodCell:indexPath];
    }

    if (section == SectionIndexPaymentMethod) {
        return [self createPaymentMethodCell:indexPath];
    }

    if (section == SectionIndexDiscount) {
        NSInteger row = indexPath.row;

        if (row == DiscountCellIndexCoupon) {
            return [self createDiscountCell:indexPath title:NSLocalizedString(@"label_coupon", nil) text:_checkout.coupon.length ? NSLocalizedString(@"label_used_yes", nil) : NSLocalizedString(@"label_used_no", nil)];
        }

        if (row == DiscountCellIndexVoucher) {
            return [self createDiscountCell:indexPath title:NSLocalizedString(@"label_voucher", nil) text:_checkout.voucher.length ? NSLocalizedString(@"label_used_yes", nil) : NSLocalizedString(@"label_used_no", nil)];
        }

        if (row == DiscountCellIndexRewards) {
            return [self createDiscountCell:indexPath title:NSLocalizedString(@"label_rewards", nil) text:_checkout.reward > 0 ? [NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"label_used_yes", nil), (long)_checkout.reward] : NSLocalizedString(@"label_used_no", nil)];
        }

        if (row == DiscountCellIndexComment) {
            CheckoutCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutCommentCell forIndexPath:indexPath];
            cell.comment = _checkout.comment;
            return cell;
        }
    }

    if (section == SectionIndexTotal) {
        return [self createTotalCell:indexPath title:@"" text:@""];
    }

    return nil;
}

- (CheckoutAddressEmptyCell *)createCheckoutAddressEmptyCell:(NSIndexPath *)indexPath {
    CheckoutAddressEmptyCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutAddressEmptyCell forIndexPath:indexPath];
    return cell;
}

- (CheckoutAddressCell*)createCheckoutAddressCell:(NSIndexPath*) indexPath {
    CheckoutAddressCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutAddressCell forIndexPath:indexPath];
    [cell setAddress:_checkout.address];
    return cell;
}

- (CheckoutProductCell*)createCheckoutProductCell:(NSIndexPath*) indexPath {
    CheckoutProductCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutProductCell forIndexPath:indexPath];
    CheckoutProductItemModel *product = [_checkout.products objectAtIndex:indexPath.row];
    [cell setProduct:product];
    return cell;
}

- (CheckoutSimpleCell*)createShippingMethodCell:(NSIndexPath*) indexPath {
    CheckoutSimpleCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutSimpleCell forIndexPath:indexPath];
    [cell setTitle:NSLocalizedString(@"label_shipping_method", nil) value:_checkout.shippingMethodName];
    return cell;
}

- (CheckoutSimpleCell*)createPaymentMethodCell:(NSIndexPath*) indexPath {
    CheckoutSimpleCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutSimpleCell forIndexPath:indexPath];
    [cell setTitle:NSLocalizedString(@"label_payment_method", nil) value:_checkout.paymentMethodName];
    return cell;
}

- (CheckoutSimpleCell*)createDiscountCell:(NSIndexPath*) indexPath title:(NSString*)title text:(NSString*)text {
    CheckoutSimpleCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutSimpleCell forIndexPath:indexPath];
    [cell setTitle:title value:text];
    return cell;
}

- (CheckoutTotalItemCell *)createTotalCell:(NSIndexPath*) indexPath title:(NSString*)title text:(NSString*)text {
    CheckoutTotalItemCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CheckoutTotalItemCell forIndexPath:indexPath];
    CheckoutTotalItemModel *total = [_checkout.totals objectAtIndex:indexPath.row];
    [cell setTotal:total];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;

    if (section == SectionIndexShippingAddress) {
        CheckoutShippingAddressViewController *nextVC = [[CheckoutShippingAddressViewController alloc] init];
        nextVC.selectedAddressId = _checkout.addressId;
        [self.navigationController pushViewController:nextVC animated:YES];
        return;
    }

    if (_checkout.addressId < 1) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"error_no_address", nil)];
        return;
    }

    if (section == SectionIndexShippingMethod) {
        CheckoutShippingMethodsViewController *nextVC = [[CheckoutShippingMethodsViewController alloc] init];
        nextVC.currentShippingMethodCode = _checkout.shipping;
        nextVC.shippingMethods = _checkout.shippingMethods;
        [self.navigationController pushViewController:nextVC animated:YES];
        return;
    }

    if (section == SectionIndexPaymentMethod) {
        CheckoutPaymentMethodViewController *nextVC = [[CheckoutPaymentMethodViewController alloc] init];
        nextVC.currentPaymentMethodCode = _checkout.payment;
        nextVC.paymentMethods = _checkout.paymentMethods;
        [self.navigationController pushViewController:nextVC animated:YES];
    }

    if (section == SectionIndexDiscount) {
        NSInteger row = indexPath.row;

        if (row == DiscountCellIndexCoupon) {
            CheckoutCouponViewController *nextVC = [[CheckoutCouponViewController alloc] init];
            nextVC.currentCouponCode = _checkout.coupon;
            nextVC.coupons = _checkout.validCoupons;
            [self.navigationController pushViewController:nextVC animated:YES];
            return;
        }

        if (row == DiscountCellIndexVoucher) {
            CheckoutVoucherViewController *nextVC = [[CheckoutVoucherViewController alloc] init];
            nextVC.currentVoucherCode = _checkout.voucher;
            [self.navigationController pushViewController:nextVC animated:YES];
            return;
        }

        if (row == DiscountCellIndexRewards) {
            CheckoutRewardsViewController *nextVC = [[CheckoutRewardsViewController alloc] init];
            nextVC.currentPoints = _checkout.reward;
            nextVC.maxPoints = _checkout.validRewardsMax;
            nextVC.totalPoints = _checkout.validRewardsTotal;
            [self.navigationController pushViewController:nextVC animated:YES];
            return;
        }

        if (row == DiscountCellIndexComment) {
            CheckoutCommentViewController *nextVC = [[CheckoutCommentViewController alloc] init];
            nextVC.comment = _checkout.comment;
            [self.navigationController pushViewController:nextVC animated:YES];
            return;
        }
    }
}

- (void)confirmButtonClicked {
    if (_checkout.addressId < 1) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"error_no_address", nil)];
        return;
    }
    
    if (_checkout.shipping.length < 1) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"error_no_shipping_method", nil)];
        return;
    }
    
    if (_checkout.payment == PaymentGatewayTypeUnknown) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"error_no_payment_method", nil)];
        return;
    }
    
    // Check if wechat installed, or cannot use wechat to pay.
    if (_checkout.payment == PaymentGatewayTypeWechat && ![WXApi isWXAppInstalled]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error_weixin_not_installed_title", nil) message:NSLocalizedString(@"error_weixin_not_installed_message", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_ok", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // Cannot use Paypal for CNY
    if (_checkout.payment == PaymentGatewayTypePaypal && [[[System sharedInstance] currencyCode] isEqualToString:@"CNY"]) {
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
    
    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [[Network sharedInstance] POST:@"checkout/confirm" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *payment = [[NSDictionary alloc] initWithDictionary:data];
            
            if (payment == nil) {
                NSLog(@"No payment data");
                return;
            }
            
            NSLog(@"Payment params: %@", payment);
            
            // Go to payment connect VC
            [weakSelf pushToPaymentConnectVC:payment];
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

#pragma mark - Go to payment connector VC
- (void)pushToPaymentConnectVC:(NSDictionary *)payment {
    PaymentConnectViewController *nextVC = [[PaymentConnectViewController alloc] init];
    nextVC.isNewOrder = YES;
    nextVC.estimatedTotalFormat = _checkout.totalFormat;
    nextVC.estimatedPaymentMethodName = _checkout.paymentMethodName;
    nextVC.paymentDict = payment;
    [self.navigationController pushViewController:nextVC animated:YES];
}
@end
