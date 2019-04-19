//
//  ProductDetailModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductDetailModel.h"
#import "ProductDetailSelectedOptionModel.h"

@interface ProductDetailModel() {
    NSInteger _selectedQuantity;
    NSMutableArray *_selectedOptions;
}
@end

@implementation ProductDetailModel

+(JSONKeyMapper* ) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"productId": @"product_id",
                                                                  @"image": @"image",
                                                                  @"images": @"images",
                                                                  @"name": @"name",
                                                                  @"special": @"special",
                                                                  @"price": @"price",
                                                                  @"specialFormat": @"special_format",
                                                                  @"priceFormat": @"price_format",
                                                                  @"quantity": @"quantity",
                                                                  @"viewed": @"viewed",
                                                                  @"points": @"points",
                                                                  @"minimum": @"minimum",
                                                                  @"variant": @"variant_data",
                                                                  @"options": @"options",
                                                                  @"reviews": @"reviews",
                                                                  @"addedWishlist": @"added_wishlist",
                                                                  @"relatedProducts": @"related_products",
                                                                  @"trackingUrl": @"tracking_url",
                                                                  }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        // Override special price with flash sale price
        NSNumber *flashPrice = (NSNumber *)[dict objectForKey:@"flash_price"];
        if (flashPrice.floatValue > 0) {
            NSString *flashPriceFormat = [dict objectForKey:@"flash_price_format"];
            self.special = flashPrice;
            self.specialFormat = flashPriceFormat;
        }
        [self initSelectedOptions];
        [self initSelectedQuantity];
    }
    return self;
}

//- (void)setNameWithNSString:(NSString *)string {
//    if ([System isDebug]) {
//        _name = [NSString stringWithFormat:@"[%ld] %@", (long)self.productId, string];
//    } else {
//        _name = string;
//    }
//}

- (NSString *)name {
    if ([System isDebug]) {
        return [NSString stringWithFormat:@"[%ld] %@", (long)_productId, _name];
    }
    return _name;
}

- (NSArray *)allImages {
    NSMutableArray *images = [[NSMutableArray alloc] init];
    if (self.image.length > 0) {
        [images addObject:self.image];
    }

    for (ProductDetailImageItemModel *image in self.images) {
        if (image.image.length > 0) {
            [images addObject:image.image];
        }
    }

    return images;
}

- (NSInteger)selectedQuantity {
    if (_selectedQuantity < 1) {
        _selectedQuantity = _minimum;
    }
    return _selectedQuantity;
}

- (void)setSelectedQuantity:(NSInteger)selectedQuantity {
    if (selectedQuantity < _minimum) {
        _selectedQuantity = _minimum;
    } else {
        _selectedQuantity = selectedQuantity;
    }
}

/// Init to make the first option value selected for required options
- (void)initSelectedOptions {
    if (self.options.count < 1) {
        return;
    }

    _selectedOptions = [[NSMutableArray alloc] init];

    for (int i = 0; i < self.options.count; i++) {
        ProductDetailOptionModel *option = [self.options objectAtIndex:i];
        if (option.type == ProductOptionTypeRadio || option.type == ProductOptionTypeCheckbox) {
            ProductDetailSelectedOptionModel *selectedOption = [[ProductDetailSelectedOptionModel alloc] initWithOptionModel:option];
            // Make the first item selected by default if required
            if (option.required) {
                ProductDetailOptionValueModel *optionValue = [option.productOptionValue objectAtIndex:0];
                [selectedOption addSelectedOptionValue:optionValue];
            }

            [_selectedOptions addObject:selectedOption];
        }
    }
}

- (void)initSelectedQuantity {
    _selectedQuantity = _minimum;
}

- (NSInteger)totalOptionsAndVariantGroups {
    return _options.count + _variant.variants.count;
}

- (BOOL)hasProductOptionOrVariant {
    return self.options.count || self.variant.variants.count;
}

- (NSInteger)numberOfItemsInOptionOrVariantGroup:(NSInteger)section {
    if (_variant.variants.count && section < _variant.variants.count) {
        VariantModel *variant = [_variant.variants objectAtIndex:section];
        return variant.values.count;
    }
    
    section -= _variant.variants.count;
    
    ProductDetailOptionModel *option = [_options objectAtIndex:section];
    return option.productOptionValue.count;
}

- (VariantValueModel *)variantValueAtIndexPath:(NSIndexPath *)indexPath {
    VariantModel *variant = [_variant variantAtIndex:indexPath.section];
    VariantValueModel *value = [variant.values objectAtIndex:indexPath.row];
    return value;
}

- (void)toggleOptionSelectionAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailOptionModel *option = [_options objectAtIndex:indexPath.section];
    ProductDetailOptionValueModel *value = [option.productOptionValue objectAtIndex:indexPath.row];
    for (ProductDetailSelectedOptionModel *selected in _selectedOptions) {
        if (selected.productOptionId != option.productOptionId) {
            continue;
        }
        
        if ([selected containsValue:value]) {
            [selected removeSelectedOptionValue:value];
        } else {
            [selected addSelectedOptionValue:value];
        }
    }
}

- (BOOL)isOptionValueSelected:(ProductDetailOptionValueModel*)optionValue forOption:(ProductDetailOptionModel*)option {
    for (ProductDetailSelectedOptionModel *selected in _selectedOptions) {
        if (selected.productOptionId != option.productOptionId) {
            continue;
        }
        
        if ([selected containsValue:optionValue]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)textForOptionCell {
    NSString *selectedVariantNames = [_variant selectedValueNames];
    NSString *selectedOptionNames = [self allSelectedOptionValueNames];
    NSString *quantity = [NSString stringWithFormat:@"%lu件", (unsigned long)_selectedQuantity];
    
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    if (selectedVariantNames.length > 0) {
        [strings addObject:selectedVariantNames];
    }
    if (selectedOptionNames.length > 0) {
        [strings addObject:selectedOptionNames];
    }
    [strings addObject:quantity];
    return [strings componentsJoinedByString:@" "];
}

- (NSString *)allSelectedOptionValueNames {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (ProductDetailSelectedOptionModel *selected in _selectedOptions) {
        [names addObject:[selected allValueNames]];
    }
    return [names componentsJoinedByString:@" "];
}

- (NSString *)stringifySelectedOptionValues {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (ProductDetailSelectedOptionModel *option in _selectedOptions) {
        NSArray *selectedProductOptionIds = [option convertToArray];
        if (!selectedProductOptionIds) {
            continue;
        }
        NSString *key = [NSString stringWithFormat:@"%ld", (long)option.productOptionId];
        if (option.type == ProductOptionTypeRadio) {
            [dict setObject:[selectedProductOptionIds objectAtIndex:0] forKey:key];
        }
        if (option.type == ProductOptionTypeCheckbox) {
            [dict setObject:selectedProductOptionIds forKey:key];
        }
    }
    
    if (dict.count < 1) {
        return nil;
    }
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    if (json) {
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end
