//
//  PaymentConnectViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 11/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "PaymentConnectViewController.h"
#import "CheckoutPaymentWeChatModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WechatAuthSDK.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "PayPalMobile.h"
#import "PaymentResultViewController.h"
#import "AlipayPaymentResultHandler.h"
#import "StripePaymentViewController.h"
#import "PaymentParamStripeModel.h"
#import "BankTransferModalView.h"
#import "PaymentGateway.h"

@interface PaymentConnectViewController ()<PayPalPaymentDelegate, StripePaymentDelegate>
@property (strong, nonatomic) NSString *orderId;
@property (nonatomic) PaymentGatewayType paymentCode;
@property (strong, nonatomic, readwrite) PayPalConfiguration *payPalConfiguration;

@property (strong, nonatomic) UILabel *orderTotalLabel;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIView *sepLine;
@property (strong, nonatomic) UILabel *orderIdLabel;
@property (strong, nonatomic) UILabel *paymentTypeLabel;
@property (strong, nonatomic) UILabel *progresslabel;
@property (strong, nonatomic) UIButton *tryAgainButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (nonatomic) BOOL success;
@property (nonatomic) BOOL isOnlinePayment;
@end

@implementation PaymentConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"text_payment_connect_title", nil);

    self.navigationItem.hidesBackButton = YES;

    self.isOnlinePayment = YES;

    if (!_paymentDict) {
        [self presentPaymentResultVC];
    }

    _paymentCode = [PaymentGateWay convertFromNSString:[_paymentDict objectForKey:@"payment_code"]];
    _orderId = [_paymentDict objectForKey:@"order_id"];

    [self createView];

    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dispatchPaymentHandlerByCode) userInfo:nil repeats:NO];
}

- (void)createView {
    _orderTotalLabel = [[UILabel alloc] init];

    if ([_paymentDict objectForKey:@"total_format"]) {
        _orderTotalLabel.text = [_paymentDict objectForKey:@"total_format"];
    } else {
        _orderTotalLabel.text = _estimatedTotalFormat;
    }

    _orderTotalLabel.font = [UIFont boldSystemFontOfSize:40];
    _orderTotalLabel.textColor = CONFIG_PRIMARY_COLOR;
    [self.view addSubview:_orderTotalLabel];
    [_orderTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.centerX.equalTo(self.view);
    }];

    _textLabel = [[UILabel alloc] init];
    _textLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
    _textLabel.font = [UIFont boldSystemFontOfSize:13];
    _textLabel.text = NSLocalizedString(@"label_payment_connect_total", nil);
    [self.view addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_orderTotalLabel.mas_bottom).offset(0);
    }];

    _sepLine = [[UIView alloc] init];
    _sepLine.backgroundColor = CONFIG_DEFAULT_SEPARATOR_LINE_COLOR;
    [self.view addSubview:_sepLine];
    [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textLabel.mas_bottom).offset(50);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(0.5);
    }];

    _orderIdLabel = [[UILabel alloc] init];
    _orderIdLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_payment_connect_order_id", nil), _orderId];
    _orderIdLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
    _orderIdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_orderIdLabel];
    [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sepLine.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];

    _paymentTypeLabel = [[UILabel alloc] init];
    if ([_paymentDict objectForKey:@"payment_method"]) {
        _paymentTypeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_payment_connect_payment_method", nil), [_paymentDict objectForKey:@"payment_method"]];
    } else {
        _paymentTypeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_payment_connect_payment_method", nil), _estimatedPaymentMethodName];
    }

    _paymentTypeLabel.textColor = _orderIdLabel.textColor;
    _paymentTypeLabel.font = _orderIdLabel.font;
    [self.view addSubview:_paymentTypeLabel];
    [_paymentTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderIdLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];

    _progresslabel = [[UILabel alloc] init];
    _progresslabel.text = NSLocalizedString(@"label_payment_connect_prepare", nil);
    _progresslabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
    _progresslabel.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:_progresslabel];
    [_progresslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_paymentTypeLabel.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
    }];

    _tryAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tryAgainButton setTitle:NSLocalizedString(@"button_payment_connect_try_again", nil) forState:UIControlStateNormal];
    _tryAgainButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    _tryAgainButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _tryAgainButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    [_tryAgainButton addTarget:self action:@selector(tryAgainButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_tryAgainButton setHidden:YES];
    [self.view addSubview:_tryAgainButton];

    [_tryAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progresslabel.mas_bottom).offset(30);
        make.height.equalTo(@44);
        make.trailing.equalTo(self.view).offset(-30);
        make.leading.equalTo(self.view).offset(30);
    }];

    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:NSLocalizedString(@"button_payment_connect_cancel", nil) forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = _tryAgainButton.titleLabel.font;
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setHidden:YES];
    [self.view addSubview:_cancelButton];

    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tryAgainButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
}

- (void)showActionButtonGroup {
    [_tryAgainButton setHidden:NO];
    [_cancelButton setHidden:NO];
    [_progresslabel setHidden:YES];
}

- (void)hideActionButtonGroup {
    [_tryAgainButton setHidden:YES];
    [_cancelButton setHidden:YES];
}

#pragma mark - Dispatch payment method handle by code
- (void)dispatchPaymentHandlerByCode {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if (_paymentCode == PaymentGatewayTypeAlipay) {
        [self handleAlipay];
    } else if (_paymentCode == PaymentGatewayTypeWechat) {
        [self handleWechat];
    } else if (_paymentCode == PaymentGatewayTypePaypal) {
        [self handlePaypal];
    } else if (_paymentCode == PaymentGatewayTypeStripe) {
        [self handleStripe];
    } else if (_paymentCode == PaymentGatewayTypeCOD) { // Cash on delivery, no payment gateway. Direct callback
        _isOnlinePayment = NO;
        [self handleDirectConfirm];
    } else if (_paymentCode == PaymentGatewayTypeBankTransfer) {
        _isOnlinePayment = NO;
        [self handleBankTransfer];
    } else if (_paymentCode == PaymentGatewayTypeFreeCheckout) { // Free checkout, no payment gateway. Direct callback
        [self handleDirectConfirm];
    } else {
        // No payment, ask to upgrade App
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_payment_connect_upgrade", nil) callback:^{
            [self showActionButtonGroup];
        }];
    }
}

#pragma mark - Alipay: alipay_app
- (void)handleAlipay {
    [self showActionButtonGroup];
    NSDictionary *paymentParams = [[NSDictionary alloc] initWithDictionary: (NSDictionary *)[_paymentDict objectForKey:@"payment_params"]];

    NSString *appScheme = CONFIG_ALIPAY_SDK_SCHEME;
    NSString *params = [paymentParams objectForKey:@"params_string"];
    [[AlipaySDK defaultService] payOrder:params fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        // 如果客户没有安装支付宝 APP，将使用网页进行支付，并会回调以下代码。安装 APP 的回调将在 AppDelegate 中处理
        AlipayPaymentResultHandler *alipayResultHandler = [[AlipayPaymentResultHandler alloc] init];
        [alipayResultHandler processResult:resultDic];
    }];
}

#pragma mark - Wechat: wechat_app
- (void)handleWechat {
    [self showActionButtonGroup];

    CheckoutPaymentWeChatModel *wechatModel = [[CheckoutPaymentWeChatModel alloc] initWithDictionary:[_paymentDict objectForKey:@"payment_params"] error:nil];

    if (wechatModel != nil) {
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = wechatModel.partnerId;
        req.prepayId = wechatModel.prepayId;
        req.package = wechatModel.package;
        req.nonceStr = wechatModel.nonceStr;
        req.timeStamp = wechatModel.timestamp;
        req.sign = wechatModel.sign;

        [WXApi sendReq:req];
    }
}

#pragma mark - Paypal: paypal_express
- (void)handlePaypal {
    [self showActionButtonGroup];

    NSDictionary *paymentParams = [[NSDictionary alloc] initWithDictionary:[_paymentDict objectForKey:@"payment_params"]];

    // Paypal does not support CNY
    if ([[paymentParams objectForKey:@"currency"] isEqualToString:@"CNY"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error_paypal_no_rmb_title", nil) message:NSLocalizedString(@"error_paypal_no_rmb_message", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    _success = NO;
                    [self presentPaymentResultVC];
                }];

                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        });

        return;
    }

    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.acceptCreditCards = NO;
    //_payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    [PayPalMobile preconnectWithEnvironment:CONFIG_PAYPAL_SANDBOX_MODE ? PayPalEnvironmentSandbox : PayPalEnvironmentProduction];

    PayPalPayment *paypalPayment = [[PayPalPayment alloc] init];
    paypalPayment.amount = [[NSDecimalNumber alloc] initWithString:[paymentParams objectForKey:@"total"]];
    paypalPayment.currencyCode = [paymentParams objectForKey:@"currency"];
    paypalPayment.shortDescription = [paymentParams objectForKey:@"subject"];
    paypalPayment.intent = PayPalPaymentIntentSale;

    if (paypalPayment.processable) {
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:paypalPayment configuration:self.payPalConfiguration delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}

#pragma mark - Bank Transfer
- (void)handleBankTransfer {
    __weak typeof(self) weakSelf = self;
    BankTransferModalView *bankTransferModalView = [[BankTransferModalView alloc] initWithFrame:self.view.bounds];
    NSDictionary *paymentParams = [_paymentDict objectForKey:@"payment_params"];
    bankTransferModalView.bankTransferInfo = [paymentParams objectForKey:@"bank"];
    [self.view addSubview:bankTransferModalView];
    [bankTransferModalView show];
    bankTransferModalView.submitButtonClickedBlock = ^{
        [weakSelf handleDirectConfirm];
    };
}

#pragma mark - Cash on Delivery / Free Checkout: cod / free_checkout
- (void)handleDirectConfirm {
    [MBProgressHUD showLoadingHUDToView:self.view];
    _orderId = [_paymentDict objectForKey:@"order_id"];
    __weak typeof(self) weakSelf = self;

    NSString *paymentCodeString = [PaymentGateWay convertToNSString:_paymentCode];
    [[Network sharedInstance] POST:[NSString stringWithFormat:@"orders/%@/%@_confirm", _orderId, paymentCodeString] params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        if (data) {
            NSLog(@"%@ callback success.", paymentCodeString);
            weakSelf.success = YES;
            [weakSelf presentPaymentResultVC];
        }

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            [weakSelf showActionButtonGroup];

            NSLog(@"%@ callback failed.", paymentCodeString);
        }
    }];
}

#pragma mark - Stripe
- (void)handleStripe {
    [self showActionButtonGroup];

    PaymentParamStripeModel *stripe = [[PaymentParamStripeModel alloc] initWithDictionary:[_paymentDict objectForKey:@"payment_params"] error:nil];
    if (!stripe) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_stripe_param_error", nil)];
        return;
    }

    StripePaymentViewController *stripePaymentVC = [[StripePaymentViewController alloc] init];
    stripePaymentVC.delegate = self;
    stripePaymentVC.stripe = stripe;
    stripePaymentVC.orderId = _orderId;
    [self.navigationController presentViewController:stripePaymentVC animated:YES completion:nil];
}

#pragma mark - Button actions
- (void)tryAgainButtonClicked {
    [self dispatchPaymentHandlerByCode];
}

- (void)cancelButtonClicked {
    if (_isNewOrder) { // New order will present payment fail page
        _success = NO;
        [self presentPaymentResultVC];
    } else { // Continue to pay order will just pop VC
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Present payment result VC
- (void)presentPaymentResultVC {
    PaymentResultViewController *resultVC = [[PaymentResultViewController alloc] init];
    resultVC.isOnlinePayment = _isOnlinePayment;
    resultVC.paymentSuccess = _success;
    [self presentViewController:resultVC animated:YES completion:nil];
}

#pragma mark - Paypal delegate
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    [self dismissViewControllerAnimated:YES completion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showLoadingHUDToView:self.view];

        NSDictionary *confirmation = [[NSDictionary alloc] initWithDictionary:completedPayment.confirmation];

        NSDictionary *params = @{@"order_id": _orderId,
                                 @"payment_id": [[confirmation objectForKey:@"response"] objectForKey:@"id"],
                                 };
        __weak typeof(self) weakSelf = self;

        [[Network sharedInstance] POST:@"callbacks/paypal" params:params callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                NSLog(@"Paypal callback success.");
                weakSelf.success = YES;
                [weakSelf presentPaymentResultVC];
            }

            if (error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    }];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        self.success = NO;
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_payment_connect_cancel", nil)];
    }];
}

#pragma mark - Stripe delegate
- (void)stripePaymentFinished:(BOOL)success {
    [self dismissViewControllerAnimated:YES completion:^{
        if (success) {
            self.success = YES;
            [self presentPaymentResultVC];
        } else {
            [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_payment_connect_cancel", nil)];
        }
    }];
}
@end
