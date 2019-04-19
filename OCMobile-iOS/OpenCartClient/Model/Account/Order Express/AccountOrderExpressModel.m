//
//  AccountOrderExperssModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderExpressModel.h"

@implementation AccountOrderExpressModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"code": @"company_code",
                                                                  @"name": @"company_name",
                                                                  @"expressNo": @"express_no",
                                                                  @"traces": @"traces",
                                                                  }];
}

@end
