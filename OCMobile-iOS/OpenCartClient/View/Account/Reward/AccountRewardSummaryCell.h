//
//  AccountRewardSummaryCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_AccountRewardSummaryCell @"AccountRewardSummaryCell"

@interface AccountRewardSummaryCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *rewardTotalLabel;

@end
