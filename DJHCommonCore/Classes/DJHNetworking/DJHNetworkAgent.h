//
//  DJHNetworkAgent.h
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/7/18.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface DJHNetworkAgent ()

{
    AFHTTPSessionManager *_sessionManager;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
    NSMutableDictionary<NSNumber *, DJHBaseRequest *> *_requestsRecord;
    
    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;
}

@end

@interface DJHNetworkAgent : NSObject

@end

NS_ASSUME_NONNULL_END
