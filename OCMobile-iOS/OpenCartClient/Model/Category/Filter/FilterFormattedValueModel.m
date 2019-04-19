//
//  FilterFormattedValueModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterFormattedValueModel.h"

@implementation FilterFormattedValueModel

- (instancetype)initWithName:(NSString *)name image:(NSString *)image stringValue:(NSString *)value {
    self = [super init];
    if (self) {
        self.name = name;
        self.image = image;
        self.value = value;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name image:(NSString *)image intValue:(NSInteger)value {
    NSString *stringValue = [NSString stringWithFormat:@"%ld", (long)value];
    self = [self initWithName:name image:image stringValue:stringValue];
    return self;
}

@end
