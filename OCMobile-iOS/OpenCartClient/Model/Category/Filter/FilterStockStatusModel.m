//
//  FilterStockStatusModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterStockStatusModel.h"

@implementation FilterStockStatusModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"name": @"name",
                                                                  @"id": @"stock_status_id",
                                                                  }];
}

@end
