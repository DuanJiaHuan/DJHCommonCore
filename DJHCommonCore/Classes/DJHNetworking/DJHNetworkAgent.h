//
//  DJHNetworkAgent.h
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/7/18.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJHBaseRequest;

NS_ASSUME_NONNULL_BEGIN

@interface DJHNetworkAgent : NSObject

/**
 MARK:单例

 @return DJHNetworkAgent
 */
+ (DJHNetworkAgent *)sharedInstance;

/**
 MARK:向会话添加请求并启动它

 @param request 请求request
 */
- (void)addRequest:(DJHBaseRequest *)request;

/**
 MARK:取消先前添加的请求

 @param request 请求request
 */
- (void)cancelRequest:(DJHBaseRequest *)request;

/**
 MARK:取消先前添加的所有请求
 */
- (void)cancelAllRequests;

@end

NS_ASSUME_NONNULL_END
