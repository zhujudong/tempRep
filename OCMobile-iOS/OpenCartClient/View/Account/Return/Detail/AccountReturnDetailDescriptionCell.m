//
//  AccountReturnDetailDescriptionCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnDetailDescriptionCell.h"

@interface AccountReturnDetailDescriptionCell()
@property (strong, nonatomic) UILabel *descriptionLabel;
@end

@implementation AccountReturnDetailDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_descriptionLabel) {
            _descriptionLabel = [UILabel new];
            _descriptionLabel.font = [UIFont systemFontOfSize:12];
            _descriptionLabel.textColor = [UIColor colorWithHexString:@"7A7A7A" alpha:1];

            [self.contentView addSubview:_descriptionLabel];
            [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
            }];
        }
    }

    return self;
}

- (void)setDesc:(NSString *)desc {
    _descriptionLabel.text = desc;
}

@end
