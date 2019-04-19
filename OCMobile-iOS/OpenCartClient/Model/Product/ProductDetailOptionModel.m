//
//  ProductDetailOptionModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductDetailOptionModel.h"

@implementation ProductDetailOptionModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"productOptionId": @"product_option_id",
                                                                  @"name": @"name",
                                                                  @"type": @"type",
                                                                  @"required": @"required",
                                                                  @"productOptionValue": @"option_values"}];
}

- (void)setTypeWithNSString:(NSString *)string {
    if ([string isEqualToString:@"radio"]) {
        self.type = ProductOptionTypeRadio;
    } else if ([string isEqualToString:@"checkbox"]) {
        self.type = ProductOptionTypeCheckbox;
    } else {
        self.type = ProductOptionTypeRadio;
    }
}

@end
