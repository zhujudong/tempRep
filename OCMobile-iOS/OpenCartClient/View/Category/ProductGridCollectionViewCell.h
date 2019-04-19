//
//  ProductGridCollectionViewCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductGridItemModel.h"
#import "GDStrikeThroughLabel.h"

#define kCellIdentifier_ProductGridCollectionViewCell @"ProductGridCollectionViewCell"

@interface ProductGridCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) ProductGridItemModel *product;

@end
