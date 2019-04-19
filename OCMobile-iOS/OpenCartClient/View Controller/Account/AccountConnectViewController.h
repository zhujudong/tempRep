//
//  AccountConnectViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 12/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AccountSocialModel.h"

@interface AccountConnectViewController : BaseViewController
@property (strong, nonatomic) AccountSocialModel *social;
@end
