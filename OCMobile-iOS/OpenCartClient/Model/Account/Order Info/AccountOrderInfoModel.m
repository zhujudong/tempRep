//
//  AccountOrderInfoModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderInfoModel.h"
#import "OCHelper.h"

@implementation AccountOrderInfoModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId": @"order_id",
                                                                  @"orderStatusCode": @"order_status_code",
                                                                  //@"shippingFirstname": @"shipping_firstname",
                                                                  //@"shippingLastname": @"shipping_lastname",
                                                                  @"shippingFullname": @"shipping_fullname",
                                                                  @"shippingTelephone": @"shipping_telephone",
                                                                  @"shippingAddress1": @"shipping_address_1",
                                                                  @"shippingAddress2": @"shipping_address_2",
                                                                  @"shippingCountry": @"shipping_country",
                                                                  @"shippingZone": @"shipping_zone",
                                                                  @"shippingCity": @"shipping_city",
                                                                  @"shippingCounty": @"shipping_county",
                                                                  @"shippingCustomField": @"shipping_custom_field",
                                                                  @"dateAdded": @"date_added",
                                                                  @"paymentMethod": @"payment_method",
                                                                  @"paymentCode": @"payment_code",
                                                                  @"shippingMethod": @"shipping_method",
                                                                  @"products": @"order_products",
                                                                  @"totalFormat": @"total_format",
                                                                  @"totals": @"totals",
                                                                  @"histories": @"histories",
                                                                  }];
}

- (NSString *)fullnameWithTelephone {
    if (_shippingTelephone.length) {
        return [NSString stringWithFormat:@"%@ (%@)", _shippingFullname, _shippingTelephone];
    }
    return _shippingFullname;
}

- (NSString *)formattedAddress {
    return [OCHelper formatAddressForCountry:_shippingCountry zone:_shippingZone city:_shippingCity county:_shippingCounty address1:_shippingAddress1 address2:_shippingAddress2 postcode:@""];
}
@end
