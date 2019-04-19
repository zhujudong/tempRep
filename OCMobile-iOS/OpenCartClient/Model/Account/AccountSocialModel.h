//
//  AccountSocialModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 12/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AccountSocialModel : JSONModel
@property(nonatomic) NSString *provider, *uid, *unionid, *avatar, *fullname, *access_token, *token_secret;
@end
