//
//  AccountEditViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 5/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface AccountEditViewController : BaseTableViewController

@property (strong, nonatomic) NSString* firstname;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* telephone;

@end
