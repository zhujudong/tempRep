//
//  BearyChat.m
//  OpenCartClient
//
//  Created by Sam Chen on 26/07/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "BearyChat.h"
#import "AFNetworking.h"
#import "BearyChatModel.h"
#import "Customer.h"
#import "DeviceUtil.h"

@interface BearyChat()
@property(strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation BearyChat
+ (BearyChat *)sharedInstance {
    static BearyChat *_sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[BearyChat alloc] init];
    });

    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_manager.requestSerializer setTimeoutInterval:30];
    }
    return self;
}

- (void)send:(NSArray *)bearyChatAttachments {
    if (CONFIG_BEARYCHAT_HOOK.length <= 0) {
        return;
    }

    [_manager POST:CONFIG_BEARYCHAT_HOOK parameters:[[self payload:bearyChatAttachments] toDictionary] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

- (BearyChatModel *)payload:(NSArray *)bearyChatAttachments {
    BearyChatModel *bearyChatModel = [[BearyChatModel alloc] init];
    bearyChatModel.text = [NSString stringWithFormat:@"iOS - %@ (v%@ - build: %@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    bearyChatModel.channel = CONFIG_BEARYCHAT_CHANNEL;

    bearyChatModel.attachments = [[NSMutableArray<BearyChatAttachmentModel> alloc] init];

    // User info
    BearyChatAttachmentModel *userInfo = [[BearyChatAttachmentModel alloc] init];
    userInfo.title = @"User info";
    if ([[Customer sharedInstance] isLogged]) {
        AccountModel *account = [[Customer sharedInstance] account];
        userInfo.text = [NSString stringWithFormat:@"[Logged in], Customer ID: %ld, Fullname: %@", (long)account.customerId, [account fullname]];
    } else {
        userInfo.text = [NSString stringWithFormat:@"[Guest]: access token: %@", [[Customer sharedInstance] accessToken]];
    }
    [bearyChatModel.attachments addObject:userInfo];

    // iOS version
    BearyChatAttachmentModel *deviceInfo = [[BearyChatAttachmentModel alloc] init];
    deviceInfo.title = @"Device info";
    // iPhone iOS 10.3.3
    DeviceUtil *deviceUtil = [[DeviceUtil alloc] init];

    deviceInfo.text = [NSString stringWithFormat:@"%@ (%@ v%@)", [deviceUtil hardwareDescription], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
    [bearyChatModel.attachments addObject:deviceInfo];

    // Language and currency
    BearyChatAttachmentModel *localizationInfo = [[BearyChatAttachmentModel alloc] init];
    localizationInfo.title = @"Localization info";
    localizationInfo.text = [NSString stringWithFormat:@"Language: %@, currency: %@",[[System sharedInstance] languageCode], [[System sharedInstance] currencyCode]];
    [bearyChatModel.attachments addObject:localizationInfo];

    if (bearyChatAttachments.count <= 0) {
        return bearyChatModel;
    }

    for (BearyChatAttachmentModel *attachment in bearyChatAttachments) {
        if (attachment) {
            [bearyChatModel.attachments addObject:attachment];
        }
    }

    return bearyChatModel;
}
@end
