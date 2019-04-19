//
//  AccountUnreviewedListCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountUnreviewedProductModel.h"

#define kCellIdentifier_AccountUnreviewedListCell @"AccountUnreviewedListCell"

@interface AccountUnreviewedListCell : UITableViewCell
@property (strong, nonatomic) AccountUnreviewedProductModel *product;
@end
