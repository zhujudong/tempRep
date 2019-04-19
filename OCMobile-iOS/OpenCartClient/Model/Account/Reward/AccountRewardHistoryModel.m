//
//  AccountRewardHistoryModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountRewardHistoryModel.h"

@implementation AccountRewardHistoryModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"name": @"description",
                                                                  @"dateAdded": @"date_added",
                                                                  @"points": @"points",
                                                                  }];
}

@end
