//
//  AccountOrderExpressInfoCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderExpressModel.h"

#define kCellIdentifier_AccountOrderExpressInfoCell @"AccountOrderExpressInfoCell"

@interface AccountOrderExpressInfoCell : UITableViewCell

@property (strong, nonatomic) AccountOrderExpressModel *expressModel;

@end
