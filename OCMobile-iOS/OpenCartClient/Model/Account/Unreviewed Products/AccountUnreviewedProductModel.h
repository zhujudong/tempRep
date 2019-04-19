//
//  AccountUnreviewedProductModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountUnreviewedProductModel
@end

@interface AccountUnreviewedProductModel : JSONModel

@property(nonatomic) NSInteger orderProductId;
@property(nonatomic) NSString *orderId;
@property(nonatomic) NSInteger productId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *model;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString *priceFormat;

@end
