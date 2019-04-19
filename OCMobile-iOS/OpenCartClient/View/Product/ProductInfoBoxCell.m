//
//  ProductInfoBoxCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 05/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "ProductInfoBoxCell.h"

@interface ProductInfoBoxCell()
@property (strong, nonatomic) UIImageView *bannerImageView;
@end

@implementation ProductInfoBoxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        self.backgroundColor = [UIColor whiteColor];
        
        if (!_bannerImageView) {
            UIImage *image = [UIImage imageNamed:@"product_detail_static_banner"];
            _bannerImageView = [[UIImageView alloc] initWithImage:image];
            _bannerImageView.contentMode = UIViewContentModeCenter;

            [self.contentView addSubview:_bannerImageView];
            [_bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    
    return self;
}

@end
