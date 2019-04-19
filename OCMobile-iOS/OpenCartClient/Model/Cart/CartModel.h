//
//  CartModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CartProductItemModel.h"

@interface CartModel : JSONModel
@property(nonatomic) NSString<Optional> *error;
@property(nonatomic) NSMutableArray<CartProductItemModel> *products;
@property(nonatomic) NSString *totalPriceFormat;
@property(nonatomic) NSInteger totalQuantity;

- (BOOL)isAllProductsSelectedForCheckout;
- (NSArray *)allSelectedCartIdsForCheckout;

- (BOOL)isAllProductsSelectedInEditMode;
- (BOOL)isProductSelectedInEditMode:(NSString *)cartId;
- (void)toggleProductSelectionInEditMode:(NSString *)cartId;
- (void)makeAllProductsSelectedInEditMode;
- (NSArray *)allSelectedCartIdsInEditMode;
- (void)removeAllProductsSelectedInEditMode;
@end
