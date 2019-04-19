//
//  CallingCodeModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 2019/3/4.
//  Copyright © 2019 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CallingCodeModel
@end

@interface CallingCodeModel : JSONModel
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *code;
@end

NS_ASSUME_NONNULL_END
