//
//  WebViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 9/15/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "WebViewController.h"
#import "GDRefreshNormalHeader.h"
#import "CategoryViewController.h"
#import "ProductViewController.h"
#import "CartViewController.h"
#import "RDVTabBarController.h"

@interface WebViewController ()
@end

@implementation WebViewController

- (void)viewDidLoad {
    self.showsNavigationCloseBarButtonItem = NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UIWebView delegates

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"Page failed to load...");
    [webView.scrollView.mj_header endRefreshing];
    [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_home_load_failed", nil)];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Page start loading...");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Page finished loading...");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView.scrollView.mj_header endRefreshing];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    // Go to category page
    NSArray *categorySepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"category_id:"];
    if ([categorySepParts count] == 2) {
        NSString *categoryId = [categorySepParts objectAtIndex:1];
        //    NSLog(@"Category Id: %@", categoryId);

        CategoryViewController *nextVC = [CategoryViewController new];
        nextVC.categoryId = [categoryId intValue];
        [self.navigationController pushViewController:nextVC animated:YES];

        return NO;
    }

    // Go to product detail page
    NSArray *productSepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"product_id:"];
    if ([productSepParts count] == 2) {
        NSString *productId = [productSepParts objectAtIndex:1];

        ProductViewController *nextVC = [ProductViewController new];
        nextVC.productId = [productId intValue];
        [self.navigationController pushViewController:nextVC animated:YES];

        return NO;
    }

    return YES;
}

#pragma mark - WKWebView delegates

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%@", navigationAction.request.URL.absoluteString);

    // Go to product VC
    // Old style: product_id:999
    NSArray *oldProductSepParts = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"product_id:"];
    if ([oldProductSepParts count] == 2) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self goToProductVC:[[oldProductSepParts objectAtIndex:1] intValue]];
        return;
    }

    // Full product url style
    NSArray *productSepParts = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"index.php?route=product/product&product_id="];
    if ([productSepParts count] == 2) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self goToProductVC:[[productSepParts objectAtIndex:1] intValue]];
        return;
    }

    // Go to category VC
    // Old style: category_id:999
    NSArray *oldCategorySepParts = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"category_id:"];
    if ([oldCategorySepParts count] == 2) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self goToCategoryVC:[[oldCategorySepParts objectAtIndex:1] intValue]];
        return;
    }

    // Full category url style
    NSArray *categorySepParts = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"index.php?route=product/category&category_id="];
    if ([categorySepParts count] == 2) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self goToCategoryVC:[[categorySepParts objectAtIndex:1] intValue]];
        return;
    }

    // Cart
    NSArray *cartSepParts = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"index.php?route=checkout/cart"];
    if ([cartSepParts count] == 2) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self goToCartVC];
        return;
    }

    // Account
    NSArray *accountSepParts = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"index.php?route=account/account"];
    if ([accountSepParts count] == 2) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[self rdv_tabBarController] setSelectedIndex:self.rdv_tabBarController.viewControllers.count - 1];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

- (void)goToProductVC:(int)productId {
    ProductViewController *nextVC = [[ProductViewController alloc] init];
    [nextVC setHidesBottomBarWhenPushed:YES];
    nextVC.productId = productId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)goToCategoryVC:(int)categoryId {
    CategoryViewController *nextVC = [[CategoryViewController alloc] init];
    [nextVC setHidesBottomBarWhenPushed:YES];
    nextVC.categoryId = categoryId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)goToCartVC {
    CartViewController *nextVC = [[CartViewController alloc] init];
    [nextVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:nextVC animated:YES];
}
@end
