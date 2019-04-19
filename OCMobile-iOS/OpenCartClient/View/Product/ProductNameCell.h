//
//  ProductNameCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/13/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

#define kCellIdentifier_ProductNameCell @"ProductNameCell"

@interface ProductNameCell : UITableViewCell
@property (strong, nonatomic) ProductDetailModel *product;
@end
