//
//  CartTotalItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/29/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CartTotalItemCell @"CartTotalItemCell"

@interface CartTotalItemCell : UITableViewCell

@property (strong, nonatomic) UILabel *keyLabel, *valueLabel;

@end
