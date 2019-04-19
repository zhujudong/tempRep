//
//  MobileInputCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 19/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallingCodeModel.h"

#define kCellIdentifier_MobileInputCell @"MobileInputCell"

@interface MobileInputCell : UITableViewCell
@property (strong, nonatomic) NSString *mobileNumber, *regionCode;
@property (strong, nonatomic) NSArray *callingCodes;

@property (copy, nonatomic) void(^regionButtonClickedBlock)(void);
@property (copy, nonatomic) void(^mobileNumberChangedBlock)(NSString *);
@end
