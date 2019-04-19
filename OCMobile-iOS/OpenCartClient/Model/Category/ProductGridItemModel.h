//
//  ProductGridItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProductGridItemModel
@end

@interface ProductGridItemModel : JSONModel

@property(nonatomic) NSInteger productId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *image;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) NSNumber<Optional> *special;
@property(nonatomic) NSNumber<Optional> *price;
@property(nonatomic) NSString *priceFormat;
@property(nonatomic) NSString *specialFormat;

@end
