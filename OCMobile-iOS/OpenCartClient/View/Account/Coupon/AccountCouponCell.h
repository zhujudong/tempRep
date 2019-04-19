//
//  AccountCouponCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountCouponModel.h"

#define kCellIdentifier_AccountCouponCell @"AccountCouponCell"

@interface AccountCouponCell : UITableViewCell

@property (strong, nonatomic) AccountCouponModel *coupon;
@end
