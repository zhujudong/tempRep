//
//  CategoryFirstLevelAllModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryFirstLevelAllModel.h"

@implementation CategoryFirstLevelAllModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
