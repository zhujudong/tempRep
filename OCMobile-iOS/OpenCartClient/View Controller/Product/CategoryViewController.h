//
//  CategoryViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StatusModel.h"
#import "ProductGridModel.h"
#import "ProductGridItemModel.h"

@interface CategoryViewController :BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic) NSInteger categoryId;
@property (assign, nonatomic) NSInteger brandId;
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *attribute;

@end
