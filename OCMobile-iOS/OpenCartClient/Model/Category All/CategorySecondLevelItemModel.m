//
//  CategorySecondLevelItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategorySecondLevelItemModel.h"

@implementation CategorySecondLevelItemModel
+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}
@end
