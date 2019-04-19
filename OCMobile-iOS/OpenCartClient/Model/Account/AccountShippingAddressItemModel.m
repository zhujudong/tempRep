//
//  AccountShippingAddressItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountShippingAddressItemModel.h"

@implementation AccountShippingAddressItemModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"addressId": @"address_id",
                                                                  @"isDefault": @"default",
                                                                  @"firstname": @"firstname",
                                                                  @"formattedAddress": @"formatted_address",
                                                                  }];
}

@end
