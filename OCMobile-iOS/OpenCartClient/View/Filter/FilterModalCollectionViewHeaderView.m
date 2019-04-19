//
//  FilterModalCollectionViewHeaderView.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/5/31.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterModalCollectionViewHeaderView.h"

@interface FilterModalCollectionViewHeaderView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *allButton;
@end

@implementation FilterModalCollectionViewHeaderView

+ (NSString *)identifier {
    return @"kCellIdenfifier_FilterModalCollectionViewCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"484848" alpha:1];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self);
        }];

        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allButton setTitleColor:[UIColor colorWithHexString:@"484848" alpha:1] forState:UIControlStateNormal];
        _allButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_allButton setTitle:NSLocalizedString(@"button_all", nil) forState:UIControlStateNormal];
        [_allButton addTarget:self action:@selector(headerClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_allButton];
        [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self);
        }];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClicked)];
        [self addGestureRecognizer:tap];
    }

    return self;
}

- (void)headerClicked {
    if (self.headerViewClickedBlock) {
        self.headerViewClickedBlock(_sectionIndex);
    }
}

- (void)setSectionIndex:(NSInteger)sectionIndex {
    _sectionIndex = sectionIndex;
}

- (void)setName:(NSString *)name {
    _name = name;
    _titleLabel.text = _name;
}

- (void)setShowAllButton:(BOOL)showAllButton {
    [_allButton setHidden:!showAllButton];
}

@end
