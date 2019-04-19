//
//  AccountAddressFormInternationalViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 19/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "AccountAddressItemModel.h"

@interface AccountAddressFormInternationalViewController : BaseTableViewController
@property(strong, nonatomic) AccountAddressItemModel *address;
@property (assign, nonatomic) BOOL hideSetDefaultButton;
@end
