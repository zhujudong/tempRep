//
//  ProductCarouselView.h
//  OpenCartClient
//
//  Created by Sam Chen on 15/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

@interface ProductCarouselView : UIView <UIScrollViewDelegate>
@property (copy, nonatomic) void(^fullScreenImagesBlock)(void);
@property (strong, nonatomic) ProductDetailModel *product;

- (void)setOffsetY:(CGFloat)value;

@end
