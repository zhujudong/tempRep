//
//  ProductReviewItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/15/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "ProductReviewItemModel.h"

#define kCellIdentifiler_ProductReviewItemCell @"ProductReviewItemCell"

@interface ProductReviewItemCell : UITableViewCell
@property (strong, nonatomic) ProductReviewItemModel *review;

@end
