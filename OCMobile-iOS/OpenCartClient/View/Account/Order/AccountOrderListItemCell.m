//
//  AccountOrderListItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/16/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListItemCell.h"

static CGFloat const IMAGE_WIDTH = 80.0;
static CGFloat const IMAGE_SPACING = 10.0;

@interface AccountOrderListItemCell()
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation AccountOrderListItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsZero;

        if (!_scrollView) {
            _scrollView = [UIScrollView new];
            _scrollView.showsHorizontalScrollIndicator = NO;

            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewClicked)];
            gesture.numberOfTapsRequired = 1;
            [_scrollView addGestureRecognizer:gesture];

            [self.contentView addSubview:_scrollView];
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(IMAGE_WIDTH + IMAGE_SPACING * 2).priorityHigh();
                make.edges.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setProducts:(NSArray *)products {
    _products = products;

    for (UIView *subview in _scrollView.subviews) {
        [subview removeFromSuperview];
    }

    _scrollView.contentSize = CGSizeMake(_products.count * (IMAGE_WIDTH + IMAGE_SPACING), IMAGE_WIDTH);

    _scrollView.contentInset = UIEdgeInsetsMake(IMAGE_SPACING, IMAGE_SPACING, IMAGE_SPACING, 0);

    NSInteger productIndex = 0;

    for (AccountOrderListProductItemModel *product in _products) {
        CGRect frame = CGRectMake(productIndex * (IMAGE_WIDTH + IMAGE_SPACING), 0, IMAGE_WIDTH, IMAGE_WIDTH);

        UIImageView *productImageView = [[UIImageView alloc] initWithFrame:frame];
        [productImageView lazyLoad:product.image];
        [_scrollView addSubview:productImageView];

        productIndex++;
    }
}

- (void)scrollViewClicked {
    if (_orderClickedBlock) {
        _orderClickedBlock();
    }
}

@end
