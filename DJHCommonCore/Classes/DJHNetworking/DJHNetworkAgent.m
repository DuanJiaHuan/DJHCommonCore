//
//  DJHNetworkAgent.m
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/7/18.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHNetworkAgent.h"
#import "DJHBaseRequest.h"
#import "DJHNetworkTool.h"
#import <pthread/pthread.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface DJHNetworkAgent () {
    AFHTTPSessionManager *_sessionManager;//请求session
    AFJSONResponseSerializer *_jsonResponseSerializer;//json响应类型
    AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;//xml响应
    NSMutableDictionary<NSNumber *, DJHBaseRequest *> *_requestsRecord;//记录所有请求
    
    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;//状态码集合
}

@end

@implementation DJHNetworkAgent

#pragma mark - 初始化

/**
 MARK:单例

 @return DJHNetworkAgent
 */
+ (DJHNetworkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 MARK:初始化

 @return DJHNetworkAgent
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        _requestsRecord = [NSMutableDictionary dictionary];
        _processingQueue = dispatch_queue_create("com.djh.networkagent.processing", DISPATCH_QUEUE_CONCURRENT);
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        pthread_mutex_init(&_lock, NULL);
        
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _sessionManager.completionQueue = _processingQueue;
    }
    return self;
}

#pragma mark - Session配置

/**
 MARK:json响应类型

 @return json响应类型
 */
- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
        _jsonResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
        
    }
    return _jsonResponseSerializer;
}

/**
 MARK:xml响应

 @return xml响应
 */
- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
    if (!_xmlParserResponseSerialzier) {
        _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
        _xmlParserResponseSerialzier.acceptableStatusCodes = _allStatusCodes;
    }
    return _xmlParserResponseSerialzier;
}

/**
 MARK:配置请求Serializer

 @param request 请求request
 @return AFHTTPRequestSerializer
 */
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(DJHBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == DJHRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == DJHRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    requestSerializer.allowsCellularAccess = [request allowsCellularAccess];
    
    // If api needs server username and password
    NSArray<NSString *> *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderFieldArray.firstObject
                                                          password:authorizationHeaderFieldArray.lastObject];
    }
    
    // If api needs to add custom value to HTTPHeaderField
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}

/**
 MARK:配置响应Serializer，默认使用这种，解析时再根据responseSerializerType去选择

 @param request 请求request
 @return AFHTTPResponseSerializer
 */
- (AFHTTPResponseSerializer *)responseSerializerForRequest:(DJHBaseRequest *)request {
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableStatusCodes = _allStatusCodes;
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
    
    return responseSerializer;
}

#pragma mark - 请求操作相关

/**
 MARK:向会话添加请求并启动它

 @param request 请求request
 */
- (void)addRequest:(DJHBaseRequest *)request {
    if (!request) return;
    
    DJHRequestMethod method = [request requestMethod];
    NSString *url = [request buildRequestUrlString];
    id param = request.parameters;
    __block NSURLSessionTask *dataTask = nil;
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    _sessionManager.requestSerializer = requestSerializer;
    AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForRequest:request];
    _sessionManager.responseSerializer = responseSerializer;
    
    __weak typeof(self) weakSelf = self;
    if (method == DJHRequestMethodDOWNLOAD) {
        NSError * __autoreleasing requestSerializationError = nil;
        
        dataTask = [self downloadTaskWithDownloadPath:request.resumableDownloadPath requestSerializer:requestSerializer URLString:url parameters:param progress:^(NSProgress *downloadProgress) {
            [weakSelf handleRequestProgress:dataTask progress:downloadProgress];
        } error:&requestSerializationError];
        [dataTask resume];
    } else if (method == DJHRequestMethodGET) {
        dataTask = [_sessionManager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            [weakSelf handleRequestProgress:dataTask progress:downloadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf handleRequestResult:dataTask responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleRequestResult:dataTask responseObject:nil error:error];
        }];
    } else if (method == DJHRequestMethodPOST) {
        dataTask = [_sessionManager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            [weakSelf handleRequestProgress:dataTask progress:uploadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf handleRequestResult:dataTask responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleRequestResult:dataTask responseObject:nil error:error];
        }];
    } else if (method == DJHRequestMethodHEAD) {
        dataTask = [_sessionManager HEAD:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task) {
            [weakSelf handleRequestResult:dataTask responseObject:nil error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleRequestResult:dataTask responseObject:nil error:error];
        }];
    } else if (method == DJHRequestMethodPUT) {
        dataTask = [_sessionManager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf handleRequestResult:dataTask responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleRequestResult:dataTask responseObject:nil error:error];
        }];
    } else if (method == DJHRequestMethodDELETE) {
        dataTask = [_sessionManager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf handleRequestResult:dataTask responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleRequestResult:dataTask responseObject:nil error:error];
        }];
    } else if (method == DJHRequestMethodPATCH) {
        dataTask = [_sessionManager PATCH:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf handleRequestResult:dataTask responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleRequestResult:dataTask responseObject:nil error:error];
        }];
    }
    
    request.requestTask = dataTask;
    
    //设置请求优先级，iOS8+有效
    if ([request.requestTask respondsToSelector:@selector(priority)]) {
        switch (request.requestPriority) {
            case DJHRequestPriorityHigh:
                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
                break;
            case DJHRequestPriorityLow:
                request.requestTask.priority = NSURLSessionTaskPriorityLow;
                break;
            case DJHRequestPriorityDefault:
                /*!!fall through*/
            default:
                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
                break;
        }
    }
    
    //添加请求记录
    DJHNetworkLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addRequestToRecord:request];
}

/**
 MARK:可恢复下载

 @param downloadPath 下载路径
 @param requestSerializer requestSerializer
 @param URLString 请求URLString
 @param parameters 请求参数
 @param downloadProgressBlock 进度block
 @param error 错误信息
 @return NSURLSessionDownloadTask
 */
- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath
                                         requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                                  progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                     error:(NSError * _Nullable __autoreleasing *)error {
    // add parameters to URL;
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:error];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    // If targetPath is a directory, use the file name we got from the urlRequest.
    // Make sure downloadTargetPath is always a file, not directory.
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    // AFN use `moveItemAtURL` to move downloaded file to target path,
    // this method aborts the move attempt if a file already exist at the path.
    // So we remove the exist file before we start the download task.
    // https://github.com/AFNetworking/AFNetworking/issues/3775
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[[DJHNetworkTool sharedInstance] incompleteDownloadTempPathForDownloadPath:downloadPath].path];
    NSData *data = [NSData dataWithContentsOfURL:[[DJHNetworkTool sharedInstance] incompleteDownloadTempPathForDownloadPath:downloadPath]];
    BOOL resumeDataIsValid = [[DJHNetworkTool sharedInstance] validateResumeData:data];
    
    BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
    BOOL resumeSucceeded = NO;
    __block NSURLSessionDownloadTask *downloadTask = nil;
    // Try to resume with resumeData.
    // Even though we try to validate the resumeData, this may still fail and raise excecption.
    if (canBeResumed) {
        @try {
            downloadTask = [_sessionManager downloadTaskWithResumeData:data progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
            } completionHandler:
                            ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                [self handleRequestResult:downloadTask responseObject:filePath error:error];
                            }];
            resumeSucceeded = YES;
        } @catch (NSException *exception) {
            DJHNetworkLog(@"Resume download failed, reason = %@", exception.reason);
            resumeSucceeded = NO;
        }
    }
    if (!resumeSucceeded) {
        downloadTask = [_sessionManager downloadTaskWithRequest:urlRequest progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
        } completionHandler:
                        ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                            [self handleRequestResult:downloadTask responseObject:filePath error:error];
                        }];
    }
    return downloadTask;
}

//MARK:取消先前添加的请求
- (void)cancelRequest:(DJHBaseRequest *)request {
    if (!request) return;
    
    [request.requestTask cancel];
    
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

//MARK:取消先前添加的所有请求
- (void)cancelAllRequests {
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            DJHBaseRequest *request = _requestsRecord[key];
            Unlock();
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
        }
    }
}

#pragma mark - 请求记录

- (void)addRequestToRecord:(DJHBaseRequest *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(DJHBaseRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    DJHNetworkLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
    Unlock();
}

#pragma mark - 数据处理相关

//MARK:处理请求进度
- (void)handleRequestProgress:(NSURLSessionTask *)task progress:(NSProgress *)progress {
    Lock();
    DJHBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    /*
     当请求被取消，删除记录，底层AFNetworking失败回调仍然会踢，导致零`请求`。
     这里我们选择完全忽略被取消的任务。
     成功与失败的回调都不会被称作
     */
    if (!request) return;
    
    DJHNetworkLog(@"Doing Request: %@", NSStringFromClass([request class]));
    
    [self requestProgressWithRequest:request progress:progress];
}

//MARK:处理请求结果
- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    DJHBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    /*
     当请求被取消，删除记录，底层AFNetworking失败回调仍然会踢，导致零`请求`。
     这里我们选择完全忽略被取消的任务。
     成功与失败的回调都不会被称作
     */
    if (!request) return;
    
    DJHNetworkLog(@"Finished Request: %@", NSStringFromClass([request class]));
    
    NSError * __autoreleasing serializationError = nil;
    NSError * __autoreleasing validationError = nil;
    
    NSError *requestError = nil;
    BOOL succeed = NO;
    
    request.responseObject = responseObject;//默认先不转换
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        request.responseData = responseObject;
        request.responseString = [[NSString alloc] initWithData:responseObject encoding:[[DJHNetworkTool sharedInstance] stringEncodingWithRequest:request]];
        
        switch (request.responseSerializerType) {
            case DJHResponseSerializerTypeHTTP:
                // Default serializer. Do nothing.
                break;
            case DJHResponseSerializerTypeJSON:
                request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                request.responseJSONObject = request.responseObject;
                break;
            case DJHResponseSerializerTypeXMLParser:
                request.responseObject = [self.xmlParserResponseSerialzier responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                break;
        }
    }
    
    if (error) {//有error，请求失败
        succeed = NO;
        requestError = error;
    } else if (serializationError) {//数据转换失败，数据格式不对
        succeed = NO;
        requestError = serializationError;
    } else {//请求成功
        succeed = [[DJHNetworkTool sharedInstance] validateResult:request error:&validationError];
        requestError = validationError;
    }
    
    if (requestError) {
        request.errorDescription = [[DJHNetworkTool sharedInstance] errorDescriptionWithRequestError:requestError];
    }
    
    if (succeed) {
        [self requestDidSucceedWithRequest:request];
    } else {
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
}

//MARK:请求进度触发
- (void)requestProgressWithRequest:(DJHBaseRequest *)request progress:(NSProgress *)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestProgress:request progress:progress];
        }
        if (request.progressBlock) {
            request.progressBlock(request, progress);
        }
    });
}

//MARK:请求成功触发
- (void)requestDidSucceedWithRequest:(DJHBaseRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestFinished:request];
        }
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}

/**
 MARK:请求失败触发

 @param request 请求request
 @param error 错误信息
 */
- (void)requestDidFailWithRequest:(DJHBaseRequest *)request error:(NSError *)error {
    request.error = error;
    DJHNetworkLog(@"Request %@ failed, status code = %ld, error = %@",
           NSStringFromClass([request class]), (long)request.responseStatusCode, error.localizedDescription);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestFailed:request];
        }
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
}

@end
