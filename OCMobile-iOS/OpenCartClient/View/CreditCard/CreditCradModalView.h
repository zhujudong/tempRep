//
//  CreditCradModalView.h
//  afterschoollol
//
//  Created by Sam Chen on 10/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripeNewCardModel.h"

@interface CreditCradModalView : UIView

- (void)show;
- (void)dismiss;

@property (nonatomic) BOOL saveCardEnabled;
@property (nonatomic) BOOL dismissable;
@property (copy, nonatomic) void(^cancelButtonClickedBlock)(void);
@property (copy, nonatomic) void(^submitButtonClickedBlock)(StripeNewCardModel *card);

@end
