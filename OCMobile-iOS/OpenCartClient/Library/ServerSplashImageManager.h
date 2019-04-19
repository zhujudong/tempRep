//
//  ServerSplashImageManager.h
//  OpenCartClient
//
//  Created by Sam Chen on 15/10/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerSplashImageManager : NSObject

+ (ServerSplashImageManager *)sharedInstance;
- (void)startToLoadCustomLaunchImage;
- (void)forceExpired;
@end
