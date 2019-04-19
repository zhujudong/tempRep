//
//  OCHelper.m
//  OpenCartClient
//
//  Created by Sam Chen on 2019/3/4.
//  Copyright © 2019 opencart.cn. All rights reserved.
//

#import "OCHelper.h"

@implementation OCHelper
+ (NSString *)formatAddressForCountry: (NSString *)country zone: (NSString *)zone city: (NSString *)city county: (NSString *)county address1: (NSString *)address1 address2: (NSString *)address2 postcode: (NSString *)postcode {

    NSMutableArray *segments = [[NSMutableArray alloc] init];

    // China domestic address format
    if (CONFIG_ADDRESS_CHINA_FORMAT == YES) {
        if (zone.length) {
            [segments addObject:zone];
        }
        if (city.length) {
            [segments addObject:city];
        }
        if (county.length) {
            [segments addObject:county];
        }
        if (address1.length) {
            [segments addObject:address1];
        }

        if (segments.count) {
            NSString *string = [segments componentsJoinedByString:@""];

            if (postcode.length) {
                return [NSString stringWithFormat:@"%@ (%@)", string, postcode];
            }

            return string;
        }
    } else {
        if (address1.length) {
            [segments addObject:address1];
        }
        if (address2.length) {
            [segments addObject:address2];
        }
        if (city.length) {
            [segments addObject:city];
        }
        if (zone.length) {
            [segments addObject:zone];
        }
        if (country.length) {
            [segments addObject:country];
        }

        if (segments.count) {
            NSString *string = [segments componentsJoinedByString:@", "];

            if (postcode.length) {
                return [NSString stringWithFormat:@"%@ (%@)", string, postcode];
            }

            return string;
        }
    }

    return nil;
}
@end
