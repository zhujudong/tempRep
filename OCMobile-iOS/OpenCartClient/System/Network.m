//
//  Network.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/24/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//


#import "AFNetworking.h"
#import "Customer.h"
#import "StatusModel.h"
#import "AppDelegate.h"
#import "BearyChat.h"
#import "BearyChatAttachmentModel.h"
#import "AnalyticsManager.h"

static CGFloat const NETWORK_TIMEOUT_SEC = 60; //Network timeout seconds

@interface Network()
@property(strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation Network

#pragma mark - init

+ (Network *)sharedInstance {
    static Network *_sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[Network alloc] init];
    });

    return _sharedInstance;
}

- (id)init {
    self = [super init];

    if (self) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CONFIG_API_URL]];

        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];

        [self updateAccessTokenForHTTPHeaderField];
        [_manager.requestSerializer setValue:[[System sharedInstance] languageCode] forHTTPHeaderField:@"language"];
        [_manager.requestSerializer setValue:[[System sharedInstance] currencyCode] forHTTPHeaderField:@"currency"];

        [_manager.requestSerializer setTimeoutInterval:NETWORK_TIMEOUT_SEC];
    }

    return self;
}

- (void)updateLanguageAndCurrencyForHttpHeaderField {
    if (_manager) {
        [_manager.requestSerializer setValue:[[System sharedInstance] languageCode] forHTTPHeaderField:@"language"];
        [_manager.requestSerializer setValue:[[System sharedInstance] currencyCode] forHTTPHeaderField:@"currency"];
    }
}

- (void)updateAccessTokenForHTTPHeaderField {
    if ([[Customer sharedInstance] accessToken] != nil) {
        [_manager.requestSerializer setValue:[[Customer sharedInstance] accessToken] forHTTPHeaderField:@"access-token"];
    } else {
        [_manager.requestSerializer setValue:nil forHTTPHeaderField:@"access-token"];
    }
}

#pragma mark - GET/POST/DELETE/PUT

- (void)GET:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback {
    NSLog(@"API request [GET]: %@", command);
    NSLog(@"API request params: %@", params.description);

    [[AnalyticsManager sharedManager] trackEvent:@"api_call" label:command];
    //[[BaiduMobStat defaultStat] logEvent:@"api_call" eventLabel:command];

    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_manager GET:command parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf requestSuccessBlock:responseObject command:command callback:callback];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf requestFailureBlock:task command:command method:@"GET" params:params error:error callback:callback];
    }];
}

- (void)POST:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback {
    NSLog(@"API request [POST]: %@", command);
    NSLog(@"API request params: %@", params.description);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[AnalyticsManager sharedManager] trackEvent:@"api_call" label:command];
    //[[BaiduMobStat defaultStat] logEvent:@"api_call" eventLabel:command];

    __weak typeof(self) weakSelf = self;
    [_manager POST:command parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf requestSuccessBlock:responseObject command:command callback:callback];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf requestFailureBlock:task command:command method:@"POST" params:params error:error callback:callback];
    }];
}

- (void)DELETE:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback {
    NSLog(@"API request [DELETE]: %@", command);
    NSLog(@"API request params: %@", params.description);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[AnalyticsManager sharedManager] trackEvent:@"api_call" label:command];
    //[[BaiduMobStat defaultStat] logEvent:@"api_call" eventLabel:command];

    __weak typeof(self) weakSelf = self;
    [_manager DELETE:command parameters:params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf requestSuccessBlock:responseObject command:command callback:callback];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf requestFailureBlock:task command:command method:@"DELETE" params:params error:error callback:callback];
    }];
}

- (void)PUT:(NSString *)command params:(NSDictionary *)params callback:(ResponseDataBlock)callback {
    NSLog(@"API request [PUT]: %@", command);
    NSLog(@"API request params: %@", params.description);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[AnalyticsManager sharedManager] trackEvent:@"api_call" label:command];
    //[[BaiduMobStat defaultStat] logEvent:@"api_call" eventLabel:command];

    __weak typeof(self) weakSelf = self;
    [_manager PUT:command parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf requestSuccessBlock:responseObject command:command callback:callback];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf requestFailureBlock:task command:command method:@"PUT" params:params error:error callback:callback];
    }];
}

#pragma mark - Process common response

- (void)requestSuccessBlock:(id)responseObject command:(NSString *)command callback:(ResponseDataBlock)callback {
    if (responseObject == nil) {
        NSLog(NSLocalizedString(@"error_api_failed", nil));
        if (callback) {
            callback(nil, NSLocalizedString(@"error_api_failed", nil));
        }
        return;
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (callback) {
        callback((NSDictionary *)responseObject, nil);
    }
}

- (void)requestFailureBlock:(NSURLSessionDataTask *)task command:(NSString *)command method:(NSString *)method params:(NSDictionary *)params error:(NSError *)error callback:(ResponseDataBlock)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;

    switch (urlResponse.statusCode) {
        case 0: { // No connection
            NSLog(@"No network connection...");
            if (callback) {
                callback(nil, NSLocalizedString(@"error_network_disconnected", nil));
            }
            break;
        }
        case 401: { // 401, Unauthorized
            NSLog(@"Unauthorized [401]...");
            if ([command isEqualToString:@"account/me"]) {
                [[Customer sharedInstance] logout];
                [[Customer sharedInstance] prepareAccessTokenWithBlock:nil];

                if (callback) {
                    callback(nil, NSLocalizedString(@"toast_app_delegate_token_invalid", nil));
                }
                break;
            }

            if ([command isEqualToString:@"account/token"]) {
                if (callback) {
                    callback(nil, NSLocalizedString(@"error_unauthorized", nil));
                }
                break;
            }

            if ([command hasPrefix:@"callbacks/social"]) { // Social login new account should continue to AccountConnectVC
                if (callback) {
                    callback(nil, @"401");
                }
                break;
            }

            [((AppDelegate *)[UIApplication sharedApplication].delegate) presentLoginViewController];
            break;
        }
        case 500: {
            NSLog(@"Server error [500]...");
            if (callback) {
                callback(nil, NSLocalizedString(@"error_500", nil));
            }
            break;
        }
        default: {
            StatusModel *statusModel = [[StatusModel alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] error:nil];
            NSLog(@"General error - %@", statusModel.message);

            if (callback) {
                if ([statusModel.message isEqualToString:@""]) {
                    callback(nil, NSLocalizedString(@"error_500", nil));
                } else {
                    callback(nil, statusModel.message);
                }
            }
        }
    }

    [self sendBearyChat:error method:method command:command status:urlResponse.statusCode params:params];
}

#pragma mark - Send BearyChat Message
- (void)sendBearyChat:(NSError *)error method:(NSString *)method command:(NSString *)command status:(NSInteger)status params:(NSDictionary *)params {
    // Exclude some expected request errors from notification
    NSArray *excludes = @[@"account/check_account", @"account/login"];
    if ([excludes containsObject:command] && status == 422) { // 422 means normal error
        return;
    }

    StatusModel *statusModel = [[StatusModel alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] error:nil];

    BearyChatAttachmentModel *requestAttachment = [[BearyChatAttachmentModel alloc] init];
    requestAttachment.title = [NSString stringWithFormat:@"[%@] %@%@", method, _manager.baseURL.absoluteString, command];
    requestAttachment.text = [NSString stringWithFormat:@"%@", params];

    BearyChatAttachmentModel *responseAttachment = [[BearyChatAttachmentModel alloc] init];
    responseAttachment.title = [NSString stringWithFormat:@"Status Code: [%ld]", (long)status];
    if (statusModel) {
        responseAttachment.text = statusModel.message;
    } else {
        responseAttachment.text = error.localizedDescription;
    }

    [[BearyChat sharedInstance] send:@[requestAttachment, responseAttachment]];
}
@end
