//
//  BearyChat.h
//  OpenCartClient
//
//  Created by Sam Chen on 26/07/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BearyChat : NSObject
+ (BearyChat *)sharedInstance;

- (void)send:(NSArray *)bearyChatAttachments;
@end
