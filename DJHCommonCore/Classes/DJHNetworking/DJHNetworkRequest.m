//
//  DJHNetworkRequest.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/7/20.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHNetworkRequest.h"

@implementation DJHNetworkRequest

/**
 MARK:生成get请求request
 
 @param requestUrlString 接口地址
 @param parameters 请求参数
 @return 请求request
 */
+ (DJHNetworkRequest *)requestHttpGetWithRequestUrl:(NSString *)requestUrlString parameters:(NSDictionary *)parameters parameters:(NSDictionary *)parameters
{
    DJHNetworkRequest *request = [[DJHNetworkRequest alloc] init];
    request.requestUrlString = requestUrlString;
    request.parameters = parameters;
    request.requestMethod = DJHRequestMethodGET;
    
    return request;
}

/**
 MARK:生成post请求request
 
 @param requestUrlString 接口地址
 @param parameters 请求参数
 @return 请求request
 */
+ (DJHNetworkRequest *)requestHttpPostWithRequestUrl:(NSString *)requestUrlString parameters:(NSDictionary *)parameters parameters:(NSDictionary *)parameters
{
    DJHNetworkRequest *request = [[DJHNetworkRequest alloc] init];
    request.requestUrlString = requestUrlString;
    request.parameters = parameters;
    request.requestMethod = DJHRequestMethodPOST;
    
    return request;
}

@end
