//
//  VariantValueModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol VariantValueModel;

@interface VariantValueModel : JSONModel

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString<Optional> *key;

@end
