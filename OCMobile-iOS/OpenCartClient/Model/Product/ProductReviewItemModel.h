//
//  ProductReviewItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/15/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProductReviewItemModel
@end

@interface ProductReviewItemModel : JSONModel

@property(nonatomic) NSString *author;
@property(nonatomic) NSString *text;
@property(nonatomic) NSInteger rating;
@property(nonatomic) NSString *dateAdded;
@property(nonatomic) NSString<Optional> *customerAvatar;

@end
