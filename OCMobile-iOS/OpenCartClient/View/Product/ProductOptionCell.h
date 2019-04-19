//
//  ProductOptionCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDUILabel.h"

typedef NS_ENUM(NSUInteger, ButtonState) {
    ButtonStateNormal,
    ButtonStateActive,
    ButtonStateDisabled
};

#define kCellIdentifier_ProductOptionCell @"ProductOptionCell"

@interface ProductOptionCell : UICollectionViewCell

@property (strong, nonatomic) NSString *text;

//- (void)setButtonState:(BOOL)selected;

- (void)setButtonState:(ButtonState)state;
+ (CGSize)buttonSize:(NSString *)text;
@end
