//
//  CheckoutAddressEmptyCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/1/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CheckoutAddressEmptyCell @"CheckoutAddressEmptyCell"

@interface CheckoutAddressEmptyCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *bottomSepImageView;

@end
