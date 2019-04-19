//
//  ProductGridModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductGridItemModel.h"

@interface ProductGridModel : JSONModel

//@property(nonatomic) NSInteger categoryId;
@property(nonatomic) NSInteger currentPage;
@property(nonatomic) NSInteger lastPage;
@property(nonatomic) NSMutableArray<ProductGridItemModel> *products;

@end
