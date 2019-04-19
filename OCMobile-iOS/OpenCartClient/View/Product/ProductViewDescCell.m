//
//  ProductViewDescCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/29/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductViewDescCell.h"

@interface ProductViewDescCell()
@property (strong, nonatomic) UILabel *descriptionLabel;
@end

@implementation ProductViewDescCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        
        if (!_descriptionLabel) {
            _descriptionLabel = [UILabel new];
            _descriptionLabel.font = [UIFont systemFontOfSize:14];
            _descriptionLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            _descriptionLabel.text = NSLocalizedString(@"label_cell_product_description_title", nil);
            
            [self.contentView addSubview:_descriptionLabel];
            [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(14);
                make.bottom.equalTo(self.contentView).offset(-14);
                make.centerX.equalTo(self.contentView);
            }];
        }
    }
    
    return self;
}

@end
