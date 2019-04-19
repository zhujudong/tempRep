//
//  ProductVariantModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "ProductVariantModel.h"

@interface ProductVariantModel() {
    NSMutableArray *_selectedVariantValues;
}
@end

@implementation ProductVariantModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"key": @"keys",
                                                                  @"variants": @"variants",
                                                                  @"skus": @"skus",
                                                                  @"currentVariant": @"product_variants",
                                                                  }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        _selectedVariantValues = [[NSMutableArray alloc] init];
        for (ProductVariantSKUCurrentModel *variant in _currentVariant) {
            [_selectedVariantValues addObject:[NSString stringWithFormat:@"%ld:%ld", (long)variant.id, (long)variant.valueId]];
        }
    }
    return self;
}

- (VariantModel *)variantAtIndex:(NSInteger)index {
    return [_variants objectAtIndex:index];
}

- (VariantValueModel *)variantValueAtIndexPath:(NSIndexPath *)indexPath {
    return [[self variantAtIndex:indexPath.section] valueAtIndex:indexPath.row];
}

- (BOOL)toggleVariantValueSelectionForKey:(NSString *)key {
    if ([self isVariantValueSelectedForKey:key]) {
        [_selectedVariantValues removeObject:key];
        NSLog(@"%@", [self stringifySelectedValues]);
        return NO;
    }
    
    [_selectedVariantValues addObject:key];
    NSLog(@"%@", [self stringifySelectedValues]);
    return YES;
}

- (BOOL)isVariantValueSelectedForKey:(NSString *)key {
    return [_selectedVariantValues containsObject:key];
}

- (BOOL)isVariantValueSelectableForKey:(NSString *)key {
    NSMutableArray *candidateSelectedVariantValues = [_selectedVariantValues mutableCopy];
    // Replace selected value of same group for new key. i.e. 100:101 -> 100:102
    // Get prefix: 100:101 -> 100
    NSString *prefix = [key componentsSeparatedByString:@":"][0];
    // Prefix should be: 100:
    prefix = [NSString stringWithFormat:@"%@:", prefix];
    
    // Replace strings in selected values array with new key value
    for (NSInteger i = 0; i < candidateSelectedVariantValues.count; i++) {
        NSString *selectedValue = [candidateSelectedVariantValues objectAtIndex:i];
        if ([selectedValue hasPrefix:prefix]) {
            [candidateSelectedVariantValues replaceObjectAtIndex:i withObject:key];
        }
    }
    if ([candidateSelectedVariantValues containsObject:key] == NO) {
        [candidateSelectedVariantValues addObject:key];
    }
    
    NSInteger totalSelectedValues = candidateSelectedVariantValues.count;
    for (ProductVariantSKUModel *sku in _skus) {
        NSInteger finds = 0;
        for (NSString *selected in candidateSelectedVariantValues) {
            NSString *key = [NSString stringWithFormat:@"|%@|", selected];
            if ([sku.key containsString:key]) {
                finds++;
            }
        }
        if (finds >= totalSelectedValues) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSKUChanged {
    NSInteger totalSelectedValues = _selectedVariantValues.count;
    if (totalSelectedValues < _variants.count) {
        return NO;
    }
    
    for (ProductVariantSKUModel *sku in _skus) {
        NSInteger finds = 0;
        for (NSString *selected in _selectedVariantValues) {
            NSString *key = [NSString stringWithFormat:@"|%@|", selected];
            if ([sku.key containsString:key]) {
                finds++;
            }
        }
        if (finds >= totalSelectedValues) {
            if ([sku.key isEqualToString:_key] == NO) {
                _key = sku.key;
                return YES;
            }
            return NO;
        }
    }
    return NO;
}

- (NSString *)stringifySelectedValues {
    // |100:101|200:201|300:301|
    return [NSString stringWithFormat:@"|%@|", [_selectedVariantValues componentsJoinedByString:@"|"]];
}

- (NSString *)selectedValueNames {
    if (_selectedVariantValues.count < 1) {
        return @"";
    }
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (VariantModel *variant in _variants) {
        for (VariantValueModel *value in variant.values) {
            if ([self isVariantValueSelectedForKey:value.key]) {
                [names addObject:value.name];
            }
        }
    }
    
    return names.count ? [names componentsJoinedByString:@" "] : @"";
}

- (NSInteger)selectedSKUProductId {
    if (_selectedVariantValues.count < _variants.count) {
        return 0;
    }
    
    for (ProductVariantSKUModel *sku in _skus) {
        if ([sku.key isEqualToString:_key]) {
            return sku.productId;
        }
    }
    return 0;
}
@end
