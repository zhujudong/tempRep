//
//  ProductRelatedCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 31/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductRelatedProductItemModel.h"

#define kCellIdentifier_ProductRelatedCell @"ProductRelatedCell"

@interface ProductRelatedCell : UITableViewCell

@property (strong, nonatomic) NSArray<ProductRelatedProductItemModel> *products;
@property (copy, nonatomic) void(^relatedProductClickedBlock)(NSInteger);

@end
