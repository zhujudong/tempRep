//
//  ProductGridItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductGridItemModel.h"

@implementation ProductGridItemModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (void)setNameWithNSString:(NSString *)string {
    if ([System isDebug]) {
        self.name = [NSString stringWithFormat:@"[%ld] %@", (long)self.productId, string];
    } else {
        self.name = string;
    }
}

@end
