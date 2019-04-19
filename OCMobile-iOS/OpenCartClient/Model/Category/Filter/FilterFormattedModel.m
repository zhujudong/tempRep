//
//  FilterCollectionViewSectionModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterFormattedModel.h"

@interface FilterFormattedModel()
@property (strong, nonatomic) NSMutableArray *selectedValues;
@end

@implementation FilterFormattedModel

- (instancetype)initWithName: (NSString *)name andValues:(NSArray *)values forType:(FilterType)type {
    self = [super init];
    
    self.type = type;
    self.name = name;
    self.values = values;
    self.selectedValues = [[NSMutableArray alloc] init];
    
    return self;
}

- (NSString *)valueNameAtIndex:(NSInteger)index {
    FilterFormattedValueModel *value = [_values objectAtIndex:index];
    return value.name;
}

- (BOOL)selectValueAtIndexPath:(NSInteger)index {
    FilterFormattedValueModel *value = [_values objectAtIndex:index];
    if ([_selectedValues containsObject:value.value]) {
        [_selectedValues removeObject:value.value];
        return NO;
    }
    
    [_selectedValues addObject:value.value];
    return YES;
}

- (BOOL)isValueSelectedAtIndexPath:(NSInteger)index {
    FilterFormattedValueModel *value = [_values objectAtIndex:index];
    return [_selectedValues containsObject:value.value];
}

- (NSInteger)totalSelectedValues {
    return _selectedValues.count;
}

- (NSString *)stringifySelectedValues {
    if (!_selectedValues.count) {
        return nil;
    }
    
    // Join values by |
    return [_selectedValues componentsJoinedByString:@"|"];
}

- (NSString *)convertTypeNameToString {
    if (_type == FilterTypeBrand) {
        return @"manufacturer";
    }
    
    if (_type == FilterTypeAttribute) {
        return @"attribute";
    }
    
    if (_type == FilterTypeOption) {
        return @"option";
    }
    
    if (_type == FilterTypeVariant) {
        return @"variant";
    }
    
    return @"unknown";
}
@end
