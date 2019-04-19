//
//  CartProductItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CartProductItemModel
@end

@interface CartProductItemModel : JSONModel

@property(nonatomic) NSString *cartId;
@property(nonatomic) NSInteger productId;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString<Optional> *optionLabel;
@property(nonatomic) NSInteger minimum;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) BOOL selected;
//@property(nonatomic) NSInteger stock;
@property(nonatomic) float price;
@property(nonatomic) float subtotal;
@property(nonatomic) NSString *priceFormat;
@property(nonatomic) NSString *subtotalFormat;
@property(nonatomic) NSString *error;

@end
