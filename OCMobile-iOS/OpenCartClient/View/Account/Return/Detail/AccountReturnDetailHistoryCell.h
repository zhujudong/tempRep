//
//  AccountReturnDetailHistoryCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountReturnInfoHistoryModel.h"

#define kCellIdentifier_AccountReturnDetailHistoryCell @"AccountReturnDetailHistoryCell"

@interface AccountReturnDetailHistoryCell : UITableViewCell
@property (strong, nonatomic) AccountReturnInfoHistoryModel *history;
@end
