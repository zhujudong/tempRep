//
//  CheckoutShippingAddressViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CheckoutShippingAddressViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) NSInteger selectedAddressId;

@end
