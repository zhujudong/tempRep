//
//  ProductDetailModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductDetailImageItemModel.h"
#import "ProductReviewItemModel.h"
#import "ProductDetailOptionModel.h"
#import "ProductRelatedProductItemModel.h"
#import "ProductVariantModel.h"

@protocol ProductDetailModel;
@interface ProductDetailModel : JSONModel

@property(nonatomic) NSInteger productId;
@property(nonatomic) NSString *image;
@property(nonatomic) NSArray<ProductDetailImageItemModel> *images;
@property(nonatomic) NSString *name;
@property(nonatomic) NSNumber<Optional> *special;
@property(nonatomic) NSNumber *price;
@property(nonatomic) NSString *specialFormat;
@property(nonatomic) NSString *priceFormat;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) NSInteger viewed;
@property(nonatomic) NSInteger points;
@property(nonatomic) NSInteger minimum;
//@property(nonatomic) NSString *stockStatus;
@property (nonatomic) ProductVariantModel *variant;
@property(nonatomic) NSArray<ProductDetailOptionModel> *options;
@property(nonatomic) NSArray<ProductReviewItemModel> *reviews;
@property(nonatomic) bool addedWishlist;
@property(nonatomic) NSArray<ProductRelatedProductItemModel> *relatedProducts;
@property(nonatomic) NSString *trackingUrl;

- (NSInteger)selectedQuantity;
- (void)setSelectedQuantity:(NSInteger)selectedQuantity;

/// Merge `image` & `images` into an array
- (NSArray *)allImages;

- (NSInteger)totalOptionsAndVariantGroups;

/// Check if the product has `Option` or `Variant'
- (BOOL)hasProductOptionOrVariant;
- (NSInteger)numberOfItemsInOptionOrVariantGroup:(NSInteger)section;
- (VariantValueModel *)variantValueAtIndexPath:(NSIndexPath *)indexPath;
- (void)toggleOptionSelectionAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isOptionValueSelected:(ProductDetailOptionValueModel*)optionValue forOption:(ProductDetailOptionModel*)option;
- (NSString *)textForOptionCell;
- (NSString *)stringifySelectedOptionValues;
@end
