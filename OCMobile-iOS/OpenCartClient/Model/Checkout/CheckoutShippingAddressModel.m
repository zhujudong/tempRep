//
//  CheckoutShippingAddressModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutShippingAddressModel.h"
#import "OCHelper.h"

@implementation CheckoutShippingAddressModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"addressId": @"address_id",
//                                                                  @"firstname": @"firstname",
//                                                                  @"lastname": @"lastname",
                                                                  @"fullname": @"fullname",
                                                                  @"telephone": @"telephone",
                                                                  @"country": @"country_name",
//                                                                  @"countryId": @"country_id",
                                                                  @"zone": @"zone_name",
//                                                                  @"zoneId": @"zone_id",
                                                                  @"city": @"city_name",
                                                                  @"county": @"county_name",
                                                                  @"address1": @"address_1",
                                                                  @"address2": @"address_2",
                                                                  @"isDefault": @"is_default"}];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        if (self.city.length < 1) {
            self.city = [dict objectForKey:@"city"];
        }
    }
    return self;
}

- (NSString *)fullnameWithTelephone:(BOOL)telephone {
    if (telephone && _telephone.length) {
        return [NSString stringWithFormat:@"%@ (%@)", _fullname, _telephone];
    }
    return _fullname;
}

- (NSString *)formattedAddress {
    return [OCHelper formatAddressForCountry:_country zone:_zone city:_city county:_county address1:_address1 address2:_address2 postcode:_postcode];
}
@end
