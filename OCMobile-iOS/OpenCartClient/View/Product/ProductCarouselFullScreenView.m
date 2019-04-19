//
//  ProductCarouselFullScreenView.m
//  OpenCartClient
//
//  Created by Sam Chen on 27/07/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "ProductCarouselFullScreenView.h"
#import <Photos/Photos.h>

static NSInteger const VIEW_FOR_ZOOM_TAG = 1;

@interface ProductCarouselFullScreenView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation ProductCarouselFullScreenView

- (id)initWithFrame:(CGRect)frame {
    if (CGRectIsEmpty(frame)) {
        frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }

    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0;

        if (!_scrollView) {
            _scrollView = [[UIScrollView alloc] initWithFrame:frame];
            _scrollView.pagingEnabled = YES;
            _scrollView.backgroundColor = [UIColor whiteColor];
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.delegate = self;
            [self addSubview:_scrollView];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
            [_scrollView addGestureRecognizer:singleTap];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
            [_scrollView addGestureRecognizer:longPress];
        }
    }

    return self;
}

- (void)createImageViews {
    if (!_images.count) {
        return;
    }

    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSInteger i = 0;
    for (NSString *image in _images) {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        imageScrollView.maximumZoomScale = 3.0f;
        imageScrollView.minimumZoomScale = 1.0f;
        imageScrollView.zoomScale = 1.0f;
        imageScrollView.contentSize = imageScrollView.bounds.size;
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.delegate = self;

        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        imageScrollView.frame = frame;
        [_scrollView addSubview:imageScrollView];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.tag = VIEW_FOR_ZOOM_TAG;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [imageView lazyLoad:image];
        i++;
    }

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * i, _scrollView.frame.size.width);
}

- (void)setImages:(NSArray *)images {
    _images = images;
}

- (void)show: (UIViewController *)viewController {
    [self createImageViews];
    [viewController.navigationController.view addSubview:self];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)dismiss:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)longPressed: (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:@"将图片保存至您的图片库" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveImageToDisk];
        }];
        [alert addAction:ok];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];

        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)saveImageToDisk {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            UIImage *image = [_images objectAtIndex:0];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSaved), nil);
        } else {
            [MBProgressHUD showToastToView:self withMessage:@"没有权限保存图片"];
        }
    }];
}

- (void)imageSaved {
    [MBProgressHUD showToastToView:self withMessage:@"图片已保存"];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:VIEW_FOR_ZOOM_TAG];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self.debugDescription);
}
@end
