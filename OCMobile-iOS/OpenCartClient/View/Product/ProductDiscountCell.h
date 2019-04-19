//
//  ProductDiscountCell.h
//  iWant Mall
//
//  Created by Sam Chen on 20/03/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

#define kCellIdentifier_ProductDiscountCell @"ProductDiscountCell"

@interface ProductDiscountCell : UITableViewCell

@property (strong, nonatomic) ProductDetailModel *product;

@end
