//
//  AccountOrderListOrderItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListOrderItemModel.h"

@implementation AccountOrderListOrderItemModel

+ (JSONKeyMapper *) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId": @"order_id",
                                                                  @"orderStatusId": @"order_status_id",
                                                                  @"orderStatusName": @"order_status_name",
                                                                  @"orderStatusCode": @"order_status_code",
                                                                  @"totalFormat": @"total_format",
                                                                  @"hasTracks": @"has_tracks",
                                                                  @"dateAdded": @"date_added",
                                                                  @"products": @"order_products",
                                                                  }];
}

@end
