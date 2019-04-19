//
//  PaymentResultHandler.h
//  OpenCartClient
//
//  Created by Sam Chen on 13/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentResultViewController.h"
#import "AppDelegate.h"

@interface PaymentResultHandler : NSObject

@property (nonatomic) BOOL success;
@property (strong, nonatomic) NSString *message;

- (void)presentPaymentResultVCIfNeeded;

@end
