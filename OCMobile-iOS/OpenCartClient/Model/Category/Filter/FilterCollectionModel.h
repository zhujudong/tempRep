//
//  FilterCollectionModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "JSONModel.h"
#import "FilterBrandModel.h"
#import "FilterStockStatusModel.h"
#import "FilterAttributeModel.h"
#import "FilterOptionModel.h"
#import "FilterVariantModel.h"

typedef NS_ENUM(NSUInteger, FilterType) {
    FilterTypeStockStatus,
    FilterTypeBrand,
    FilterTypeAttribute,
    FilterTypeOption,
    FilterTypeVariant,
    FilterTypeUnknown,
};

@interface FilterCollectionModel : JSONModel

@property (nonatomic) NSArray<FilterStockStatusModel> *stockStatus;
@property (nonatomic) NSArray<FilterBrandModel> *brands;
@property (nonatomic) NSArray<FilterAttributeModel> *attributes;
@property (nonatomic) NSArray<FilterOptionModel> *options;
@property (nonatomic) NSArray<FilterVariantModel> *variants;

// CollectionView sections
- (NSInteger)sections;
- (NSInteger)numberOfItemsInSection: (NSInteger)section;
- (NSString *)sectionName: (NSInteger)section;
- (NSString *)sectionValueNameAtIndexPath: (NSIndexPath *)indexPath;
- (BOOL)selectValueAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isValueSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)totalSelectedValuesInSection:(NSInteger)section;
- (NSDictionary *)formatAllSelectedFilterValuesToDict;
@end
