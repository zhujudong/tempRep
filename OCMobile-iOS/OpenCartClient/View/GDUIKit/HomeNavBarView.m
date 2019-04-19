//
//  HomeNavBarView.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/13.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "HomeNavBarView.h"

@interface HomeNavBarView()
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) UIButton *searchButton, *leftButton, *rightButton;
@end

@implementation HomeNavBarView

+ (CGFloat)navBarHeight {
    CGFloat height = 64.0 + [[System sharedInstance] statusBarHeight];
    if ([[System sharedInstance] isiPhoneX] == NO) {
        return height;
    }
    return height + 10;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, .5);
        self.layer.shadowOpacity = 1.;

        // Top shadow image
        _shadowImageView = [[UIImageView alloc] init];
        UIImage *shadowImage = [UIImage imageNamed:@"nav_shadow_bg"];
        _shadowImageView.backgroundColor = [UIColor colorWithPatternImage:shadowImage];
        [self addSubview:_shadowImageView];
        [_shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.mas_equalTo(shadowImage.size.height);
        }];

        //Search button
        CGFloat searchBarViewWidth = SCREEN_WIDTH * 0.8;
        CGFloat searchBarViewHeight = 30.0;

        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.backgroundColor = [UIColor colorWithHexString:@"eeeeee" alpha:0.7];
        _searchButton.layer.cornerRadius = 4.0;
        _searchButton.clipsToBounds = YES;
        [_searchButton setTitle:NSLocalizedString(@"text_search_placeholder", nil) forState:UIControlStateNormal];
        [_searchButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, (searchBarViewWidth * -0.5) - 40.0, 0, 0);
        [_searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, searchBarViewWidth - 20, 0, 0);
        [_searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_searchButton];
        [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-6);
            make.size.mas_equalTo(CGSizeMake(searchBarViewWidth, searchBarViewHeight));
        }];

        // Left icon
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *categoryButtonImage = [[UIImage imageNamed:@"nav_cat"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_leftButton setImage:categoryButtonImage forState:UIControlStateNormal];
        _leftButton.tintColor = [UIColor whiteColor];
        //categoryButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_searchButton);
            make.leading.equalTo(self);
            make.trailing.equalTo(_searchButton.mas_leading);
        }];

        // Right icon
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *rightButtonImage = [[UIImage imageNamed:@"nav_cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_rightButton setImage:rightButtonImage forState:UIControlStateNormal];
        _rightButton.tintColor = [UIColor whiteColor];
        //cartButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_searchButton);
            make.leading.equalTo(_searchButton.mas_trailing);
            make.trailing.equalTo(self);
        }];

        // Right icon red dot
//        UIView *rightIconRedDot = [[UIView alloc] init];
//        rightIconRedDot.tag = 301;
//        rightIconRedDot.backgroundColor = [UIColor redColor];
//        rightIconRedDot.layer.cornerRadius = 4;
//        [rightButton clipsToBounds];
//        [_navBarView addSubview:rightIconRedDot];
//        [rightIconRedDot setHidden:YES];
//        [rightIconRedDot mas_makeConstraints:^(MASConstraintMaker *make) {
//            //make.trailing.equalTo(rightButton);
//            make.top.equalTo(rightButton);
//            make.centerX.equalTo(rightButton).offset(8);
//            make.size.mas_equalTo(CGSizeMake(8, 8)).priorityHigh();
//        }];
    }

    return self;
}

#pragma mark - Actions

- (void)searchButtonClicked {
    if (_searchButtonClickedBlock) {
        _searchButtonClickedBlock();
    }
}

- (void)leftButtonClicked {
    if (_leftButtonClickedBlock) {
        _leftButtonClickedBlock();
    }
}

- (void)rightButtonClicked {
    if (_rightButtonClickedBlock) {
        _rightButtonClickedBlock();
    }
}

#pragma mark - Scroll
- (void)scrollViewDidScrollToOffsetY:(CGFloat)offsetY {
    // Scroll up - Change nav bar background color
    if (offsetY >= -([[System sharedInstance] statusBarHeight])) {
        self.alpha = 1;
        CGFloat alpha = MIN(1, 1 - ((0 + [HomeNavBarView navBarHeight] - offsetY) / [HomeNavBarView navBarHeight]));

        self.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:alpha];
        self.layer.shadowColor = [UIColor colorWithHexString:@"EFEFEF" alpha:alpha].CGColor;

        if (alpha > .2) {
            _shadowImageView.alpha = 0;
            _leftButton.tintColor = [UIColor colorWithHexString:@"333333" alpha:1.];
            [_searchButton setTitleColor:[UIColor colorWithHexString:@"999999" alpha:1.] forState:UIControlStateNormal];
            _rightButton.tintColor = [UIColor colorWithHexString:@"333333" alpha:1.];
        } else {
            _shadowImageView.alpha = 1;
            _leftButton.tintColor = [UIColor whiteColor];
            [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _rightButton.tintColor = [UIColor whiteColor];
        }
    } else { // Scroll down - nav bar background clolor -> transparent
        _leftButton.tintColor = [UIColor whiteColor];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightButton.tintColor = [UIColor whiteColor];
        _shadowImageView.alpha = 1;

        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        }];
    }
}

@end
