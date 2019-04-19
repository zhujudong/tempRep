//
//  RegisterEmailViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 5/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "AccountSocialModel.h"

@interface RegisterEmailViewController : BaseTableViewController
@property(strong, nonatomic) AccountSocialModel *social;
@end
