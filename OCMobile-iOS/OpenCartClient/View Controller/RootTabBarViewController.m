//
//  RootTabBarViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/25/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "NavigationViewController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "CategoryAllSidebarViewController.h"
#import "CategoryAllFlatViewController.h"
#import "CartViewController.h"
#import "AccountViewController.h"

@interface RootTabBarViewController ()
@property (strong, nonatomic) UINavigationController *homeNavController, *searchNavController, *categoryNavController, *cartNavController, *accountNavController;
@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"RootTabBarVC viewDidLoad");

    _homeNavController = [[NavigationViewController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    _searchNavController = [[NavigationViewController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    if (CONFIG_CATEGORY_ALL_STYLE == 1) {
        _categoryNavController = [[NavigationViewController alloc] initWithRootViewController:[[CategoryAllSidebarViewController alloc] init]];
    } else {
        _categoryNavController = [[NavigationViewController alloc] initWithRootViewController:[[CategoryAllFlatViewController alloc] init]];
    }
    _cartNavController = [[NavigationViewController alloc] initWithRootViewController:[[CartViewController alloc] init]];
    _accountNavController = [[NavigationViewController alloc] initWithRootViewController:[[AccountViewController alloc] init]];

    _homeNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"text_tab_home", nil) image:[UIImage imageNamed:@"tab_home"] tag:0];
    _homeNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_home_hover"];
    _searchNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"text_tab_search", nil) image:[UIImage imageNamed:@"tab_search"] tag:1];
    _searchNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_search_hover"];
    _categoryNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"text_tab_category", nil) image:[UIImage imageNamed:@"tab_category"] tag:2];
    _categoryNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_category_hover"];
    _cartNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"text_tab_cart", nil) image:[UIImage imageNamed:@"tab_cart"] tag:3];
    _cartNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_cart_hover"];
    _accountNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"text_tab_account", nil) image:[UIImage imageNamed:@"tab_account"] tag:4];
    _accountNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_account_hover"];

    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:_homeNavController];
    [tabViewControllers addObject:_searchNavController];
    [tabViewControllers addObject:_categoryNavController];
    [tabViewControllers addObject:_cartNavController];
    [tabViewControllers addObject:_accountNavController];

    [self setViewControllers:tabViewControllers];

    // Set Tab icons
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

@end
