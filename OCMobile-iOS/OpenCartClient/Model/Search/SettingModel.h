//
//  SettingModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/24/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SettingModel : JSONModel

@property (nonatomic) NSArray<NSString *> *keywords;
@property (nonatomic) NSString *splashImage;
@property (nonatomic) NSString<Optional> *minVersion;
@property (nonatomic) NSString<Optional> *upgradeLink;

- (BOOL)hasNewVersion;
@end
