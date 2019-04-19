//
//  AccountOrderListHeaderCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/16/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderListOrderItemModel.h"

#define kCellIdentifier_AccountOrderListHeaderCell @"AccountOrderListHeaderCell"

@interface AccountOrderListHeaderCell : UITableViewCell
@property (strong, nonatomic) AccountOrderListOrderItemModel *order;
@end
