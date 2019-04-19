//
//  AccountOrderListPendingActionCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderListOrderItemModel.h"

#define kCellIdentifier_AccountOrderListPendingActionCell @"AccountOrderListPendingActionCell"

@interface AccountOrderListPendingActionCell : UITableViewCell
@property (strong, nonatomic) AccountOrderListOrderItemModel *order;

@property (copy, nonatomic) void(^cancelButtonClickedBlock)(NSString *);
@property (copy, nonatomic) void(^payButtonClickedBlock)(NSString *);
@end
