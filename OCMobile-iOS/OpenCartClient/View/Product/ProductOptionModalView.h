//
//  ProductOptionModalView.h
//  OpenCartClient
//
//  Created by Sam Chen on 05/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

@interface ProductOptionModalView : UIView

@property (strong, nonatomic) ProductDetailModel *product;
@property (copy, nonatomic) void(^productOptionModalClosedBlock)(BOOL callAddToCartAPI);

- (void)show;
@end
