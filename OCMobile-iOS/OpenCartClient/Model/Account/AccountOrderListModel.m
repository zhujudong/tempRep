//
//  AccountOrderListModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListModel.h"

@implementation AccountOrderListModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"currentPage": @"current_page",
                                                                  @"lastPage": @"last_page",
                                                                  @"orders": @"data"}];
}

@end
