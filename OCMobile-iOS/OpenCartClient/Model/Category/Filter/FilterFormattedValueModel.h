//
//  FilterFormattedValueModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterFormattedValueModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image;
@property (nonatomic) NSString *value;

- (instancetype)initWithName:(NSString *)name image:(NSString *)image stringValue:(NSString *)value;
- (instancetype)initWithName:(NSString *)name image:(NSString *)image intValue:(NSInteger)value;

@end

