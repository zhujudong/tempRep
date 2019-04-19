//
//  SendSMSButton.m
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "SendSMSButton.h"

@interface SendSMSButton()
@end

@implementation SendSMSButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:NSLocalizedString(@"button_send_sms", nil) forState:UIControlStateNormal];
        self.backgroundColor = CONFIG_PRIMARY_COLOR;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
        [self clipsToBounds];
    }

    return self;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    UIColor *foreColor = [UIColor colorWithHexString: enabled? @"333333": @"999999" alpha:1];

    [self setTitleColor:foreColor forState:UIControlStateNormal];

    if (enabled) {
        [self setTitle:NSLocalizedString(@"button_send_sms", nil) forState:UIControlStateNormal];
    }else if ([self.titleLabel.text isEqualToString:NSLocalizedString(@"button_send_sms", nil)]){
        [self setTitle:NSLocalizedString(@"label_sms_state_sending", nil) forState:UIControlStateNormal];
    }
}

-(void)disableButtonAndCountdownFor:(NSInteger)seconds {
    self.backgroundColor = [UIColor colorWithHexString:@"999999" alpha:1];
    __block NSInteger timeout = seconds; //倒计时 秒
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.backgroundColor = CONFIG_PRIMARY_COLOR;
                [self setTitle:NSLocalizedString(@"button_send_sms", nil) forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"text_register_sms_wait", nil), strTime] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
