//
//  DJHBaseRequest.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/7/19.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//  说明：请求request的配置数据对象，每一个请求对应一个独立的request对象

#import <Foundation/Foundation.h>

#pragma mark - 枚举类型

/**
 MARK:无效错误

 - DJHRequestValidationErrorInvalidStatusCode: 无效状态码
 - DJHRequestValidationErrorInvalidJSONFormat: 无效json格式
 */
NS_ENUM(NSInteger) {
    DJHRequestValidationErrorInvalidStatusCode = -8,
    DJHRequestValidationErrorInvalidJSONFormat = -9,
};

/**
 MARK:请求优先级

 - DJHRequestPriorityLow: 低
 - DJHRequestPriorityDefault: 默认
 - DJHRequestPriorityHigh: 高
 */
typedef NS_ENUM(NSInteger, DJHRequestPriority) {
    DJHRequestPriorityLow = -4L,
    DJHRequestPriorityDefault = 0,
    DJHRequestPriorityHigh = 4,
};

/**
 MARK:HTTP请求方式

 - DJHRequestMethodGET: get请求
 - DJHRequestMethodPOST: post请求
 - DJHRequestMethodHEAD: head请求
 - DJHRequestMethodPUT: put请求
 - DJHRequestMethodDELETE: delete请求
 - DJHRequestMethodPATCH: patch请求
 - DJHRequestMethodDOWNLOAD: download请求
 */
typedef NS_ENUM(NSInteger, DJHRequestMethod) {
    DJHRequestMethodGET = 0,
    DJHRequestMethodPOST,
    DJHRequestMethodHEAD,
    DJHRequestMethodPUT,
    DJHRequestMethodDELETE,
    DJHRequestMethodPATCH,
    DJHRequestMethodDOWNLOAD,
};

/**
 MARK:请求序列化类型

 - DJHRequestSerializerTypeHTTP: http类型
 - DJHRequestSerializerTypeJSON: json类型
 */
typedef NS_ENUM(NSInteger, DJHRequestSerializerType) {
    DJHRequestSerializerTypeHTTP = 0,
    DJHRequestSerializerTypeJSON,
};

/**
 MARK:响应序列化类型
 */
typedef NS_ENUM(NSInteger, DJHResponseSerializerType) {
    //JSON object type
    DJHResponseSerializerTypeJSON = 0,
    //NSData type
    DJHResponseSerializerTypeHTTP,
    //NSXMLParser type
    DJHResponseSerializerTypeXMLParser,
};

#pragma mark - 请求完成block

@class DJHBaseRequest;
/**
 MARK:请求完成block

 @param request 请求request
 */
typedef void(^DJHRequestCompletionBlock)(__kindof DJHBaseRequest * _Nullable request);

/**
 MARK:请求进度block

 @param request 请求request
 @param progress 请求进度
 */
typedef void(^DJHRequestProgressBlock)(__kindof DJHBaseRequest * _Nullable request, __kindof NSProgress * _Nullable progress);

#pragma mark - 请求完成代理，接收请求相关信息，方法将被调用在主队列上

@protocol DJHRequestDelegate <NSObject>
@optional

/**
 MARK:告诉委托人请求已成功完成

 @param request 请求request
 */
- (void)requestFinished:(__kindof DJHBaseRequest *_Nullable)request;

/**
 MARK:告诉委托人请求失败了

 @param request 请求request
 */
- (void)requestFailed:(__kindof DJHBaseRequest *_Nullable)request;

/**
 MARK:告诉委托人请求进度
 
 @param request 请求request
 @param progress 进度
 */
- (void)requestProgress:(__kindof DJHBaseRequest *_Nullable)request progress:(__kindof NSProgress *_Nullable)progress;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DJHBaseRequest : NSObject

#pragma mark - 请求参数

/**
 MARK:域名地址，默认@""
 */
@property (copy, nonatomic, nullable) NSString *baseUrlString;
/**
 MARK:接口地址，默认@""，如果requestUrl包含baseUrl，则直接使用requestUrl
 */
@property (copy, nonatomic, nullable) NSString *requestUrlString;
/**
 MARK:cdn地址，默认@""
 */
@property (copy, nonatomic, nullable) NSString *cdnUrlString;
/**
 MARK:请求超时时间，默认40s
 */
@property (assign, nonatomic) NSTimeInterval requestTimeoutInterval;
/**
 MARK:请求参数，如果加密，需提前设置
 */
@property (nonatomic, nullable) id parameters;
/**
 MARK:是否使用cdn，默认NO
 */
@property (assign, nonatomic) BOOL useCDN;
/**
 MARK:请求是否允许使用蜂窝无线电（如果存在的话），默认为YES
 */
@property (assign, nonatomic) BOOL allowsCellularAccess;
/**
 MARK:请求优先级，默认DJHRequestPriorityDefault
 */
@property (assign, nonatomic) DJHRequestPriority requestPriority;
/**
 MARK:请求方式，默认DJHRequestMethodGet
 */
@property (assign, nonatomic) DJHRequestMethod requestMethod;
/**
 MARK:请求序列化类型，默认DJHRequestSerializerTypeHTTP
 */
@property (assign, nonatomic) DJHRequestSerializerType requestSerializerType;
/**
 MARK:响应序列化类型，默认DJHResponseSerializerTypeJSON
 */
@property (assign, nonatomic) DJHResponseSerializerType responseSerializerType;
/**
 MARK:Username and password used for HTTP authorization. Should be formed as @[@"Username", @"Password"].
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *requestAuthorizationHeaderFieldArray;
/**
 MARK:Additional HTTP request header field.
 */
@property (strong, nonatomic, nullable) NSDictionary<NSString *, NSString *> *requestHeaderFieldValueDictionary;
/**
 MARK:可恢复下载路径，当需要下载文件时传入
 */
@property (strong, nonatomic, nullable) NSString *resumableDownloadPath;
/**
 MARK:获取请求的urlString，子类可以重写该方法，实现自定义请求urlString

 @return 完整请求的urlString
 */
- (NSString *)buildRequestUrlString;

#pragma mark - 返回Response信息，只读属性

/**
 MARK:这个值实际上是零，在请求开始之前不应该被访问
 */
@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *requestTask;
/**
 MARK:返回状态码，这里的状态码是http请求返回的，如200，404等
 */
@property (assign, nonatomic, readonly) NSInteger responseStatusCode;
/**
 MARK:响应快捷方式
 */
@property (strong, nonatomic, readonly, nullable) NSHTTPURLResponse *response;
/**
 MARK:返回原始数据，后台定义的成功或错误信息都在这里面，需根据具体情况解析
 */
@property (strong, nonatomic, readonly, nullable) NSData *responseData;
/**
 MARK:返回原始数据字符串表示形式
 */
@property (strong, nonatomic, readonly, nullable) NSString *responseString;
/**
 MARK:根据DJHResponseSerializerType返回的使用数据
 */
@property (strong, nonatomic, readonly, nullable) id responseObject;
/**
 MARK:使用DJHResponseSerializerTypeJSON转换后json数据
 */
@property (strong, nonatomic, readonly, nullable) id responseJSONObject;
/**
 MARK:错误信息
 */
@property (strong, nonatomic, readonly, nullable) NSError *error;
/**
 MARK:错误信息描述
 */
@property (copy, nonatomic, readonly, nullable) NSString *errorDescription;
/**
 MARK:状态码是否有效
 */
@property (assign, nonatomic, readonly) BOOL statusCodeValidator;

#pragma mark - 请求Action

/**
 MARK:附加自请求队列并启动请求
 */
- (void)start;

/**
 MARK:从请求队列中删除自身并取消请求
 */
- (void)stop;

/**
 MARK:使用块回调启动请求的方便方法
 
 @param success 成功block
 @param failure 失败block
 @param progress 进度block
 */
- (void)startWithCompletionBlockWithSuccess:(nullable DJHRequestCompletionBlock)success
                                    failure:(nullable DJHRequestCompletionBlock)failure
                                   progress:(nullable DJHRequestProgressBlock)progress;

#pragma mark - 请求完成触发

/**
 MARK:代理
 */
@property (weak, nonatomic, nullable) id <DJHRequestDelegate> delegate;
/**
 MARK:成功的回调
 */
@property (copy, nonatomic, nullable) DJHRequestCompletionBlock successCompletionBlock;
/**
 MARK:失败的回调
 */
@property (copy, nonatomic, nullable) DJHRequestCompletionBlock failureCompletionBlock;
/**
 MARK:进度的回调
 */
@property (copy, nonatomic, nullable) DJHRequestProgressBlock progressBlock;
/**
 MARK:清除回调
 */
- (void)clearCompletionBlock;

@end

NS_ASSUME_NONNULL_END
