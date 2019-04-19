//
//  ProductOptionCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductOptionCell.h"

static CGFloat const PADDING_Y = 8;
static CGFloat const PADDING_X = 12;

@interface ProductOptionCell()
@property (strong, nonatomic) UILabel *button;
@end

@implementation ProductOptionCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F0F3F5" alpha:1];
        
        if (!_button) {
            _button = [[UILabel alloc] init];
            _button.textAlignment = NSTextAlignmentCenter;
            _button.font = [UIFont systemFontOfSize:12];
            _button.layer.cornerRadius = 2;
            _button.clipsToBounds = YES;
            [self setButtonStateDisabled];
            
            [self.contentView addSubview:_button];
            [_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _button.text = _text;
}

- (void)setButtonState:(ButtonState)state {
    if (state == ButtonStateNormal) {
        [self setButtonStateNormal];
        return;
    }
    
    if (state == ButtonStateActive) {
        [self setButtonStateActive];
        return;
    }
    
    if (state == ButtonStateDisabled) {
        [self setButtonStateDisabled];
        return;
    }
}

-(void)setButtonStateNormal {
    _button.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1.0];
    _button.textColor = [UIColor colorWithHexString:@"222222" alpha:1.0];
}

-(void)setButtonStateActive {
    _button.backgroundColor = CONFIG_PRIMARY_COLOR;
    _button.textColor = [UIColor whiteColor];
}

-(void)setButtonStateDisabled {
    _button.backgroundColor = [UIColor colorWithHexString:@"f5f5f5" alpha:1.0];
    _button.textColor = [UIColor colorWithHexString:@"cacaca" alpha:1.0];
}

+ (CGSize)buttonSize:(NSString *)text {
    UILabel *button = [[UILabel alloc] init];
    button.font = [UIFont systemFontOfSize:13];
    button.text = text;
    [button sizeToFit];
    return CGSizeMake(button.frame.size.width + (PADDING_X * 2), button.frame.size.height + (PADDING_Y * 2));
}
@end
