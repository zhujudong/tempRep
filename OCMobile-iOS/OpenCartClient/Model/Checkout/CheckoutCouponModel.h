//
//  CheckoutCouponModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CheckoutCouponModel
@end

@interface CheckoutCouponModel : JSONModel

@property(nonatomic) NSInteger couponId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *code;
@property(nonatomic) NSString *type;
@property(nonatomic) float discount;
@property(nonatomic) float total;
@property(nonatomic) NSString *dateStart;
@property(nonatomic) NSString *dateEnd;

@end
