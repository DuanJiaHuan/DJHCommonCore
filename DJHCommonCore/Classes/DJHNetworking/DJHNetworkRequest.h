//
//  DJHNetworkRequest.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/7/20.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJHNetworkRequest : DJHBaseRequest

/**
 MARK:生成get请求request
 
 @param baseUrlString 域名地址
 @param requestUrlString 接口地址
 @param parameters 请求参数
 @return 请求request
 */
+ (DJHNetworkRequest *)requestGetWithBaseUrlString:(NSString *)baseUrlString requestUrl:(NSString *)requestUrlString parameters:(NSDictionary *)parameters;

/**
 MARK:生成post请求request
 
 @param baseUrlString 域名地址
 @param requestUrlString 接口地址
 @param parameters 请求参数
 @return 请求request
 */
+ (DJHNetworkRequest *)requestPostWithBaseUrlString:(NSString *)baseUrlString requestUrl:(NSString *)requestUrlString parameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
