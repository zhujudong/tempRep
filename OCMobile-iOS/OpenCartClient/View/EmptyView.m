//
//  EmptyView.m
//  OpenCartClient
//
//  Created by Sam Chen on 5/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;

        if (!_iconImageView) {
            UIImage *emptyImage = [UIImage imageNamed:@"empty_icon"];
            _iconImageView = [[UIImageView alloc] initWithImage:emptyImage];
            _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_iconImageView];
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(CGRectGetHeight(self.bounds) * 0.2);
                make.centerX.equalTo(self);
            }];
        }

        if (!_textLabel) {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _textLabel.text = NSLocalizedString(@"text_empty_default", nil);
            _textLabel.textAlignment = NSTextAlignmentCenter;
            [_textLabel setFont:[UIFont systemFontOfSize:14]];
            _textLabel.textColor = [UIColor colorWithRed:0.784 green:0.78 blue:0.8 alpha:1]; /*#c8c7cc*/
            _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [_textLabel sizeToFit];
            [self addSubview:_textLabel];
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_iconImageView.mas_bottom).offset(10);
                make.centerX.equalTo(_iconImageView);
            }];
        }

        if (!_reloadButton) {
            _reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [_reloadButton setTitle:NSLocalizedString(@"button_refresh", nil) forState:UIControlStateNormal];
            [_reloadButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:UIControlStateNormal];
            _reloadButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _reloadButton.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor; /*#333333*/
            _reloadButton.layer.borderWidth = 0.5;
            _reloadButton.layer.cornerRadius = 2.0;
            _reloadButton.contentEdgeInsets = UIEdgeInsetsMake(6.0, 20.0, 6.0, 20.0);
            _reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
            [_reloadButton sizeToFit];
            [self addSubview:_reloadButton];
            [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_textLabel.mas_bottom).offset(20);
                make.centerX.equalTo(_iconImageView);
            }];
        }
    }
    return self;
}

@end
