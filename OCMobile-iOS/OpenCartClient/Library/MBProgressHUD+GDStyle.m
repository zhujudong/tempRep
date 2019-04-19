//
//  MBProgressHUD+GDStyle.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

@implementation MBProgressHUD(GDStyle)

+ (void)showToastToView:(UIView *)view withMessage:(NSString *)message {
    if (view == nil) {
        return;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor darkGrayColor];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:12];
    [hud setYOffset:140];
    [hud setMargin:8];
    [hud setCornerRadius:CONFIG_GENERAL_BORDER_RADIUS];
    [hud hide:YES afterDelay:1.];
}

+ (void)showToastToView:(UIView *)view withMessage:(NSString *)message callback:(void (^)(void))callback {
    if (view == nil) {
        return;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor darkGrayColor];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:12];
    [hud setYOffset:140];
    [hud setMargin:8];
    [hud setCornerRadius:CONFIG_GENERAL_BORDER_RADIUS];
    [hud hide:YES afterDelay:1.];

    if (callback) {
        hud.completionBlock = callback;
    }
}

+ (void)showLoadingHUDToView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = CONFIG_HUD_BG_COLOR;
}

@end
