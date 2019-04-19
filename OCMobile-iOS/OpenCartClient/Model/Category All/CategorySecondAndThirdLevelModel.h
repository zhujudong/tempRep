//
//  CategorySecondAndThirdLevelModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CategorySecondLevelItemModel.h"

@interface CategorySecondAndThirdLevelModel : JSONModel

@property (nonatomic) NSInteger categoryId;
@property (nonatomic) NSString *name;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString *originalImage;
@property (nonatomic) NSArray<CategorySecondLevelItemModel>* children;

@end
