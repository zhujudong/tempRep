//
//  ProductReviewListModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/25/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductReviewItemModel.h"

@interface ProductReviewListModel : JSONModel

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger lastPage;
@property (nonatomic) NSArray<ProductReviewItemModel> *reviews;

@end
