//
//  HomeViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "ProductViewController.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "UITabBarController+CartNumber.h"
#import "RDVTabBarController+CartNumber.h"
#import "EmptyView.h"
#import "GDRefreshNormalHeader.h"
#import "RDVTabBarController.h"
#import "HomeNavBarView.h"

@interface HomeViewController ()<UIWebViewDelegate, UIScrollViewDelegate> {
    bool statusBarLightStyle;
}

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) HomeNavBarView *navBarView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.rdv_tabBarController updateCartNumber];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0" alpha:1.0];
    
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0" alpha:1.0];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    UIEdgeInsets padding = UIEdgeInsetsMake([[System sharedInstance] statusBarHeight] * -1, 0, 0, 0);
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(padding);
    }];

    NSURLRequest *request = [NSURLRequest requestWithURL:[self homepageUrl]];
    [_webView loadRequest: request];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [_webView setContentMode:UIViewContentModeScaleToFill];

    __weak typeof(self) weakSelf = self;
    
    _webView.scrollView.mj_header= [GDRefreshNormalHeader headerWithRefreshingBlock:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [weakSelf.webView stopLoading];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[weakSelf homepageUrl]]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    if (!_navBarView) {
        [self createNavigationBarView];
    }
    
    _webView.scrollView.delegate = self;
    [self scrollViewDidScroll:_webView.scrollView];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
    if (animated) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
    
    _webView.scrollView.delegate = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    //    NSLog(@"offsetY: %f", offsetY);
    [_navBarView scrollViewDidScrollToOffsetY:offsetY];
    statusBarLightStyle = (offsetY <= -([[System sharedInstance] statusBarHeight]));
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return statusBarLightStyle ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Home page failed to load...");
    [webView.scrollView.mj_header endRefreshing];
    [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_home_load_failed", nil)];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Home page start loading...");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Home page finished loading...");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_webView.scrollView.mj_header endRefreshing];
    
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Go to product VC
    // Old style: product_id:999
    NSArray *oldProductSepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"product_id:"];
    if ([oldProductSepParts count] == 2) {
        NSString *productId = [oldProductSepParts objectAtIndex:1];

        ProductViewController *nextVC = [[ProductViewController alloc] init];
        [nextVC setHidesBottomBarWhenPushed:YES];
        nextVC.productId = [productId intValue];
        [self.navigationController pushViewController:nextVC animated:YES];

        return NO;
    }

    // Full product url style
    NSArray *productSepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"index.php?route=product/product&product_id="];
    if ([productSepParts count] == 2) {
        ProductViewController *nextVC = [[ProductViewController alloc] init];
        [nextVC setHidesBottomBarWhenPushed:YES];
        nextVC.productId = [[productSepParts objectAtIndex:1] intValue];
        [self.navigationController pushViewController:nextVC animated:YES];

        return NO;
    }

    // Go to category VC
    // Old style: category_id:999
    NSArray *oldCategorySepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"category_id:"];
    if ([oldCategorySepParts count] == 2) {
        NSString *categoryId = [oldCategorySepParts objectAtIndex:1];

        CategoryViewController *nextVC = [CategoryViewController new];
        [nextVC setHidesBottomBarWhenPushed:YES];
        nextVC.categoryId = [categoryId intValue];
        [self.navigationController pushViewController:nextVC animated:YES];

        return NO;
    }

    // Full category url style
    NSArray *categorySepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"index.php?route=product/category&category_id="];
    if ([categorySepParts count] == 2) {
        CategoryViewController *nextVC = [[CategoryViewController alloc] init];
        [nextVC setHidesBottomBarWhenPushed:YES];
        nextVC.categoryId = [[categorySepParts objectAtIndex:1] intValue];
        [self.navigationController pushViewController:nextVC animated:YES];

        return NO;
    }

    // Go to info VC
    NSArray *infoSepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"index.php?route=app/information&information_id="];
    if ([infoSepParts count] == 2) {
        //    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
        WebViewController *nextVC = [[WebViewController alloc] initWithURL:request.URL];
        [nextVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:nextVC animated:YES];

        return NO;
    }

    // Continue to load home page
    NSArray *homeSepParts = [[[request URL] absoluteString] componentsSeparatedByString:@"index.php?route=app/home"];
    if ([homeSepParts count] == 2) {
        return YES;
    }

    //  self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    WebViewController *nextVC = [[WebViewController alloc] initWithURL:request.URL];
    [nextVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:nextVC animated:YES];

    return NO;
}

- (void)createNavigationBarView {
    __weak typeof(self) weakSelf = self;
    CGRect frame;

    frame = CGRectMake(0, [[System sharedInstance] statusBarHeight] * -1, SCREEN_WIDTH, [HomeNavBarView navBarHeight]);

    _navBarView =[[HomeNavBarView alloc] initWithFrame:frame];
    _navBarView.leftButtonClickedBlock = ^{
        [weakSelf selectCategoryTab];
    };
    _navBarView.rightButtonClickedBlock = ^{
        [weakSelf selectCartTab];
    };
    _navBarView.searchButtonClickedBlock = ^{
        [weakSelf selectSearchTab];
    };
    [self.view addSubview:_navBarView];
}

- (void)selectCategoryTab {
    NSLog(@"selectCategoryTab");
    [[self rdv_tabBarController] setSelectedIndex:2];
}

- (void)selectCartTab {
    [[self rdv_tabBarController] setSelectedIndex:3];
}

- (void)selectSearchTab {
    NSLog(@"selectSearchTab");
    SearchViewController *nextVC = [SearchViewController new];
    nextVC.pushedFromViewController = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (NSURL *)homepageUrl {
    NSString *href = [NSString stringWithFormat:@"%@%@&lang=%@&currency=%@&debug=%@", CONFIG_WEB_URL, @"index.php?route=app/home", [[System sharedInstance] languageCode], [[System sharedInstance] currencyCode], [System isDebug] ? @"1" : @"0"];
    NSLog(@"Home page URL: %@", href);
    return [NSURL URLWithString:href];
}

@end
