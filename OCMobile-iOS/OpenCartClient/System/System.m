//
//  System.m
//
//
//  Created by Sam Chen on 24/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "System.h"
#import "BundleLocalization.h"

#define TABBAR_HEIGHT 49.0
#define TABBAR_HEIGHT_IPHONEX 80.0
//#define STATUS_BAR_HEIGHT 20.0
//#define STATUS_BAR_HEIGHT_IPHONEX 44.0

typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageTypeEN,
    LanguageTypeCN,
    LanguageTypeAR
};

@interface System()
@property (nonatomic) LanguageType language;
@property (strong, nonatomic) NSString *currency;
@property (nonatomic) BOOL isiPhoneX;
@property (nonatomic) BOOL isiPad;
@end

@implementation System

+ (System *)sharedInstance {
    static System *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[System alloc] init];
    });

    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self reload];
    }

    return self;
}

- (void)reload {
    // Set language code & currency code
    NSLog(@"Application language: %@", [BundleLocalization sharedInstance].language);

    self.language = LanguageTypeEN;
    self.currency = CONFIG_DEFAULT_EN_CURRENCY;

    if ([[BundleLocalization sharedInstance].language isEqualToString:@"zh-Hans"] || [[BundleLocalization sharedInstance].language isEqualToString:@"zh_CN"]) {
        self.language = LanguageTypeCN;
        self.currency = CONFIG_DEFAULT_CN_CURRENCY;
    }

    if ([[BundleLocalization sharedInstance].language isEqualToString:@"ar"]) {
        self.language = LanguageTypeAR;
        self.currency = CONFIG_DEFAULT_CN_CURRENCY;
    }
    
    self.isiPhoneX = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIScreen.mainScreen.nativeBounds.size.height >= 2436);
    self.isiPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

- (BOOL)isSimplifiedChineseLanguage {
    return self.language == LanguageTypeCN;
}

- (NSString *)languageCode {
    return self.language == LanguageTypeCN ? @"zh-cn" : @"en-gb";
}

- (NSString *)currencyCode {
    return self.currency;
}

- (NSString *)languageName {
    if (self.language == LanguageTypeCN) {
        return @"简体中文";
    }

    if (self.language == LanguageTypeAR) {
        return @"Arabic";
    }

    return @"English";
}

- (NSString *)installedVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (BOOL)isDebug {
#if DEBUG
    return YES;
#else
    return NO;
#endif
}

- (BOOL)isiPhoneX {
    return _isiPhoneX;
}

- (BOOL)isiPad {
    return _isiPad;
}

- (CGFloat)tabBarHeight {
    if (_isiPhoneX) {
        return TABBAR_HEIGHT_IPHONEX;
    }
    return TABBAR_HEIGHT;
}

- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}
@end
