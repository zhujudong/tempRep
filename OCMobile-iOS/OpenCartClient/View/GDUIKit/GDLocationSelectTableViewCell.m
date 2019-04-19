//
//  GDLocationSelectTableViewCell.m
//  afterschoollol
//
//  Created by Sam Chen on 18/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "GDLocationSelectTableViewCell.h"

@interface GDLocationSelectTableViewCell()
@property (strong, nonatomic) UILabel *label;
@end

@implementation GDLocationSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;

        if (!_label) {
            _label = [[UILabel alloc] init];
            _label.font = [UIFont systemFontOfSize:13];
            _label.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        UIView *backgroundview = [[UIView alloc] initWithFrame:self.bounds];
        backgroundview.backgroundColor = [UIColor colorWithHexString:@"f7f7f7" alpha:1];
        self.backgroundView = backgroundview;
    } else {
        self.backgroundView = nil;
    }
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}
@end
