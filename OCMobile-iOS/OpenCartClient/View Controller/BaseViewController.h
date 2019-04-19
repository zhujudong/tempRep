//
//  BaseViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/06/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showLoginVC;
- (void)showToastMessageOnCurrentView:(NSString *)message;

@end
