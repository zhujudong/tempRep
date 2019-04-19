//
//  LoginViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StatusModel.h"
#import "AccountSocialModel.h"

@interface LoginViewController : BaseViewController
@property(strong, nonatomic) AccountSocialModel *social;
@property(assign, nonatomic) BOOL requestNewAccessToken;
@end
