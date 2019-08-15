//
//  DJHProjectConfig.m
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHProjectConfig.h"

@implementation DJHProjectConfig

#pragma mark - 初始化

/**
 MARK:单例
 
 @return DJHProjectConfig
 */
+ (DJHProjectConfig *)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 MARK:初始化
 
 @return DJHProjectConfig
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

@end
