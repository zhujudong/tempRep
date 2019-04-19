//
//  UIOrderTypeButton.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "UIOrderTypeButton.h"

@interface UIOrderTypeButton()
@property (strong, nonatomic) UIView *redDotView;
@end

@implementation UIOrderTypeButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Red dot
        if (!_redDotView) {
            _redDotView = [UIView new];
            _redDotView.backgroundColor = CONFIG_PRIMARY_COLOR;
            _redDotView.layer.cornerRadius = 4.0;
            _redDotView.clipsToBounds = YES;
            _redDotView.hidden = YES;
            [self addSubview:_redDotView];
        }
        
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitleColor:[UIColor colorWithHexString:@"686868" alpha:1.] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width) / 2.;
    imageFrame.origin.y = (self.bounds.size.height - (imageFrame.size.height + 10 + titleFrame.size.height)) / 2;
    
    self.imageView.frame = imageFrame;
    
    titleFrame.origin.x = (self.bounds.size.width - titleFrame.size.width) / 2.;
    titleFrame.origin.y = imageFrame.origin.y + imageFrame.size.height + 10;
    
    self.titleLabel.frame = titleFrame;
}

- (void)updateConstraints {
    if (_redDotView) {
        [_redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(8);
            make.top.equalTo(self.imageView.mas_top);
            make.trailing.equalTo(self.imageView.mas_trailing).offset(2);
        }];
    }
    
    [super updateConstraints];
}

- (void)setRedDotHidden: (BOOL)hidden {
    [self.redDotView setHidden:hidden];
}

- (void)setAssetKey:(NSString *)key {
    NSString *imageKey = key;
    NSString *titleKey = [NSString stringWithFormat:@"text_order_status_%@", key];
    
    [self setImage:[UIImage imageNamed:imageKey] forState:UIControlStateNormal];
    [self setTitle:NSLocalizedString(titleKey, nil) forState:UIControlStateNormal];
}

@end
