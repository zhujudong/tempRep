//
//  AccountCouponCellStyle2.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/29/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountCouponModel.h"

#define kCellIdentifier_AccountCouponCellStyle2 @"AccountCouponCellStyle2"

@interface AccountCouponCellStyle2 : UITableViewCell
@property (strong, nonatomic) AccountCouponModel *coupon;
@end
