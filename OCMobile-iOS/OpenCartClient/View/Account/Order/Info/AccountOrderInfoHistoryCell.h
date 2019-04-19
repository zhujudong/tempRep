//
//  AccountOrderInfoHistoryCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderInfoHistoryItemModel.h"

#define kCellIdentifier_AccountOrderInfoHistoryCell @"AccountOrderInfoHistoryCell"

@interface AccountOrderInfoHistoryCell : UITableViewCell
@property (strong, nonatomic) AccountOrderInfoHistoryItemModel *history;
@end
