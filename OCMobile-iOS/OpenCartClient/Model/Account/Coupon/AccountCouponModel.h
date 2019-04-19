//
//  AccountCouponModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountCouponModel
@end

@interface AccountCouponModel : JSONModel

@property(nonatomic) NSInteger couponId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *type;
@property(nonatomic) float discount;
@property(nonatomic) float total;
@property(nonatomic) NSString *dateStart;
@property(nonatomic) NSString *dateEnd;

@end
