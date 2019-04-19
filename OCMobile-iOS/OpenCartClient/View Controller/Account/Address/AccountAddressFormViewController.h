//
//  AccountAddressFormViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "AccountAddressItemModel.h"

@interface AccountAddressFormViewController : BaseTableViewController
@property(strong, nonatomic) AccountAddressItemModel *address;
@property (assign, nonatomic) BOOL hideSetDefaultButton;
@end
