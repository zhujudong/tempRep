//
//  AccountAPI.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/06/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountAPI : NSObject
+ (AccountAPI *)sharedInstance;

- (void)requestNewAccessTokenWithBlock:(ResponseDataBlock)callback;
- (void)requestAccessTokenWithBlock:(ResponseDataBlock)callback;
- (void)refreshAccountInfoWithBlock:(ResponseDataBlock)callback;
@end
