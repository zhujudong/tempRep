//
//  BaseViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 27/06/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "AnalyticsManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    //Hide back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSString *vcName;
    if (self.title) {
        vcName = [NSString stringWithFormat:@"%@: %@", NSStringFromClass([self class]), self.title];
    } else {
        vcName = [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
    }

    [[AnalyticsManager sharedManager] trackVCStart:vcName];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString *vcName;
    if (self.title) {
        vcName = [NSString stringWithFormat:@"%@: %@", NSStringFromClass([self class]), self.title];
    } else {
        vcName = [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
    }

    [[AnalyticsManager sharedManager] trackVCEnd:vcName];
}

- (void)showLoginVC {
    [((AppDelegate *)[UIApplication sharedApplication].delegate) presentLoginViewController];
}

- (void)showToastMessageOnCurrentView:(NSString *)message {
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showToastToView:self.view withMessage:message];
}

- (void)dealloc {
    NSLog(@"%@ dealloc.", self.description);
}
@end
