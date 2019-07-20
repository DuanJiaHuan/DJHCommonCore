//
//  DJHNetworkTool.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/7/19.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHNetworkTool.h"
#import <CommonCrypto/CommonDigest.h>

#define kDJHNetworkIncompleteDownloadFolderName @"DJHNetworkIncomplete"
NSString *const DJHRequestValidationErrorDomain = @"com.djh.request.validation";

void DJHNetworkLog(NSString *format, ...) {
#ifdef DEBUG
    if (![DJHNetworkTool sharedTool].debugLogEnabled) {
        return;
    }
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation DJHNetworkTool

#pragma mark - 初始化

/**
 MARK:单例
 
 @return DJHNetworkTool
 */
+ (DJHNetworkTool *)sharedTool
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 MARK:初始化

 @return DJHNetworkTool
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _debugLogEnabled = NO;
    }
    return self;
}

#pragma mark - tool

/**
 MARK:md5加密字符串

 @param string 要加密的字符串
 @return 加密后的字符串
 */
- (NSString *)md5StringFromString:(NSString *)string
{
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

/**
 MARK:验证json数据

 @param json json数据
 @param jsonValidator 验证字段
 @return 验证结果
 */
- (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator
{
    if ([json isKindOfClass:[NSDictionary class]] &&
        [jsonValidator isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = json;
        NSDictionary * validator = jsonValidator;
        BOOL result = YES;
        NSEnumerator * enumerator = [validator keyEnumerator];
        NSString * key;
        while ((key = [enumerator nextObject]) != nil) {
            id value = dict[key];
            id format = validator[key];
            if ([value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSArray class]]) {
                result = [self validateJSON:value withValidator:format];
                if (!result) {
                    break;
                }
            } else {
                if ([value isKindOfClass:format] == NO &&
                    [value isKindOfClass:[NSNull class]] == NO) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    } else if ([json isKindOfClass:[NSArray class]] &&
               [jsonValidator isKindOfClass:[NSArray class]]) {
        NSArray * validatorArray = (NSArray *)jsonValidator;
        if (validatorArray.count > 0) {
            NSArray * array = json;
            NSDictionary * validator = jsonValidator[0];
            for (id item in array) {
                BOOL result = [self validateJSON:item withValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([json isKindOfClass:jsonValidator]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 MARK:验证结果

 @param request 请求request
 @param error 错误信息
 @return 验证结果
 */
- (BOOL)validateResult:(DJHBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error
{
    BOOL result = [request statusCodeValidator];
    if (!result) {
        if (error) {
            *error = [NSError errorWithDomain:DJHRequestValidationErrorDomain code:DJHRequestValidationErrorInvalidStatusCode userInfo:@{NSLocalizedDescriptionKey:@"无效的状态码"}];
        }
        return result;
    }
    id json = [request responseJSONObject];
    id validator = nil;
    if (json && validator) {
        result = [self validateJSON:json withValidator:validator];
        if (!result) {
            if (error) {
                *error = [NSError errorWithDomain:DJHRequestValidationErrorDomain code:DJHRequestValidationErrorInvalidJSONFormat userInfo:@{NSLocalizedDescriptionKey:@"无效的JSON格式"}];
            }
            return result;
        }
    }
    return YES;
}

/**
 NSStringEncoding

 @param request 请求request
 @return NSStringEncoding
 */
- (NSStringEncoding)stringEncodingWithRequest:(DJHBaseRequest *)request
{
    // From AFNetworking 2.6.3
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    if (request.response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)request.response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    return stringEncoding;
}

/**
 MARK:请求错误信息描述

 @param requestError 错误信息
 @return 错误信息秒速
 */
- (NSString *)errorDescriptionWithRequestError:(NSError *)requestError
{
    if (requestError.code == NSURLErrorNotConnectedToInternet) {
        return @"无网络连接";
    } else if (requestError.code == NSURLErrorTimedOut) {
        return @"网络不给力，请稍后再试";
    } else if (requestError.code == NSURLErrorBadServerResponse) {
        return @"服务器响应异常";
    } else if (requestError.code == NSURLErrorNetworkConnectionLost) {
        return @"网络连接异常";
    } else if (requestError.code == NSURLErrorBadServerResponse) {
        return @"服务器响应异常";
    } else if (requestError.code == DJHRequestValidationErrorInvalidStatusCode) {
        return @"无效的状态码";
    } else if (requestError.code == DJHRequestValidationErrorInvalidJSONFormat) {
        return @"无效的JSON格式";
    } else {
        return @"网络请求失败，请稍后再试";
    }
}

#pragma mark - Resumable Download

/**
 MARK:返回可恢复数据文件path url

 @param downloadPath 下载路径
 @return 下载路径
 */
- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath
{
    NSString *tempPath = nil;
    NSString *md5URLString = [self md5StringFromString:downloadPath];
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    return [NSURL fileURLWithPath:tempPath];
}

/**
 MARK:返回可恢复数据文件夹

 @return 文件夹路径
 */
- (NSString *)incompleteDownloadTempCacheFolder
{
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:kDJHNetworkIncompleteDownloadFolderName];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        DJHNetworkLog(@"Failed to create cache directory at %@", cacheFolder);
        cacheFolder = nil;
    }
    return cacheFolder;
}

/**
 验证可恢复数据

 @param data 数据
 @return 验证结果
 */
- (BOOL)validateResumeData:(NSData *)data
{
    // From http://stackoverflow.com/a/22137510/3562486
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    
    // Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
    // After iOS 9 we can not actually detects if the cache file exists. This plist file has a somehow
    // complicated structue. Besides, the plist structure is different between iOS 9 and iOS 10.
    // We can only assume that the plist being successfully parsed means the resume data is valid.
    return YES;
}

@end
