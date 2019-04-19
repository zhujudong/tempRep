//
//  BankTransferModalView.h
//  YITAYO
//
//  Created by Sam Chen on 27/09/2017.
//  Copyright © 2017 itpanda.com.au. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankTransferModalView : UIView

@property (strong, nonatomic) NSString *bankTransferInfo;

- (void)show;
- (void)dismiss;
@property (copy, nonatomic) void(^submitButtonClickedBlock)(void);

@end
