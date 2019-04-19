//
//  MBProgressHUD+GDStyle.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD(GDStyle)

+ (void)showToastToView:(UIView *)view withMessage:(NSString *)message callback:(void (^)(void))callback;
+ (void)showToastToView:(UIView *)view withMessage:(NSString *)message;
+ (void)showLoadingHUDToView:(UIView *)view;

@end
