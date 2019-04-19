//
//  ServerSplashImageManager.m
//  OpenCartClient
//
//  Created by Sam Chen on 15/10/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "ServerSplashImageManager.h"
#import "CustomSplashImageView.h"
#import "SettingModel.h"

static CGFloat const IMAGE_EXPIRATION_SECONDS = 10.0;
static CGFloat const IMAGE_FADEOUT_SECONDS = 1.8;

@interface ServerSplashImageManager()
@property(strong, nonatomic) CustomSplashImageView *imageView;
@property (strong, nonatomic) SettingModel *setting;
@property(nonatomic) BOOL expired;
@end

@implementation ServerSplashImageManager

+ (ServerSplashImageManager *)sharedInstance {
    static ServerSplashImageManager *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[ServerSplashImageManager alloc] init];
    });
    
    return _sharedInstance;
}

- (void)startToLoadCustomLaunchImage {
    if (self.expired) {
        return;
    }
    
    // Set a timer for loading image, ie. 10 seconds. Image failing to be loaded in 10 sec will not be displayed
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:IMAGE_EXPIRATION_SECONDS target:weakSelf selector:@selector(forceExpired) userInfo:nil repeats:NO];
    [[Network sharedInstance] GET:@"settings" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (!data) {
            return;
        }
        
        weakSelf.setting = [[SettingModel alloc] initWithDictionary:data error:nil];
        
        if (!weakSelf.setting.splashImage) {
            NSLog(@"No custom splash image defined.");
            return;
        }
        
        if (weakSelf.setting.splashImage.length < 1) {
            NSLog(@"Custom splash image url empty.");
            return;
        }
        
        [weakSelf showImageView:weakSelf.setting.splashImage];
    }];
}

- (void)showImageView:(NSString *)imageUrl {
    NSLog(@"Load custom splash image...");
    if (self.expired) {
        return;
    }
    SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [sdManager loadImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        // Expired, not to display the image
        if (weakSelf.expired || !image) {
            return;
        }
        
        NSLog(@"Custom splash image loaded.");
        //      [self.window makeKeyAndVisible];
        
        weakSelf.imageView = [[CustomSplashImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.imageView];
        [weakSelf.imageView setImage:image];
        
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:weakSelf.imageView];
        
        NSLog(@"Display custom splash image.");
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.imageView.alpha = 1.;
        } completion:^(BOOL finished) {
            [NSTimer scheduledTimerWithTimeInterval:IMAGE_FADEOUT_SECONDS target:weakSelf selector:@selector(dismissImageView) userInfo:nil repeats:NO];
        }];
    }];
}

- (void)dismissImageView {
    NSLog(@"Dismiss custom splash image.");
    [UIView animateWithDuration:.3 animations:^{
        self.imageView.alpha = 0.;
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }];
}

- (void)forceExpired {
    self.expired = YES;
}

- (void)dealloc {
    NSLog(@"dealloced");
}
@end

