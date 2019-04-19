//
//  CheckoutProductCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutProductItemModel.h"

#define kCellIdentifier_CheckoutProductCell @"CheckoutProductCell"

@interface CheckoutProductCell : UITableViewCell

@property (strong, nonatomic) CheckoutProductItemModel *product;

@end
