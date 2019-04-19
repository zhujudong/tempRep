//
//  SendSMSButton.h
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendSMSButton : UIButton

-(void)disableButtonAndCountdownFor:(NSInteger)seconds;

@end
