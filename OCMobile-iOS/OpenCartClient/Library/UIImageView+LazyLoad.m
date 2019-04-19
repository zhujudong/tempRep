//
//  UIImageView+LazyLoad.m
//  Orioner-iOS
//
//  Created by Sam Chen on 13/10/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "UIImageView+LazyLoad.h"

@implementation UIImageView (LazyLoad)

- (void)lazyLoad:(NSString *)imageUrl {
    [self sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
            placeholderImage:[UIImage imageNamed:@"placeholder"]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (image && cacheType == SDImageCacheTypeNone) {
                           self.alpha = 0.2;
                           [UIView animateWithDuration:CONFIG_IMAGE_FADE_IN_DURATION animations:^{
                               self.alpha = 1.0;
                           }];
                       }
                   }];
}

@end
