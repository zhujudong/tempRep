//
//  AccountOrderListViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AccountOrderListModel.h"

@interface AccountOrderListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSString* orderListType;

@end
