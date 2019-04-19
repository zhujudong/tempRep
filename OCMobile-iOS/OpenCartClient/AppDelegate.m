//
//  AppDelegate.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Customer.h"
#import "StatusModel.h"
#import <JSONModel/JSONHTTPClient.h>
#import "PaymentResultViewController.h"
#import "RootTabBarViewController.h"
#import "PaymentConnectViewController.h"
#import "ProductViewController.h"
#import "CategoryViewController.h"
#import "WebViewController.h"
#import "CRToast.h"
#import "JPUSHService.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "SearchViewController.h"
#import "HomeViewController.h"
#import "AccountViewController.h"
#import "CartViewController.h"
#import "CategoryAllFlatViewController.h"
#import "CategoryAllSidebarViewController.h"
#import "AnalyticsManager.h"
#import "ShareSDKManager.h"
#import "ServerSplashImageManager.h"
#import <Bugly/Bugly.h>
#import "SettingModel.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "PayPalMobile.h"
#import "LoginViewController.h"
#import "NavigationViewController.h"
#import "AlipayPaymentResultHandler.h"
#import "WechatPaymentResultHandler.h"
#import "DiscoveryViewController.h"
#import "WXApi.h"

@interface AppDelegate() {
    BOOL pushNotificationDirectTransit;
}
@property (strong, nonatomic) RDVTabBarController *tabBarController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    
    // Init base tab bar controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupTabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 状态栏显示网络使用图标
    //  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_icon"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_icon"]];
    
    //设置底部 TAB 条背景色
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"ffffff" alpha:1.]];
    
    [[UITabBar appearance] setTintColor:CONFIG_PRIMARY_COLOR];
    //  [[UITabBar appearance] setAlpha:1.0];
    
    //Register Paypal
    if (CONFIG_PAYPAL_CLIENT_ID.length) {
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction: CONFIG_PAYPAL_CLIENT_ID,
                                                               PayPalEnvironmentSandbox: CONFIG_PAYPAL_CLIENT_ID}];
    }
    
    //Register Wechat
    [WXApi registerApp:CONFIG_WECHAT_SDK_SCHEME];
    
    //Register Weibo
    //[WeiboSDK registerApp:CONFIG_WEIBO_KEY];
    
    //Load Splash image from
    [[ServerSplashImageManager sharedInstance] startToLoadCustomLaunchImage];
    
    // +++++ Register push notifications +++++
    //[self registerForPushNotifications:application];
    
    if (CONFIG_JPUSH_KEY.length > 0) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        }
        
        [JPUSHService setupWithOption:launchOptions appKey:CONFIG_JPUSH_KEY channel:nil apsForProduction:YES];
    }
    
    // +++++ Handle Push notifications +++++
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([userInfo valueForKey:@"aps"]) {
        NSLog(@"didFinishLaunchingWithOptions - userInfo: %@", userInfo);
        //    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(handlePushNotificationsFromLaunching:) userInfo:userInfo repeats:NO];
    }
    
    //ShareSDK Init
    [ShareSDKManager sharedInstance];
    
    // Bugly init
    if ([System isDebug] == NO) {
        if (CONFIG_BUGLY_APPID.length > 0) {
            [Bugly startWithAppId:CONFIG_BUGLY_APPID];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    pushNotificationDirectTransit = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //Process ACCESS TOKEN
    [[Customer sharedInstance] prepareAccessTokenWithBlock:nil];
    pushNotificationDirectTransit = NO;
    [self checkNewVersion];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    //iOS 9.0+
    
    // Alipay payment callback
    if ([url.host isEqualToString:@"safepay"]) {
        [[ServerSplashImageManager sharedInstance] forceExpired];
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"Alipay callback result: %@",resultDic);
            
            AlipayPaymentResultHandler *alipayResultHandler = [[AlipayPaymentResultHandler alloc] init];
            [alipayResultHandler processResult:resultDic];
        }];
    }
    
    // Wechat payment callback
    if ([url.host isEqualToString:@"pay"]) {
        [[ServerSplashImageManager sharedInstance] forceExpired];
        
        // Call payment connect VC to process the result
        WechatPaymentResultHandler *wechatPaymentResultHandler = [[WechatPaymentResultHandler alloc] init];
        [WXApi handleOpenURL:url delegate:wechatPaymentResultHandler];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    // Alipay payment callback
    if ([url.host isEqualToString:@"safepay"]) {
        [[ServerSplashImageManager sharedInstance] forceExpired];
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"Alipay callback result: %@",resultDic);
            
            AlipayPaymentResultHandler *alipayResultHandler = [[AlipayPaymentResultHandler alloc] init];
            [alipayResultHandler processResult:resultDic];
        }];
    }
    
    // Wechat payment callback
    if ([url.host isEqualToString:@"pay"]) {
        [[ServerSplashImageManager sharedInstance] forceExpired];
        
        // Call payment connect VC to process the result
        WechatPaymentResultHandler *wechatPaymentResultHandler = [[WechatPaymentResultHandler alloc] init];
        [WXApi handleOpenURL:url delegate:wechatPaymentResultHandler];
    }
    
    return YES;
}

// Register Push Notifications
/*
 - (void)registerForPushNotifications: (UIApplication *)application {
 NSLog(@"registerForPushNotifications");
 UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
 [application registerUserNotificationSettings:notificationSettings];
 }*/

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"didRegisterUserNotificationSettings");
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        // [application registerForRemoteNotifications];
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for remote nofitications %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);
    //  NSLog(@"applicationState: %ld", (long)[[UIApplication sharedApplication] applicationState]);
    
    //  [JPUSHService handleRemoteNotification:userInfo];
    //[UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    if ([userInfo valueForKey:@"aps"]) {
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state != UIApplicationStateActive) { // Inactive
            [self handlePushNotifications:userInfo];
        } else { // Active
            CGSize iconSize = CGSizeMake(36., 36.);
            UIImage *originalIcon = [UIImage imageNamed:@"logo"];
            UIGraphicsBeginImageContext(iconSize);
            [originalIcon drawInRect:CGRectMake(0, 0, iconSize.width, iconSize.height)];
            UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSDictionary *options = @{
                                      kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                                      kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover),
                                      //kCRToastUnderStatusBarKey: @YES,
                                      kCRToastTextKey: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                                      kCRToastSubtitleTextKey: [aps valueForKey:@"alert"],
                                      kCRToastTimeIntervalKey: @5.,
                                      kCRToastImageKey: icon,
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                      kCRToastSubtitleTextAlignmentKey: @(NSTextAlignmentLeft),
                                      kCRToastBackgroundColorKey: [UIColor colorWithHexString:@"#333333" alpha:.95],
                                      kCRToastAnimationInDirectionKey: @(CRToastAnimationDirectionTop),
                                      kCRToastAnimationOutDirectionKey: @(CRToastAnimationDirectionTop),
                                      kCRToastInteractionRespondersKey:@[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                                         automaticallyDismiss:YES
                                                                                                                                        block:^(CRToastInteractionType interactionType){
                                                                                                                                            NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                                                                                                            [self handlePushNotifications:userInfo];
                                                                                                                                        }]],
                                      };
            [CRToastManager showNotificationWithOptions:options
                                        completionBlock:^{
                                            // NSLog(@"Completed");
                                        }];
        }
    }
}

- (void)handlePushNotificationsFromLaunching: (NSTimer *)timer {
    NSDictionary *userInfo = [timer userInfo];
    [self handlePushNotifications:userInfo];
}

- (void)handlePushNotifications: (NSDictionary *)userInfo {
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //  [JPUSHService resetBadge];
    
    NSString *pnType = [userInfo valueForKey:@"pn_type"];
    NSString *pnValue = [userInfo valueForKey:@"pn_value"];
    
    if (pnType == nil || pnValue == nil) {
        NSLog(@"`pn_type` and `pn_value` params missing.");
        return;
    }
    
    RDVTabBarController *tabBarController = (RDVTabBarController *)self.window.rootViewController;
    
    if (!tabBarController) {
        // Select the account tab
        return;
    }
    
    NavigationViewController *currentNavController = (NavigationViewController *)[tabBarController selectedViewController];
    if ([pnType isEqualToString:@"product"]) {
        NSInteger productId = [pnValue intValue];
        
        if (productId > 0) {
            ProductViewController *nextVC = [ProductViewController new];
            nextVC.productId = productId;
            
            [currentNavController pushViewController:nextVC animated:YES];
        }
    } else if ([pnType isEqualToString:@"category"]) {
        NSInteger categoryId = [pnValue intValue];
        
        if (categoryId > 0) {
            CategoryViewController *nextVC = [CategoryViewController new];
            nextVC.categoryId = categoryId;
            
            [currentNavController pushViewController:nextVC animated:YES];
        }
    } else if ([pnType isEqualToString:@"web"]) {
        WebViewController *nextVC = [[WebViewController alloc] initWithAddress:pnValue];
        [currentNavController pushViewController:nextVC animated:YES];
    }
}

#pragma mark - Present VC
- (void)presentLoginViewController {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    if ([[Customer sharedInstance] isLogged]) {
        loginVC.requestNewAccessToken = YES;
    }
    
    NavigationViewController *navController = [[NavigationViewController alloc] initWithRootViewController:loginVC];
    [self.window.rootViewController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Kill App for no access token
- (void)suicide {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"toast_app_delegate_token_invalid", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_app_delegate_restart", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    
    [alert addAction:action];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - setup tabbar
- (void)setupTabBarController {
    NavigationViewController *homeNavController = [[NavigationViewController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    NavigationViewController *discoveryNavController = [[NavigationViewController alloc] initWithRootViewController:[[DiscoveryViewController alloc] init]];
    
    NavigationViewController *categoryNavController = nil;
    if (CONFIG_CATEGORY_ALL_STYLE == 1) {
        categoryNavController = [[NavigationViewController alloc] initWithRootViewController:[[CategoryAllSidebarViewController alloc] init]];
    } else {
        categoryNavController = [[NavigationViewController alloc] initWithRootViewController:[[CategoryAllFlatViewController alloc] init]];
    }
    
    NavigationViewController *cartNavController = [[NavigationViewController alloc] initWithRootViewController:[[CartViewController alloc] init]];
    NavigationViewController *accountNavController = [[NavigationViewController alloc] initWithRootViewController:[[AccountViewController alloc] init]];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[homeNavController, discoveryNavController, categoryNavController, cartNavController, accountNavController]];
    
    tabBarController.tabBar.translucent = YES;
    tabBarController.tabBar.backgroundView.backgroundColor = [UIColor whiteColor];
    tabBarController.tabBar.backgroundView.layer.masksToBounds = NO;
    tabBarController.tabBar.backgroundView.layer.shadowOffset = CGSizeMake(0, -0.5);
    tabBarController.tabBar.backgroundView.layer.shadowOpacity = .25;
    
    if ([[System sharedInstance] isiPhoneX]) {
         tabBarController.tabBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, [[System sharedInstance] tabBarHeight]);
    }
    
    NSArray *keys = @[@"home", @"discovery", @"category", @"cart", @"account"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setFinishedSelectedImage: [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_hover", [keys objectAtIndex:index]]] withFinishedUnselectedImage: [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@", [keys objectAtIndex:index]]]];
        
        NSDictionary *unselectedTitleAttritues = @{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:@"232323" alpha:1]};
        
        NSDictionary *selectedTitleAttritues = @{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                                 NSForegroundColorAttributeName: CONFIG_PRIMARY_COLOR};
        item.unselectedTitleAttributes = unselectedTitleAttritues;
        item.selectedTitleAttributes = selectedTitleAttritues;
        
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        if ([[System sharedInstance] isiPhoneX]) {
            item.itemHeight = [[System sharedInstance] tabBarHeight];
        }
        
        NSString *title = [NSString stringWithFormat:@"text_tab_%@", [keys objectAtIndex:index]];
        item.title = NSLocalizedString(title, nil);
        
        index++;
    }
    
    self.tabBarController = tabBarController;
    self.window.rootViewController = self.tabBarController;
}

- (void)reloadRootViewControllerWhenLanguageChanged {
    [self setupTabBarController];
    [[System sharedInstance] reload];
    [[Network sharedInstance] updateLanguageAndCurrencyForHttpHeaderField];
    [self.tabBarController setSelectedIndex:self.tabBarController.viewControllers.count - 1];
}

#pragma mark - Check version
- (void)checkNewVersion {
    [[Network sharedInstance] GET:@"settings" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data == nil) {
            return;
        }

        SettingModel *setting = [[SettingModel alloc] initWithDictionary:data error:nil];
        if (setting == nil || [setting hasNewVersion] == NO || setting.upgradeLink.length < 1) {
            return;
        }

        [[ServerSplashImageManager sharedInstance] forceExpired];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"label_new_version_title", nil) message:NSLocalizedString(@"text_new_version_message", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_new_version", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]
             openURL:[NSURL URLWithString: setting.upgradeLink]];
        }];

        [alert addAction:action];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}
@end
