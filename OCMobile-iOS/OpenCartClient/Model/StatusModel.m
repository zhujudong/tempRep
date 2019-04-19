//
//  StatusModel.m
//  JSONModel-Test
//
//  Created by Sam Chen on 1/22/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel

+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
