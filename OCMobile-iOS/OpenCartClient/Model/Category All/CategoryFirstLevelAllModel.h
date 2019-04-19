//
//  CategoryFirstLevelAllModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CategoryFirstLevelItemModel.h"

@interface CategoryFirstLevelAllModel : JSONModel

//@property (nonatomic) NSInteger level;
@property (nonatomic) NSArray<CategoryFirstLevelItemModel> *categories;

@end
