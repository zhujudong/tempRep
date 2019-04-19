//
//  FilterCollectionViewSectionModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterCollectionModel.h"
#import "FilterFormattedValueModel.h"

@interface FilterFormattedModel : NSObject

@property (nonatomic) FilterType type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *values;

- (instancetype)initWithName: (NSString *)name andValues:(NSArray *)values forType:(FilterType)type;
- (NSString *)valueNameAtIndex:(NSInteger)index;
- (BOOL)selectValueAtIndexPath:(NSInteger)index;
- (BOOL)isValueSelectedAtIndexPath:(NSInteger)index;
- (NSInteger)totalSelectedValues;
- (NSString *)stringifySelectedValues;
- (NSString *)convertTypeNameToString;

@end
