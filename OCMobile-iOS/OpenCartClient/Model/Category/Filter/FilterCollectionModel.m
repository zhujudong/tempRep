//
//  FilterCollectionModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterCollectionModel.h"
#import "FilterFormattedModel.h"

@interface FilterCollectionModel() {
    NSMutableArray *_collectionViewSections;
}
@end

@implementation FilterCollectionModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"stockStatus": @"stock_status",
                                                                  @"brands": @"manufacturers",
                                                                  @"attributes": @"attributes",
                                                                  @"options": @"options",
                                                                  @"variants": @"variants"
                                                                  }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        [self makeCollectionViewModel];
    }
    return self;
}

- (void)makeCollectionViewModel {
    _collectionViewSections = [[NSMutableArray alloc] init];
    
//    if (_stockStatus) {
//        NSMutableArray *values = [[NSMutableArray alloc] init];
//        for (FilterStockStatusModel *item in _stockStatus) {
//            FilterFormattedValueModel *value = [[FilterFormattedValueModel alloc] initWithName:item.name image:nil intValue:item.id];
//            [values addObject:value];
//        }
//        FilterFormattedModel *section = [[FilterFormattedModel alloc] initWithName:@"库存状态" andValues:values forType:FilterTypeStockStatus];
//        [_collectionViewSections addObject:section];
//    }
    
    if (_brands) {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        for (FilterBrandModel *item in _brands) {
            FilterFormattedValueModel *value = [[FilterFormattedValueModel alloc] initWithName:item.name image:item.image intValue:item.id];
            [values addObject:value];
        }
        FilterFormattedModel *section = [[FilterFormattedModel alloc] initWithName:NSLocalizedString(@"label_brand", nil) andValues:values forType:FilterTypeBrand];
        [_collectionViewSections addObject:section];
    }
    
    if (_attributes) {
        for (FilterAttributeModel *attribute in _attributes) {
            NSMutableArray *formattedValues = [[NSMutableArray alloc] init];
            for (NSString *value in attribute.values) {
                FilterFormattedValueModel *formattedValue = [[FilterFormattedValueModel alloc] initWithName:value image:nil stringValue:[NSString stringWithFormat:@"%ld:%@", (long)attribute.id, value]];
                [formattedValues addObject:formattedValue];
            }
            FilterFormattedModel *section = [[FilterFormattedModel alloc] initWithName:attribute.name andValues:formattedValues forType:FilterTypeAttribute];
            [_collectionViewSections addObject:section];
        }
    }
    
    if (_options) {
        for (FilterOptionModel *option in _options) {
            NSMutableArray *values = [[NSMutableArray alloc] init];
            for (FilterOptionValueModel *value in option.values) {
                FilterFormattedValueModel *formattedValue = [[FilterFormattedValueModel alloc] initWithName:value.name image:nil intValue:value.id];
                [values addObject:formattedValue];
            }
            FilterFormattedModel *section = [[FilterFormattedModel alloc] initWithName:option.name andValues:values forType:FilterTypeOption];
            [_collectionViewSections addObject:section];
        }
    }
    
    if (_variants) {
        for (FilterVariantModel *variant in _variants) {
            NSMutableArray *values = [[NSMutableArray alloc] init];
            for (FilterOptionValueModel *value in variant.values) {
                FilterFormattedValueModel *formattedValue = [[FilterFormattedValueModel alloc] initWithName:value.name image:nil intValue:value.id];
                [values addObject:formattedValue];
            }
            FilterFormattedModel *section = [[FilterFormattedModel alloc] initWithName:variant.name andValues:values forType:FilterTypeVariant];
            [_collectionViewSections addObject:section];
        }
    }
}

- (NSInteger)sections {
    return _collectionViewSections.count;
}

- (NSInteger)numberOfItemsInSection: (NSInteger)section {
    FilterFormattedModel *sectionModel = [_collectionViewSections objectAtIndex:section];
    return sectionModel.values.count;
}

- (NSString *)sectionName: (NSInteger)section {
    FilterFormattedModel *sectionModel = [_collectionViewSections objectAtIndex:section];
    return sectionModel.name;
}

- (NSString *)sectionValueNameAtIndexPath: (NSIndexPath *)indexPath {
    FilterFormattedModel *sectionModel = [_collectionViewSections objectAtIndex:indexPath.section];
    return [sectionModel valueNameAtIndex:indexPath.row];
}

- (BOOL)selectValueAtIndexPath:(NSIndexPath *)indexPath {
    FilterFormattedModel *filter = [_collectionViewSections objectAtIndex:indexPath.section];
    return [filter selectValueAtIndexPath:indexPath.row];
}

- (BOOL)isValueSelectedAtIndexPath:(NSIndexPath *)indexPath {
    FilterFormattedModel *filter = [_collectionViewSections objectAtIndex:indexPath.section];
    return [filter isValueSelectedAtIndexPath:indexPath.row];
}

- (NSInteger)totalSelectedValuesInSection:(NSInteger)section {
    FilterFormattedModel *filter = [_collectionViewSections objectAtIndex:section];
    return [filter totalSelectedValues];
}

- (NSDictionary *)formatAllSelectedFilterValuesToDict {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (FilterFormattedModel *filter in _collectionViewSections) {
        // Get stringified values: 3|4|5
        NSString *selectedValuesStringified = [filter stringifySelectedValues];
        if (selectedValuesStringified == nil) {
            continue;
        }
        
        // Add stringified values to dict
        NSString *typeAsString = [filter convertTypeNameToString];
        NSString *oldSelectedValueString = [dict objectForKey:typeAsString];
        if (oldSelectedValueString) {
            [dict setObject:[NSString stringWithFormat:@"%@|%@", oldSelectedValueString, selectedValuesStringified] forKey:typeAsString];
        } else {
            [dict setObject:selectedValuesStringified forKey:typeAsString];
        }
    }
    
    return dict.count ? dict : nil;
}

@end
