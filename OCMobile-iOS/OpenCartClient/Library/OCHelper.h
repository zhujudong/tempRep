//
//  OCHelper.h
//  OpenCartClient
//
//  Created by Sam Chen on 2019/3/4.
//  Copyright © 2019 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCHelper : NSObject
+ (NSString *)formatAddressForCountry: (NSString *)country zone: (NSString *)zone city: (NSString *)city county: (NSString *)county address1: (NSString *)address1 address2: (NSString *)address2 postcode: (NSString *)postcode;
@end

NS_ASSUME_NONNULL_END
