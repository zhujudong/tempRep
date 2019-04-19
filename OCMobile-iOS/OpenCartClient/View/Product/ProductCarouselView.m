//
//  ProductCarouselView.m
//  OpenCartClient
//
//  Created by Sam Chen on 15/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductCarouselView.h"
#import "ProductCarouselFullScreenView.h"
#import "UIImage+SoldOutImage.h"

static CGFloat const PAGE_LABEL_WIDTH = 40.0;

@interface ProductCarouselView()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *pageLabel;
@end

@implementation ProductCarouselView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;

        if (!_scrollView) {
            _scrollView = [[UIScrollView alloc] init];
            _scrollView.pagingEnabled = YES;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.delegate = self;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenMode:)];
            [singleTap setNumberOfTapsRequired:1];
            [_scrollView addGestureRecognizer:singleTap];
            [self addSubview:_scrollView];
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];

            [self initPlaceholderImage];
        }

        if (!_pageLabel) {
            _pageLabel = [UILabel new];
            _pageLabel.backgroundColor = [UIColor colorWithHexString:@"f7f7f7" alpha:.75];
            _pageLabel.textColor = [UIColor colorWithHexString:@"888888" alpha:.75];
            _pageLabel.textAlignment = NSTextAlignmentCenter;
            _pageLabel.layer.cornerRadius = PAGE_LABEL_WIDTH / 2;
            _pageLabel.clipsToBounds = YES;
            _pageLabel.font = [UIFont systemFontOfSize:12];
            _pageLabel.adjustsFontSizeToFitWidth = YES;
            _pageLabel.minimumScaleFactor = 0.5;

            _pageLabel.text = @"1/1";

            [self addSubview:_pageLabel];

            [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(PAGE_LABEL_WIDTH);
                make.trailing.and.bottom.equalTo(self).offset(-10);
            }];
        }
    }

    return self;
}

// Scroll up/down effect
- (void)setOffsetY:(CGFloat)value {
    CGRect frame = _scrollView.frame;
    frame.origin.y = value;
    _scrollView.frame = frame;
}

- (void)initPlaceholderImage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.width);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;

            imageView.frame = _scrollView.bounds;
            [_scrollView addSubview:imageView];

            [self updatePageNumber:1 for:1];
        });
    });
}

- (void)setProduct:(ProductDetailModel *)product {
    _product = product;
    NSArray *images = [_product allImages];
    if (images.count < 1) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

            NSInteger i = 0;

            for (NSString *image in images) {
                UIImageView *imageView = [[UIImageView alloc] init];

                imageView.contentMode = UIViewContentModeScaleAspectFit;

                [imageView sd_setImageWithURL:[NSURL URLWithString:[image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                             placeholderImage:[UIImage imageNamed:@"placeholder"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        if (!image) {
                                            return;
                                        }

                                        // Add a sold out label on top of image
                                        if (CONFIG_OUT_OF_STOCK_STAMP) {
                                            if (_product.quantity <= 0) {
                                                imageView.image = [image drawImageWithSoldOutOverlay:image];
                                            }
                                        }
                                    }];

                CGRect frame = _scrollView.frame;
                frame.origin.x = frame.size.width * i;
                frame.origin.y = 0;

                imageView.frame = frame;
                [_scrollView addSubview:imageView];

                i++;
            }

            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * i, _scrollView.frame.size.width);
            [self updatePageNumber:1 for:images.count];
        });
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndDecelerating");

    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self updatePageNumber:currentPage + 1 for:[_product allImages].count];
}

- (void)updatePageNumber:(NSInteger)newValue for:(NSInteger)total {
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)newValue, (long)total];
}

- (void)fullScreenMode:(UITapGestureRecognizer *)recognizer {
//    ProductCarouselFullScreenView *fullScreenView = [[ProductCarouselFullScreenView alloc] initWithFrame:CGRectZero];
//    fullScreenView.images = [_product allImages];
//    [fullScreenView show];
    if (self.fullScreenImagesBlock) {
        self.fullScreenImagesBlock();
    }
}
@end
