//
//  UIImageView+LazyLoad.h
//  Orioner-iOS
//
//  Created by Sam Chen on 13/10/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LazyLoad)
- (void)lazyLoad:(NSString *)imageUrl;
@end
