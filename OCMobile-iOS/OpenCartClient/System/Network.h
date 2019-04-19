//
//  Network.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/24/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseDataBlock)(NSDictionary *data, NSString *error);

@interface Network : NSObject

+ (Network *)sharedInstance;

- (void)updateLanguageAndCurrencyForHttpHeaderField;

- (void)updateAccessTokenForHTTPHeaderField;

- (void)GET:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback;

- (void)POST:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback;

- (void)DELETE:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback;

- (void)PUT:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback;
@end
