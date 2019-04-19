//
//  UIQuantityControl.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/12/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIQuantityControlDelegate
- (void)quantityChangedTo:(NSInteger)number tag:(NSUInteger)tag;
@end

@interface UIQuantityControl : UIControl

@property(assign, nonatomic) NSInteger quantity;
@property(assign, nonatomic) NSInteger minimum;
@property(assign, nonatomic) NSInteger maximum;
@property(assign, nonatomic) long index;
@property(retain, nonatomic) UIButton *minusBtn;
@property(retain, nonatomic) UIButton *plusBtn;
@property(retain, nonatomic) UITextField *textField;
@property(assign, nonatomic) NSInteger eventType;

@property(assign, nonatomic) id <UIQuantityControlDelegate> delegate;

- (void)setQuantity:(NSInteger)quantity;

@end
