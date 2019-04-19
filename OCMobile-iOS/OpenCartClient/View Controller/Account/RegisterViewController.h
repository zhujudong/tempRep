//
//  RegisterViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 5/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "AccountSocialModel.h"
#import "CallingCodeModel.h"

@interface RegisterViewController : BaseTableViewController
@property(strong, nonatomic) AccountSocialModel *social;
@property(strong, nonatomic) NSArray *callingCodes;
@end
