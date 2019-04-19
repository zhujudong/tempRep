//
//  ProductReviewReviewCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductReviewItemModel.h"

#define kCellIdentifier_ProductReviewReviewItemCell @"ProductReviewReviewItemCell"

@interface ProductReviewReviewCell : UITableViewCell
@property (strong, nonatomic) ProductReviewItemModel *review;

@end
