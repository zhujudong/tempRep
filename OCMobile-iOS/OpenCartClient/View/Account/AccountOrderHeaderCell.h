//
//  AccountOrderHeaderCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_AccountOrderHeaderCell @"AccountOrderHeaderCell"

@interface AccountOrderHeaderCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel, *subTitleLabel;

@end
