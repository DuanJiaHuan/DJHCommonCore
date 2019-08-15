//
//  DJHThemeStyleManager.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHThemeStyleManager.h"

@implementation DJHThemeStyleManager

#pragma mark - 初始化

/**
 MARK:单例
 
 @return DJHThemeStyleManager
 */
+ (DJHThemeStyleManager *)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 MARK:初始化
 
 @return DJHThemeStyleManager
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - getter

- (DJHTheme *)theme
{
    if (_theme == nil) {
        _theme = [[DJHTheme alloc] init];
    }
    
    return _theme;
}

@end
