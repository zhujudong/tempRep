//
//  PaymentResultHandler.m
//  OpenCartClient
//
//  Created by Sam Chen on 13/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "PaymentResultHandler.h"
#import "RootTabBarViewController.h"
#import "PaymentConnectViewController.h"
#import "RDVTabBarController.h"
#import "NavigationViewController.h"

@interface PaymentResultHandler()

@end

@implementation PaymentResultHandler

- (void)presentPaymentResultVCIfNeeded {
    PaymentConnectViewController *paymentConnectVC = [self paymentConnectVCOrNull];

    // PaymentConnectVC is not visible, should immediately show result VC.
    if (!paymentConnectVC) {
        PaymentResultViewController *resultVC = [[PaymentResultViewController alloc] init];
        resultVC.paymentSuccess = self.success;

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:resultVC animated:YES completion:nil];
        return;
    }

    // PaymentConnectVC is visible, but the payment had failed.
    if (self.success == NO) {
        [MBProgressHUD showToastToView:[UIApplication sharedApplication].keyWindow.rootViewController.view withMessage:self.message];
        return;
    } else {
        PaymentResultViewController *resultVC = [[PaymentResultViewController alloc] init];
        resultVC.paymentSuccess = self.success;

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:resultVC animated:YES completion:nil];
    }
}

- (PaymentConnectViewController *)paymentConnectVCOrNull {
    RDVTabBarController *tabBarController = (RDVTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (tabBarController) {
        if([[tabBarController selectedViewController] isKindOfClass:[NavigationViewController class]]) {
            NavigationViewController *currentNavController = (NavigationViewController *)[tabBarController selectedViewController];
            if ([[currentNavController.viewControllers lastObject] isKindOfClass:[PaymentConnectViewController class]]) {
                return (PaymentConnectViewController *)[currentNavController.viewControllers lastObject];
            }
        }
    }

    return nil;
}

@end
