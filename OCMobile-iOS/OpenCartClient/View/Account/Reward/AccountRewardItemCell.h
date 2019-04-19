//
//  AccountRewardItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRewardHistoryModel.h"

#define kCellIdentifier_AccountRewardItemCell @"AccountRewardItemCell"

@interface AccountRewardItemCell : UITableViewCell
@property (strong, nonatomic) AccountRewardHistoryModel *reward;
@end
