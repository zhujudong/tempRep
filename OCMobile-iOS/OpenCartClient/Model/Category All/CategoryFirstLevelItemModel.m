//
//  CategoryFirstLevelItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryFirstLevelItemModel.h"

@implementation CategoryFirstLevelItemModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
