//
//  CartProductItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 17/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIQuantityControl.h"
#import "CartProductItemModel.h"

@interface CartProductItemCell : UITableViewCell <UIQuantityControlDelegate>

@property (strong, nonatomic) CartProductItemModel *product;
@property (copy, nonatomic) void(^productSelectChangedBlock)(BOOL);
@property (copy, nonatomic) void(^quantityChangedBlock)(NSInteger);

+ (NSString *)identifier;
- (void)setProductSelected: (BOOL) selected;

@end
