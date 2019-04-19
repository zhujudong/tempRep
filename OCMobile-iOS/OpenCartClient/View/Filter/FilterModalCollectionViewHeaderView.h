//
//  FilterModalCollectionViewHeaderView.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/5/31.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterModalCollectionViewHeaderView : UICollectionReusableView

@property (assign, nonatomic) NSInteger sectionIndex;
@property (copy, nonatomic) void(^headerViewClickedBlock)(NSInteger sectionIndex);
@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL showAllButton;

+ (NSString *)identifier;

@end
