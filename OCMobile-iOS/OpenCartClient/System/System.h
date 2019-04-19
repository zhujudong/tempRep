//
//  System.h
//  OpenCartClient
//
//  Created by Sam Chen on 24/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface System : NSObject

+ (System *)sharedInstance;
- (void)reload;
- (NSString *)languageName;
- (NSString *)languageCode;
- (BOOL)isSimplifiedChineseLanguage;
- (NSString *)currencyCode;
- (NSString *)installedVersion;
- (BOOL)isiPhoneX;
- (BOOL)isiPad;
+ (BOOL)isDebug;
- (CGFloat)statusBarHeight;
- (CGFloat)tabBarHeight;
@end
