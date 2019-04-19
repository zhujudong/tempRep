//
//  CheckoutViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CheckoutModel.h"

@interface CheckoutViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) CheckoutModel *checkout;
@property(assign, nonatomic) BOOL pushedFromCart;

@end
