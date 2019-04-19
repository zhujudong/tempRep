//
//  CategoryListTableViewCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/24/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryListTableViewCell.h"

@interface CategoryListTableViewCell()
@property (strong, nonatomic) UILabel *nameLabel;
@end

@implementation CategoryListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f3f4f6" alpha:1];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] init];
            _nameLabel.textColor = [UIColor colorWithHexString:@"1C1C1C" alpha:1];
            _nameLabel.font = [UIFont systemFontOfSize:12];
            _nameLabel.numberOfLines = 0;
//            _nameLabel.textAlignment = NSTextAlignmentCenter;

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(14, 10, 14, 10));
            }];
        }
    }

    return self;
}

- (void)setCategory:(CategoryFirstLevelItemModel *)category {
    _category = category;

    _nameLabel.text = _category.name;
}

@end
