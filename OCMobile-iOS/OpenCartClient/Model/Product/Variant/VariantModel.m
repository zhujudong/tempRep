//
//  VariantModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "VariantModel.h"

@implementation VariantModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"variant_id",
                                                                  @"name": @"name",
                                                                  @"values": @"values"
                                                                  }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        for (VariantValueModel *value in self.values) {
            value.key = [NSString stringWithFormat:@"%ld:%ld", (long)self.id, (long)value.id];
        }
    }
    return self;
}

- (VariantValueModel *)valueAtIndex:(NSInteger)index {
    return [_values objectAtIndex:index];
}

@end
