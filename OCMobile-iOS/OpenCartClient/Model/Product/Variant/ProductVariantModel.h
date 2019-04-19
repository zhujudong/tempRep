//
//  ProductVariantModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "VariantModel.h"
#import "ProductVariantSKUModel.h"
#import "ProductVariantSKUCurrentModel.h"

@protocol ProductVariantModel;

@interface ProductVariantModel : JSONModel

@property (nonatomic) NSString *key;
@property (nonatomic) NSArray<VariantModel> *variants;
@property (nonatomic) NSArray<ProductVariantSKUModel> *skus;
@property (nonatomic) NSArray<ProductVariantSKUCurrentModel> *currentVariant;

- (VariantModel *)variantAtIndex:(NSInteger)index;
- (VariantValueModel *)variantValueAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isVariantValueSelectedForKey:(NSString *)key;
- (BOOL)isVariantValueSelectableForKey:(NSString *)key;
- (BOOL)toggleVariantValueSelectionForKey:(NSString *)key;
- (NSString *)selectedValueNames;
- (BOOL)isSKUChanged;
- (NSInteger)selectedSKUProductId;
@end
