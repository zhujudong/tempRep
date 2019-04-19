//
//  CategoryFirstLevelItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CategoryFirstLevelItemModel
@end

@interface CategoryFirstLevelItemModel : JSONModel

@property (nonatomic) NSInteger categoryId;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *originalImage;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray<Optional> *children;

@end
