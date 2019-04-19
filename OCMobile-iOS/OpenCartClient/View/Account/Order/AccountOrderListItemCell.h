//
//  AccountOrderListItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/16/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderListOrderItemModel.h"

#define kCellIdentifier_AccountOrderListItemCell @"AccountOrderListItemCell"

@interface AccountOrderListItemCell : UITableViewCell
@property (strong, nonatomic) NSArray *products;

@property (copy, nonatomic) void(^orderClickedBlock)(void);
@end
