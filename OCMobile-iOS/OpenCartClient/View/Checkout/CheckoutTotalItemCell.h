//
//  CheckoutTotalItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutTotalItemModel.h"

#define kCellIdentifier_CheckoutTotalItemCell @"CheckoutTotalItemCell"

@interface CheckoutTotalItemCell : UITableViewCell
@property (strong, nonatomic) CheckoutTotalItemModel *total;

- (void)setTitle:(NSString *)title withValue:(NSString *)value;
@end
