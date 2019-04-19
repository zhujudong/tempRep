//
//  ProductFullScreenImageViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 2019/4/15.
//  Copyright © 2019 opencart.cn. All rights reserved.
//

#import "ProductFullScreenImageViewController.h"
#import <Photos/Photos.h>

static NSInteger const VIEW_FOR_ZOOM_TAG = 1;

@interface ProductFullScreenImageViewController()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (nonatomic) NSInteger imageIndex;
@end

@implementation ProductFullScreenImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor blackColor];

    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [_scrollView addGestureRecognizer:singleTap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [_scrollView addGestureRecognizer:longPress];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!_images.count) {
        return;
    }

    if (_imageViews != nil) {
        return;
    }

    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _imageViews = [[NSMutableArray alloc] init];

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
        [_imageViews addObject:imageView];
        i++;
    }

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * i, _scrollView.frame.size.width);
}

- (void)setImages:(NSArray *)images {
    _images = images;
}

- (void)dismiss:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } completion:^(BOOL finished) {

    }];
}

- (void)longPressed: (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"text_save_image", nil) message:NSLocalizedString(@"text_save_image_desc", nil) preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_save", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveImageToDisk];
        }];
        [alert addAction:ok];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:alert animated:YES completion:nil];
        } else { //if iPad
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:alert];
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
}

- (void)saveImageToDisk {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView *imageView = [_imageViews objectAtIndex:_imageIndex];
                    UIImage *image = [imageView image];
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedImage:Error:Context:), nil);
                });
            });
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_save_image_unauthorized", nil)];
                });
            });
        }
    }];
}

- (void)savedImage:(UIImage *)image Error:(NSError *)error Context:(void*)context {
    if (error) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_save_image_error", nil)];
    } else {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_save_image_success", nil)];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:VIEW_FOR_ZOOM_TAG];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        _imageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}
@end
