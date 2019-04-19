//
//  FilterModalView.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/5/31.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCollectionModel.h"

@interface FilterModalView : UIView

@property (strong, nonatomic) FilterCollectionModel *filters;

@property (copy, nonatomic) void(^submitButtonClickedBlock)(void);

- (void)show;

@end
