//
//  AccountOrderListShippedActionCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/26/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderListOrderItemModel.h"

#define kCellIdentifier_AccountOrderListShippedActionCell @"AccountOrderListShippedActionCell"

@interface AccountOrderListShippedActionCell : UITableViewCell
@property (strong, nonatomic) AccountOrderListOrderItemModel *order;

@property (copy, nonatomic) void(^completeButtonClickedBlock)(NSString *);
@property (copy, nonatomic) void(^expressButtonClickedBlock)(NSString *);
@end
