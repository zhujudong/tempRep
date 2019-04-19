//
//  AccountSocialModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 12/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "AccountSocialModel.h"

@implementation AccountSocialModel
+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}
@end
