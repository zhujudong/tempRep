//
//  CartModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CartModel.h"
@interface CartModel() {
    NSMutableArray *selectedCartIdsInEditMode;
}
@end

@implementation CartModel

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        selectedCartIdsInEditMode = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)isAllProductsSelectedForCheckout {
    for (CartProductItemModel *product in _products) {
        if (product.selected == NO) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)allSelectedCartIdsForCheckout {
    NSMutableArray *selectedCartIds = [[NSMutableArray alloc] init];
    for (CartProductItemModel *product in _products) {
        if (product.selected) {
            [selectedCartIds addObject:product.cartId];
        }
    }
    return selectedCartIds;
}

- (BOOL)isProductSelectedInEditMode:(NSString *)cartId {
    for (NSString *selectedCartId in selectedCartIdsInEditMode) {
        if ([selectedCartId isEqualToString:cartId]) {
            return YES;
        }
    }
    return NO;
}

- (void)toggleProductSelectionInEditMode:(NSString *)cartId {
    // Remove
    if ([selectedCartIdsInEditMode containsObject:cartId]) {
        [selectedCartIdsInEditMode removeObject:cartId];
        return;
    }

    // Add
    [selectedCartIdsInEditMode addObject:cartId];
}

- (BOOL)isAllProductsSelectedInEditMode {
    return selectedCartIdsInEditMode.count == _products.count;
}

- (void)makeAllProductsSelectedInEditMode {
    for (CartProductItemModel *product in _products) {
        [selectedCartIdsInEditMode addObject:product.cartId];
    }
}

- (NSArray *)allSelectedCartIdsInEditMode {
    return selectedCartIdsInEditMode;
}

- (void)removeAllProductsSelectedInEditMode {
    [selectedCartIdsInEditMode removeAllObjects];
}

@end
