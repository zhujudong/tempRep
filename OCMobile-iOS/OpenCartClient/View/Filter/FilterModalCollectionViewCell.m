//
//  FilterModalCollectionViewCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/5/31.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterModalCollectionViewCell.h"

@interface FilterModalCollectionViewCell()
@property (strong, nonatomic) UILabel *textLabel;
@end

@implementation FilterModalCollectionViewCell

+ (NSString *)identifier {
    return @"kCellIdenfifier_FilterModalCollectionViewCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:11];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.cornerRadius = 4;
        [self setActive:NO];
        [_textLabel clipsToBounds];
        [self.contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }

    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _textLabel.text = _name;
}

- (void)setActive:(BOOL)active {
    if (active) {
        _textLabel.backgroundColor = CONFIG_PRIMARY_COLOR;
        _textLabel.textColor = [UIColor whiteColor];
    } else {
        _textLabel.textColor = [UIColor colorWithHexString:@"2d2d2d" alpha:1];
        _textLabel.backgroundColor = [UIColor colorWithHexString:@"f6f6f6" alpha:1];
    }
}

@end
