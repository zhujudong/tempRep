//
//  CallingCodeModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 2019/3/4.
//  Copyright © 2019 opencart.cn. All rights reserved.
//

#import "CallingCodeModel.h"

@implementation CallingCodeModel
+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}
@end
