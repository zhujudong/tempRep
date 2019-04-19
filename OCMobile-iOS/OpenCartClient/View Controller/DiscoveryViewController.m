//
//  DiscoveryViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/7/20.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "GDRefreshNormalHeader.h"
#import "WebViewController.h"

@interface DiscoveryViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_tab_discovery", nil);

    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0" alpha:1.0];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    NSURL *url = [NSURL URLWithString:[self discoveryUrl]];
    NSLog(@"URL: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest: request];

    _webView.scrollView.mj_header= [GDRefreshNormalHeader headerWithRefreshingBlock:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [_webView stopLoading];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showLoadingHUDToView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"URL failed to load...");
    [webView.scrollView.mj_header endRefreshing];
    [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_home_load_failed", nil)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"URL finished loading...");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_webView.scrollView.mj_header endRefreshing];

    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Continue to load discovery
    if ([[[request URL] absoluteString] isEqualToString:[self discoveryUrl]]) {
        return YES;
    }

    WebViewController *nextVC = [[WebViewController alloc] initWithURL:request.URL];
    [nextVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:nextVC animated:YES];

    return NO;
}

#pragma mark - Private
- (NSString *)discoveryUrl {
    return [NSString stringWithFormat:@"%@%@&lang=%@&currency=%@&debug=%@", CONFIG_WEB_URL, @"index.php?route=app/discovery", [[System sharedInstance] languageCode], [[System sharedInstance] currencyCode], [System isDebug] ? @"1" : @"0"];
}
@end
