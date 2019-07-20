//
//  DJHBaseRequest.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/7/19.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseRequest.h"
#import "DJHNetworkAgent.h"

@interface DJHBaseRequest ()

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

@implementation DJHBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseUrlString = @"";
        _requestUrlString = @"";
        _cdnUrlString = @"";
        _requestTimeoutInterval = 40;
        _parameters = nil;
        _useCDN = NO;
        _allowsCellularAccess = YES;
        _requestMethod = DJHRequestMethodGET;
        _requestPriority = DJHRequestPriorityDefault;
        _requestSerializerType = DJHRequestSerializerTypeHTTP;
        _responseSerializerType = DJHResponseSerializerTypeJSON;
        _requestAuthorizationHeaderFieldArray = nil;
        _requestHeaderFieldValueDictionary = nil;
        _resumableDownloadPath = nil;
    }
    
    return self;
}

//MARK:获取请求的urlString，子类可以重写该方法，实现自定义请求urlString
- (NSString *)buildRequestUrlString
{
    NSString *requestUrlString = [self requestUrlString];
    NSURL *temp = [NSURL URLWithString:requestUrlString];
    //如果requestUrlString是一个有效的URL
    if (temp && temp.host && temp.scheme) {
        return requestUrlString;
    }
    
    NSString *baseUrlString;
    if ([self useCDN]) {//启用了CDN
        if ([self cdnUrlString].length > 0) {
            baseUrlString = [self cdnUrlString];
        } else {
            baseUrlString = @"";
        }
    } else {
        if ([self baseUrlString].length > 0) {
            baseUrlString = [self baseUrlString];
        } else {
            baseUrlString = @"";
        }
    }
    // URL slash compability
    NSURL *url = [NSURL URLWithString:baseUrlString];
    
    if (baseUrlString.length > 0 && ![baseUrlString hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    return [NSURL URLWithString:requestUrlString relativeToURL:url].absoluteString;
}

#pragma mark - 返回Response信息

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299);
}

#pragma mark - 请求Action

/**
 MARK:附加自请求队列并启动请求
 */
- (void)start
{
    [[DJHNetworkAgent sharedAgent] addRequest:self];
}

/**
 MARK:从请求队列中删除自身并取消请求
 */
- (void)stop
{
    self.delegate = nil;
    [[DJHNetworkAgent sharedAgent] cancelRequest:self];
}

/**
 MARK:使用块回调启动请求的方便方法
 
 @param success 成功block
 @param failure 失败block
 @param progress 进度block
 */
- (void)startWithCompletionBlockWithSuccess:(nullable DJHRequestCompletionBlock)success
                                    failure:(nullable DJHRequestCompletionBlock)failure
                                   progress:(nullable DJHRequestProgressBlock)progress
{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    self.progressBlock = progress;
    [self start];
}

#pragma mark - 请求完成触发

/**
 MARK:清除回调
 */
- (void)clearCompletionBlock
{
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    self.progressBlock = nil;
}

@end
