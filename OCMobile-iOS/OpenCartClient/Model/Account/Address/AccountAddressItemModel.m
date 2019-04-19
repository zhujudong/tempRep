//
//  AccountAddressItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountAddressItemModel.h"
#import "OCHelper.h"

@implementation AccountAddressItemModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"addressId": @"address_id",
                                                                  @"firstname": @"firstname",
                                                                  @"lastname": @"lastname",
                                                                  @"fullname": @"fullname",
                                                                  @"telephone": @"telephone",
                                                                  @"countryId": @"country_id",
                                                                  @"country": @"country_name",
                                                                  @"zoneId": @"zone_id",
                                                                  @"zone": @"zone_name",
                                                                  @"city": @"city_name",
                                                                  @"cityId": @"city_id",
                                                                  @"county": @"county_name",
                                                                  @"countyId": @"county_id",
                                                                  @"postcode": @"postcode",
                                                                  @"address1": @"address_1",
                                                                  @"address2": @"address_2",
                                                                  @"isDefault": @"is_default",
                                                                  @"customField": @"custom_field",
                                                                  // @"formattedAddress: @"formatted_address""
                                                                  }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        if (self.cityId < 1) {
            self.city = [dict objectForKey:@"city"];
        }
    }
    return self;
}

- (NSString *)stringifyLocation {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    if (_country.length) {
        [names addObject:_country];
    }
    if (_zone.length) {
        [names addObject:_zone];
    }
    if (_city.length) {
        [names addObject:_city];
    }
    if (_county.length) {
        [names addObject:_county];
    }
    if (names.count) {
        return [names componentsJoinedByString:@" "];
    }
    return nil;
}

- (void)setLocationIdsInOrderedArray:(NSArray *)ids {
    _countryId = 0;
    _zoneId = 0;
    _cityId = 0;
    _countyId = 0;

    for (NSInteger i = 0; i < ids.count; i++) {
        NSNumber *id = [ids objectAtIndex:i];
        if (i == 0) {
            _countryId = id.integerValue;
            continue;
        }

        if (i == 1) {
            _zoneId = id.integerValue;
            continue;
        }

        if (i == 2) {
            _cityId = id.integerValue;
            continue;
        }

        if (i == 3) {
            _countyId = id.integerValue;
            continue;
        }
    }
}

- (NSArray *)groupLocationIdsToArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSNumber numberWithInteger:_countryId]];
    [array addObject:[NSNumber numberWithInteger:_zoneId]];
    [array addObject:[NSNumber numberWithInteger:_cityId]];
    [array addObject:[NSNumber numberWithInteger:_countyId]];
    return array;
}

- (NSString *)fullnameWithTelephone {
    if (_telephone.length) {
        return [NSString stringWithFormat:@"%@ (%@)", _fullname, _telephone];
    }
    return _fullname;
}

- (NSString *)formattedAddress {
    return [OCHelper formatAddressForCountry:_country zone:_zone city:_city county:_county address1:_address1 address2:_address2 postcode:_postcode];
}
@end
