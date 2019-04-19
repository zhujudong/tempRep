//
//  CheckoutProductItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CheckoutProductItemModel
@end

@interface CheckoutProductItemModel : JSONModel

@property(nonatomic) NSString *cartId;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString<Optional> *optionLabel;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) NSString *priceFormat;
@property(nonatomic) NSString *subtotalFormat;

@end
