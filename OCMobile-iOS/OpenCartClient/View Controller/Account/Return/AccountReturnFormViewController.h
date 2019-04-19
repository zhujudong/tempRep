//
//  AccountReturnFormViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "UIQuantityControl.h"

@interface AccountReturnFormViewController : BaseTableViewController

@property(strong, nonatomic) NSString *productName;
@property(strong, nonatomic) NSString *orderId;
@property(assign, nonatomic) NSInteger orderProductId;
@property(assign, nonatomic) NSInteger quantity;

@end
