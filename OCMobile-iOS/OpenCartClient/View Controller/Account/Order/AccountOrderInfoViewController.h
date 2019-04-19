//
//  AccountOrderInfoViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AccountOrderInfoModel.h"

@interface AccountOrderInfoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *orderId;

@end
