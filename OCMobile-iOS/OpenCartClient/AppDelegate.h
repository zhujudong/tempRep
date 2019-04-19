//
//  AppDelegate.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

- (void)reloadRootViewControllerWhenLanguageChanged;
- (void)presentLoginViewController;
- (void)suicide;
@end

