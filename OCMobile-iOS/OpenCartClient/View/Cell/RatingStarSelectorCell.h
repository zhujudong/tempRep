//
//  RatingStarSelectorCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/11/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

#define kCellIdentifier_RatingStarSelectorCell @"RatingStarSelectorCell"

@interface RatingStarSelectorCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) HCSStarRatingView *ratingView;

@property (copy, nonatomic) void(^ratingValueChangedBlock)(NSInteger);

@end
