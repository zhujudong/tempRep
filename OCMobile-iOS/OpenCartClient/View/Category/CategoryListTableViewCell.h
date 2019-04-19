//
//  CategoryListTableViewCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/24/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryFirstLevelItemModel.h"

#define kCellIdentifier_CategoryListTableViewCell @"CategoryListTableViewCell"

@interface CategoryListTableViewCell : UITableViewCell
@property (strong, nonatomic) CategoryFirstLevelItemModel *category;
@end
