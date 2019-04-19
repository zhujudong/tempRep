//
//  AccountOrderInfoSimpleCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderInfoTotalItemModel.h"

#define kCellIdentifier_AccountOrderInfoSimpleCell @"AccountOrderInfoSimpleCell"

@interface AccountOrderInfoSimpleCell : UITableViewCell
- (void)setTitle:(NSString *)title value:(NSString *)value;
@end
