//
//  DJHProjectConfig.h
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJHTheme.h"

#define DJHDeviceIsIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define DJHNavigationHeight (DJHDeviceIsIPhoneX ? 88:64)//适配X导航栏高度
#define DJHStatusBarHeight (DJHDeviceIsIPhoneX ? 44:20)//适配X导航栏高度

NS_ASSUME_NONNULL_BEGIN

@interface DJHProjectConfig : NSObject

#pragma mark - 初始化

/**
 MARK:单例
 
 @return DJHProjectConfig
 */
+ (DJHProjectConfig *)sharedInstance;

/**
 MARK:主题
 */
@property (strong, nonatomic) DJHTheme *theme;

@end

NS_ASSUME_NONNULL_END
