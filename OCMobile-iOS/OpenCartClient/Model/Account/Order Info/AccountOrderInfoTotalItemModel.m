//
//  AccountOrderInfoTotalItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderInfoTotalItemModel.h"

@implementation AccountOrderInfoTotalItemModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
