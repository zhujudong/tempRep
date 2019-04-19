//
//  AccountOrderExpressItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderExpressTraceModel.h"

#define kCellIdentifier_AccountOrderExpressItemCell @"AccountOrderExpressItemCell"

@interface AccountOrderExpressItemCell : UITableViewCell

@property (strong, nonatomic) AccountOrderExpressTraceModel *traceModel;

- (void)setDotStyleFirst;
- (void)setDotStyleMiddle;
- (void)setDotStyleLast;

@end
