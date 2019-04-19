//
//  ProductCarouselFullScreenView.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/07/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCarouselFullScreenView : UIView
@property (strong, nonatomic) NSArray *images;
- (void)show: (UIViewController *)viewController;
@end
