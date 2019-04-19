//
//  NavigationViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/19/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self childViewControllerForStatusBarStyle].preferredStatusBarStyle;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
@end
