//
//  CategoryAllFlatStyleFirstCell.h
//  YITAYO
//
//  Created by Sam Chen on 24/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryFirstLevelItemModel.h"

#define kCellIdentifier_CategoryAllFlatStyleFirstCell @"CategoryAllFlatStyleFirstCell"

@interface CategoryAllFlatStyleFirstCell : UICollectionViewCell

@property (strong, nonatomic) CategoryFirstLevelItemModel *category;
@end
