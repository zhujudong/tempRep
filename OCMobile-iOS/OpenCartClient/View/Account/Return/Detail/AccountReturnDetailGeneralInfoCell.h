//
//  AccountReturnDetailGeneralInfoCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountReturnInfoModel.h"

#define kCellIdentifier_AccountReturnDetailGeneralInfoCell @"AccountReturnDetailGeneralInfoCell"

@interface AccountReturnDetailGeneralInfoCell : UITableViewCell
@property(strong, nonatomic) AccountReturnInfoModel *returnModel;
@end
