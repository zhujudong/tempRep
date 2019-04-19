//
//  AccountOrderInfoViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderInfoViewController.h"

#import "AccountOrderInfoModel.h"
#import "AccountOrderInfoProductItemModel.h"
#import "AccountOrderInfoTotalItemModel.h"
#import "AccountOrderInfoHistoryItemModel.h"
#import "AccountOrderInfoShippingAddressCell.h"
#import "AccountOrderInfoProductCell.h"
#import "AccountOrderInfoSimpleCell.h"
#import "AccountOrderInfoHistoryCell.h"
#import "AccountReturnFormViewController.h"
#import "PaymentResultViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "PaymentConnectViewController.h"
#import "ProductViewController.h"

static CGFloat const CANCEL_BUTTON_HEIGHT =  40.0;
static CGFloat const CANCEL_BUTTON_WIDTH  = 100.0;
static CGFloat const ACTION_BAR_HEIGHT = 50.0;
static CGFloat const PAY_BUTTON_WIDTH = 120.0;

@interface AccountOrderInfoViewController ()
@property (strong, nonatomic) AccountOrderInfoModel *accountOrderInfoModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *actionBarView;
@property (strong, nonatomic) UIButton *cancelButton, *payButton;

@end

@implementation AccountOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_order_info_title", nil);

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    _tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    _tableView.estimatedRowHeight = 50.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [_tableView registerClass:[AccountOrderInfoShippingAddressCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderInfoShippingAddressCell];
    [_tableView registerClass:[AccountOrderInfoProductCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderInfoProductCell];
    [_tableView registerClass:[AccountOrderInfoSimpleCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderInfoSimpleCell];
    [_tableView registerClass:[AccountOrderInfoHistoryCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderInfoHistoryCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestAPI];
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:[NSString stringWithFormat:@"orders/%@", _orderId] params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            weakSelf.accountOrderInfoModel = [[AccountOrderInfoModel alloc] initWithDictionary:data error:nil];

            if (weakSelf.accountOrderInfoModel.products.count > 0) {
                [weakSelf.tableView reloadData];

                if ([weakSelf.accountOrderInfoModel.orderStatusCode isEqualToString:@"unpaid"]) {
                    [self createActionBar];
                } else {
                    [weakSelf.actionBarView removeFromSuperview];
                }
            }
        }

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

#pragma mark - Continue to pay & cancel button
- (void)createActionBar {
    if (_actionBarView == nil) {

        //bottom white background
        _actionBarView = [UIView new];
        _actionBarView.backgroundColor = [UIColor whiteColor];

        _actionBarView.layer.shadowColor = CONFIG_GENERAL_BG_COLOR.CGColor;
        _actionBarView.layer.shadowOffset = CGSizeMake(0, -0.5);
        _actionBarView.layer.shadowOpacity = 1;
        _actionBarView.layer.masksToBounds = NO;

        [self.view addSubview:_actionBarView];
        [_actionBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.and.bottom.equalTo(self.view);
            make.height.mas_equalTo(ACTION_BAR_HEIGHT);
        }];

        //Cancel button
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:NSLocalizedString(@"button_cancel_order", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1.] forState:UIControlStateNormal];

        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.];
        _cancelButton.layer.cornerRadius = 3.;
        _cancelButton.layer.borderColor = [UIColor colorWithHexString:@"7a7a7a" alpha:1.].CGColor;
        _cancelButton.layer.borderWidth = .5;
        _cancelButton.clipsToBounds = YES;
        [_cancelButton addTarget:self action:@selector(cancelOrderButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [_actionBarView addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT));
            make.leading.equalTo(_actionBarView).offset(10);
            make.centerY.equalTo(_actionBarView);
        }];

        //pay button
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:NSLocalizedString(@"button_proceed_to_pay", nil) forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:16.];
        _payButton.backgroundColor = CONFIG_PRIMARY_COLOR;
        [_payButton addTarget:self action:@selector(continueToPayButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [_actionBarView addSubview:_payButton];
        [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(PAY_BUTTON_WIDTH, ACTION_BAR_HEIGHT));
            make.top.and.trailing.equalTo(_actionBarView);
        }];
    }
}

#pragma mark - tableview protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_accountOrderInfoModel) {
        if (_accountOrderInfoModel.histories != nil) {
            return 5;
        }

        return 4;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_accountOrderInfoModel != nil) {
        switch (section) {
            case 0: // shipping address
                return 1;
                break;
            case 1: // products
                return _accountOrderInfoModel.products.count;
                break;
            case 2: // totals
                return _accountOrderInfoModel.totals.count;
                break;
            case 3: // order info
                return 4;
                break;
            case 4: // histories
                return _accountOrderInfoModel.histories.count;
                break;
            default:
                return 0;
                break;
        }
    }

    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id returnCell = nil;

    switch (indexPath.section) {
        case 0: // shipping address
            returnCell = [self createOrderInfoShippingAddrssCell:indexPath];
            break;
        case 1: // products
            returnCell = [self createOrderInfoProductCell:indexPath];
            break;
        case 2: // totals
            returnCell = [self createOrderInfoTotalCell:indexPath];
            break;
        case 3: // order info
            returnCell = [self createOrderInfoSummaryCell:indexPath];
            break;
        case 4: // histories
            returnCell = [self createOrderInfoHistoryCell:indexPath];
            break;
    }

    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        if ([_accountOrderInfoModel.orderStatusCode isEqualToString:@"unpaid"]) {
            return ACTION_BAR_HEIGHT;
        }
        return 10.;
    }

    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AccountOrderInfoProductItemModel *product = [_accountOrderInfoModel.products objectAtIndex:indexPath.row];
        ProductViewController *nextVC = [[ProductViewController alloc] init];
        nextVC.productId = product.productId;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

#pragma Create cells
- (AccountOrderInfoShippingAddressCell *)createOrderInfoShippingAddrssCell:(NSIndexPath*)indexPath {
    AccountOrderInfoShippingAddressCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderInfoShippingAddressCell forIndexPath:indexPath];

    [cell setOrder:_accountOrderInfoModel];

    return cell;
}

- (AccountOrderInfoProductCell *)createOrderInfoProductCell:(NSIndexPath*)indexPath {
    __weak typeof(self) weakSelf = self;

    AccountOrderInfoProductItemModel *product = [_accountOrderInfoModel.products objectAtIndex:indexPath.row];

    AccountOrderInfoProductCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderInfoProductCell forIndexPath:indexPath];

    [cell setProduct:product];

    if ([_accountOrderInfoModel.orderStatusCode isEqualToString:@"unpaid"] || [_accountOrderInfoModel.orderStatusCode isEqualToString:@"cancelled"]) {
        [cell setReturnButtonHidden:YES];
    } else {
        [cell setReturnButtonHidden:NO];
    }

    cell.returnButtonClickedBlock = ^(AccountOrderInfoProductItemModel *product) {
        AccountReturnFormViewController *nextVC = [AccountReturnFormViewController new];
        nextVC.orderId = weakSelf.orderId;
        nextVC.orderProductId = product.orderProductId;
        nextVC.productName = product.name;
        nextVC.quantity = product.quantity;

        [weakSelf.navigationController pushViewController:nextVC animated:YES];
    };

    return cell;
}

- (AccountOrderInfoSimpleCell *)createOrderInfoTotalCell:(NSIndexPath*)indexPath {
    AccountOrderInfoSimpleCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderInfoSimpleCell forIndexPath:indexPath];

    AccountOrderInfoTotalItemModel *total = [_accountOrderInfoModel.totals objectAtIndex:indexPath.row];

    [cell setTitle:total.title value:total.valueFormat];

    return cell;
}

- (AccountOrderInfoSimpleCell *)createOrderInfoSummaryCell:(NSIndexPath*)indexPath {
    AccountOrderInfoSimpleCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderInfoSimpleCell forIndexPath:indexPath];

    NSString *title;
    NSString *text;

    switch (indexPath.row) {
        case 0:
            title = NSLocalizedString(@"title_order_id", nil);
            text = [NSString stringWithFormat:@"#%@", _accountOrderInfoModel.orderId];
            break;
        case 1:
            title = NSLocalizedString(@"title_order_date", nil);
            text = _accountOrderInfoModel.dateAdded;
            break;
        case 2:
            title = NSLocalizedString(@"label_payment_method", nil);
            text = _accountOrderInfoModel.paymentMethod;
            break;
        case 3:
            title = NSLocalizedString(@"label_shipping_method", nil);
            text = _accountOrderInfoModel.shippingMethod;
            break;
    }

    [cell setTitle:title value:text];

    return cell;
}

- (AccountOrderInfoHistoryCell *)createOrderInfoHistoryCell:(NSIndexPath*)indexPath {
    AccountOrderInfoHistoryCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderInfoHistoryCell forIndexPath:indexPath];

    AccountOrderInfoHistoryItemModel *history = [_accountOrderInfoModel.histories objectAtIndex:indexPath.row];

    [cell setHistory:history];

    return cell;
}

#pragma mark - Continue payment
- (void)continueToPayButtonClicked {
    if ([_accountOrderInfoModel.paymentCode isEqualToString:@"wepay_app"] && [WXApi isWXAppInstalled] == NO) { // Check if Wechat installed
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error_weixin_not_installed_title", nil) message:NSLocalizedString(@"error_weixin_not_installed_message", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_ok", nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];

        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self requestContinueToPayAPI];
    }
}

- (void) requestContinueToPayAPI {
    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] POST:[NSString stringWithFormat:@"orders/%@/pay", _orderId] params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            NSDictionary *payment = [[NSDictionary alloc] initWithDictionary:data];

            if (payment == nil) {
                NSLog(@"No payment data");
                return;
            }

            NSLog(@"Payment data: %@", payment);

            // Go to payment connect VC
            [weakSelf pushToPaymentConnectVC:payment];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

#pragma mark - Cancel order
- (void)cancelOrderButtonClicked {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"alert_cancel_order", nil) preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            [alert addAction:cancelAction];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_cancel_order", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestCancelOrderAPI];
            }];
            [alert addAction:okAction];

            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}

- (void)requestCancelOrderAPI {
    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] POST:[NSString stringWithFormat:@"orders/%@/cancel", _orderId] params:@{@"id": _orderId} callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_cancel_order_success", nil)];
            [weakSelf requestAPI];
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
    nextVC.estimatedTotalFormat = _accountOrderInfoModel.totalFormat;
    nextVC.estimatedPaymentMethodName = _accountOrderInfoModel.paymentMethod;
    nextVC.paymentDict = payment;
    [self.navigationController pushViewController:nextVC animated:YES];
}
@end
