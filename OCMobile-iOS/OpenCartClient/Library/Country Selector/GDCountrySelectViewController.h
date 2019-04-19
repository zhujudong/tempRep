//
//  GDCountrySelectViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 19/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallingCodeModel.h"

@interface GDCountrySelectViewController : UIViewController
@property (strong, nonatomic) NSArray *callingCodes;
@property (copy, nonatomic) void(^countrySelectedBlock)(NSString *);
@end
