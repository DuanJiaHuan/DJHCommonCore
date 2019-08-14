//
//  DJHThemeStyleManager.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJHTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJHThemeStyleManager : NSObject

#pragma mark - 初始化

/**
 MARK:单例
 
 @return DJHThemeStyleManager
 */
+ (DJHThemeStyleManager *)sharedManager;

@property (strong, nonatomic) DJHTheme *theme;

@end

NS_ASSUME_NONNULL_END
