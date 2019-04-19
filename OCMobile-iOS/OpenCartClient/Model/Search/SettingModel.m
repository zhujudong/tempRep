//
//  SettingModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/24/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"keywords": @"app_keywords",
                                                                  @"splashImage": @"app_splash_image",
                                                                  @"minVersion": @"app_ios.min_version",
                                                                  @"upgradeLink": @"app_ios.download_url"
                                                                  }];
}

- (BOOL)hasNewVersion {
    return [self.minVersion compare:[[System sharedInstance] installedVersion] options:NSNumericSearch] == NSOrderedDescending;
}

@end
