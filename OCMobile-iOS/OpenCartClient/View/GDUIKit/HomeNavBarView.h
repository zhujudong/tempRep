//
//  HomeNavBarView.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/13.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNavBarView : UIView

@property (copy, nonatomic) void(^leftButtonClickedBlock)(void);
@property (copy, nonatomic) void(^rightButtonClickedBlock)(void);
@property (copy, nonatomic) void(^searchButtonClickedBlock)(void);

- (void)scrollViewDidScrollToOffsetY:(CGFloat)offsetY;

+ (CGFloat)navBarHeight;
@end
