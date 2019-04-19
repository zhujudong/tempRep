//
//  PaymentResultViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 12/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "PaymentResultViewController.h"
#import "RootTabBarViewController.h"
#import "PaymentConnectViewController.h"
#import "AccountOrderInfoViewController.h"
#import "CheckoutViewController.h"
#import "RDVTabBarController.h"
#import "NavigationViewController.h"

@interface PaymentResultViewController ()
@property (strong, nonatomic) UIImageView *resultImageView;
@property (strong, nonatomic) UILabel *resultLabel, *messageLabel;
@property (strong, nonatomic) UIButton *viewOrderButton;
@property (strong, nonatomic) UIWindow *window;
@end

@implementation PaymentResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _window = [[UIApplication sharedApplication] keyWindow];
    [self initViews];
}

- (void)initViews {
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    //Top image view, success or failure
    _resultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_paymentSuccess ? @"success" : @"error"]];
    [self.view addSubview:_resultImageView];
    [_resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];

    // Result title label
    _resultLabel = [UILabel new];
    _resultLabel.font = [UIFont boldSystemFontOfSize:22.0];
    _resultLabel.textColor = CONFIG_PRIMARY_COLOR;

    if (_isOnlinePayment) {
        _resultLabel.text = NSLocalizedString(_paymentSuccess ? @"text_payment_success_title" : @"text_payment_fail_title", nil);
    } else {
        _resultLabel.text = NSLocalizedString(_paymentSuccess ? @"text_order_success_title" : @"text_order_fail_title", nil);
    }

    [self.view addSubview:_resultLabel];
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_resultImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];

    // Result message label
    _messageLabel = [UILabel new];
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
    _messageLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

    if (_isOnlinePayment) {
        _messageLabel.text = NSLocalizedString(_paymentSuccess ? @"text_payment_success_subtitle" : @"text_payment_fail_subtitle", nil);
    } else {
        _messageLabel.text = NSLocalizedString(_paymentSuccess ? @"text_order_success_subtitle" : @"text_order_fail_subtitle", nil);
    }

    _messageLabel.numberOfLines = 0;
    [self.view addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_resultLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];

    // Close button
    _viewOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _viewOrderButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    _viewOrderButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    _viewOrderButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_viewOrderButton setTitle:NSLocalizedString(@"button_close", nil) forState:UIControlStateNormal];
    [_viewOrderButton addTarget:self action:@selector(goToOrderInfoVC) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_viewOrderButton];
    [_viewOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageLabel.mas_bottom).offset(50);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    RDVTabBarController *tabBarController = (RDVTabBarController *)_window.rootViewController;

    if (!tabBarController) {
        // Select the account tab
        [tabBarController setSelectedIndex:tabBarController.tabBar.items.count - 1];
        return;
    }

    if ([self shouldPopToRootVCAndSelectAccountTab]) {
        if([[tabBarController selectedViewController] isKindOfClass:[NavigationViewController class]]) {
            [(NavigationViewController *)[tabBarController selectedViewController] popToRootViewControllerAnimated:NO];
        }
        [tabBarController setSelectedIndex:tabBarController.tabBar.items.count - 1];
    } else {
        if([[tabBarController selectedViewController] isKindOfClass:[NavigationViewController class]]) {
            [(NavigationViewController *)[tabBarController selectedViewController] popViewControllerAnimated:NO];
        }
    }
}

- (void)goToOrderInfoVC {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (BOOL)shouldPopToRootVCAndSelectAccountTab {
    RDVTabBarController *tabBarController = (RDVTabBarController *)_window.rootViewController;

    if (!tabBarController) {
        return YES;
    }

    if([[tabBarController selectedViewController] isKindOfClass:[NavigationViewController class]] == NO) {
        return YES;
    }

    NavigationViewController *currentNavController = (NavigationViewController *)[tabBarController selectedViewController];
    if ([[currentNavController.viewControllers lastObject] isKindOfClass:[PaymentConnectViewController class]] == NO) {
        return YES;
    }

    // If checkout VC is the second to last VC
    NSMutableArray *vcStack = [[NSMutableArray alloc] initWithArray: currentNavController.viewControllers];
    if ([[vcStack objectAtIndex:vcStack.count - 2] isKindOfClass:[CheckoutViewController class]]) {
        return YES;
    }

    return NO;
}

@end
