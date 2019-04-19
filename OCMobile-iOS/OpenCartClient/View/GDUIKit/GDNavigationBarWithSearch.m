//
//  GDNavigationBarWithSearch.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

// 不包含 Status Bar 在内的带搜索按钮的 Navigation Bar

#import "GDNavigationBarWithSearch.h"

//CGFloat STATUSBAR_HEIGHT = 20.;

@implementation GDNavigationBarWithSearch

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.backgroundColor = [UIColor whiteColor];

    //底部边线
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - .5, frame.size.width, .5)];
    sep.backgroundColor = [UIColor colorWithHexString:@"aaaaac" alpha:1.];
    [self addSubview:sep];

    //  self.layer.masksToBounds = NO;
    //  self.layer.shadowOffset = CGSizeMake(0, .5);
    //  self.layer.shadowOpacity = 1.;

    //左侧返回按钮
    CGFloat backButtonWidth = frame.size.width * 0.1;
    CGFloat backButtonHeight = (frame.size.height) * 0.7;
    CGFloat backButtonX = 0;
    CGFloat backButtonY = ((frame.size.height - backButtonHeight) * 0.5);

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonX, backButtonY, backButtonWidth, backButtonHeight)];
    backButton.tag = 100;

    //  UIImage *backButtonImage = [[UIImage imageNamed:@"back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //  [backButton setImage:backButtonImage forState:UIControlStateNormal];

    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];

    CGFloat backButtonImageInsectTop = (backButton.frame.size.height - 16.) * 0.5;
    CGFloat backButtonImageInsectLeft = (backButton.frame.size.width - 16.) * 0.5;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(backButtonImageInsectTop, backButtonImageInsectLeft, backButtonImageInsectTop, backButtonImageInsectLeft);
    //  backButton.tintColor = [UIColor whiteColor];
    [self addSubview:backButton];

    //搜索条
    CGFloat searchBarViewWidth = frame.size.width * 0.8;
    CGFloat searchBarViewHeight = (frame.size.height) * 0.7;
    CGFloat searchBarViewX = (frame.size.width - searchBarViewWidth) * 0.5;
    CGFloat searchBarViewY = ((frame.size.height - searchBarViewHeight) * 0.5);

    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(searchBarViewX, searchBarViewY, searchBarViewWidth, searchBarViewHeight)];

    searchButton.tag = 200;

    searchButton.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:0.7];
    searchButton.layer.cornerRadius = 4.0;
    searchButton.clipsToBounds = YES;
    [searchButton setTitle:NSLocalizedString(@"text_search_placeholder", nil) forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [searchButton setTitleColor:[UIColor colorWithHexString:@"808080" alpha:1.] forState:UIControlStateNormal];
    //  [searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //  searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, (searchBarViewWidth * -0.5) - 30.0, 0, 0);

    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    //  searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, searchBarViewWidth - searchButton.imageView.frame.size.width - 10, 0, 0);

    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);

    searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    [searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    //  [searchButton addTarget:self action:@selector(selectSearchTab) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:searchButton];

    //右侧购物车按钮
    //  CGFloat cartButtonWidth = self.view.frame.size.width * 0.1;
    //  CGFloat cartButtonHeight = (NAVGATION_BAR_H - 20.) * 0.7;
    //  CGFloat cartButtonX = searchButton.frame.origin.x + searchButton.frame.size.width;
    //  CGFloat cartButtonY = 20. + ((NAVGATION_BAR_H - 20. - cartButtonHeight) * 0.5);
    //
    //  UIButton *cartButton = [[UIButton alloc] initWithFrame:CGRectMake(cartButtonX, cartButtonY, cartButtonWidth, cartButtonHeight)];
    //  cartButton.tag = 300;
    //
    //  UIImage *cartButtonImage = [[UIImage imageNamed:@"nav_cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //  [cartButton setImage:cartButtonImage forState:UIControlStateNormal];
    //
    //  CGFloat cartButtonImageInsectTop = (cartButton.frame.size.height - 16.) * 0.5;
    //  CGFloat cartButtonImageInsectLeft = (cartButton.frame.size.width - 16.) * 0.5;
    //  cartButton.imageEdgeInsets = UIEdgeInsetsMake(cartButtonImageInsectTop, cartButtonImageInsectLeft, cartButtonImageInsectTop, cartButtonImageInsectLeft);
    //  cartButton.tintColor = [UIColor whiteColor];
    //
    //  [cartButton addTarget:self action:@selector(selectCartTab) forControlEvents:UIControlEventTouchUpInside];
    //
    //  [self addSubview:cartButton];

    return self;
}

@end
