//
//  DJHNetworkTool.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/7/19.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJHBaseRequest.h"

FOUNDATION_EXPORT void DJHNetworkLog(NSString * _Nullable format, ...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT NSString * _Nullable const DJHRequestValidationErrorDomain;

@interface DJHBaseRequest (Setter)

#pragma mark - 返回Response信息，读写属性

/**
 MARK:这个值实际上是零，在请求开始之前不应该被访问
 */
@property (strong, nonatomic, readwrite, nullable) NSURLSessionTask *requestTask;
/**
 MARK:返回状态码，这里的状态码是http请求返回的，如200，404等
 */
@property (assign, nonatomic, readwrite) NSInteger responseStatusCode;
/**
 MARK:响应快捷方式
 */
@property (strong, nonatomic, readwrite, nullable) NSHTTPURLResponse *response;
/**
 MARK:返回原始数据，后台定义的成功或错误信息都在这里面，需根据具体情况解析
 */
@property (strong, nonatomic, readwrite, nullable) NSData *responseData;
/**
 MARK:返回原始数据字符串表示形式
 */
@property (strong, nonatomic, readwrite, nullable) NSString *responseString;
/**
 MARK:根据DJHResponseSerializerType返回的使用数据
 */
@property (strong, nonatomic, readwrite, nullable) id responseObject;
/**
 MARK:使用DJHResponseSerializerTypeJSON转换后json数据
 */
@property (strong, nonatomic, readwrite, nullable) id responseJSONObject;
/**
 MARK:错误信息
 */
@property (strong, nonatomic, readwrite, nullable) NSError *error;
/**
 MARK:错误信息描述
 */
@property (copy, nonatomic, readwrite, nullable) NSString *errorDescription;
/**
 MARK:状态码是否有效
 */
@property (assign, nonatomic, readwrite) BOOL statusCodeValidator;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DJHNetworkTool : NSObject

#pragma mark - 初始化

/**
 MARK:单例

 @return DJHNetworkTool
 */
+ (DJHNetworkTool *)sharedInstance;

@property (copy, nonatomic) NSString *baseUrlString;

/**
 MARK:是否打印debug信息，默认NO;
 */
@property (assign, nonatomic) BOOL debugLogEnabled;

#pragma mark - tool

/**
 MARK:验证结果
 
 @param request 请求request
 @param error 错误信息
 @return 验证结果
 */
- (BOOL)validateResult:(DJHBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error;

/**
 NSStringEncoding
 
 @param request 请求request
 @return NSStringEncoding
 */
- (NSStringEncoding)stringEncodingWithRequest:(DJHBaseRequest *)request;

/**
 MARK:请求错误信息描述
 
 @param requestError 错误信息
 @return 错误信息秒速
 */
- (NSString *)errorDescriptionWithRequestError:(NSError *)requestError;

#pragma mark - Resumable Download

/**
 MARK:返回可恢复数据文件path url
 
 @param downloadPath 下载路径
 @return 下载路径
 */
- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath;

/**
 验证可恢复数据
 
 @param data 数据
 @return 验证结果
 */
- (BOOL)validateResumeData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
