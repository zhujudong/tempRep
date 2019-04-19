//
//  ProductDetailSelectedOptionModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "ProductDetailSelectedOptionModel.h"

@interface ProductDetailSelectedOptionModel()
@property (nonatomic) NSMutableArray<ProductDetailOptionValueModel> *values;
@end

@implementation ProductDetailSelectedOptionModel

- (instancetype)initWithOptionModel: (ProductDetailOptionModel *)option {
    self = [super init];

    if (self) {
        self.type = option.type;
        self.productOptionId = option.productOptionId;
        self.required = option.required;
        self.name = option.name;
        self.values = [[NSMutableArray<ProductDetailOptionValueModel> alloc] init];
    }

    return self;
}

- (void)addSelectedOptionValue: (ProductDetailOptionValueModel *)newOptionValue {
    for (ProductDetailOptionValueModel *value in self.values) {
        if (value.productOptionValueId == newOptionValue.productOptionValueId) {
            return;
        }
    }

    if (self.type == ProductOptionTypeRadio) {
        [self.values removeAllObjects];
    }

    [self.values addObject:newOptionValue];
    NSLog(@"%@", [self convertToDict]);
}

- (void)removeSelectedOptionValue: (ProductDetailOptionValueModel *)optionValue {
    if (self.values.count < 1) {
        return;
    }
    
    if (_values.count == 1 && _required) {
        return;
    }

    for (NSInteger i = 0; i < self.values.count; i++) {
        ProductDetailOptionValueModel *value = [self.values objectAtIndex:i];
        if (value.productOptionValueId == optionValue.productOptionValueId) {
            [self.values removeObjectAtIndex:i];
            NSLog(@"%@", [self convertToDict]);
            return;
        }
    }
}

- (BOOL)containsValue:(ProductDetailOptionValueModel *)optionValue {
    for (ProductDetailOptionValueModel *value in _values) {
        if (value.productOptionValueId == optionValue.productOptionValueId) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)convertToDict {
    if (_values.count < 1) {
        return nil;
    }
    
    NSMutableArray *productOptionValueIds = [[NSMutableArray alloc] init];
    for (ProductDetailOptionValueModel *value in _values) {
        [productOptionValueIds addObject:[NSNumber numberWithInteger:value.productOptionValueId]];
    }
    
    if (_type == ProductOptionTypeCheckbox) {
        return @{[NSString stringWithFormat:@"%ld", (long)_productOptionId]:productOptionValueIds};
    }
    
    return @{[NSString stringWithFormat:@"%ld", (long)_productOptionId]:[productOptionValueIds objectAtIndex:0]};
}

- (NSArray *)convertToArray {
    if (_values.count < 1) {
        return nil;
    }
    
    NSMutableArray *productOptionValueIds = [[NSMutableArray alloc] init];
    for (ProductDetailOptionValueModel *value in _values) {
        [productOptionValueIds addObject:[NSNumber numberWithInteger:value.productOptionValueId]];
    }
    return productOptionValueIds;
}

- (NSString *)allValueNames {
    if (_values.count < 1) {
        return @"";
    }
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (ProductDetailOptionValueModel *value in _values) {
        [names addObject:value.name];
    }
    return [names componentsJoinedByString:@" "];
}

@end
