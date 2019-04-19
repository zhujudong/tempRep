//
//  AccountReturnListItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountReturnListItemModel.h"
#define kCellIdentifier_AccountReturnListItemCell @"AccountReturnListItemCell"

@interface AccountReturnListItemCell : UITableViewCell
@property (strong, nonatomic) AccountReturnListItemModel *returnModel;
@end
