//
//  DJHTheme.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJHTheme : NSObject

@property (strong, nonatomic) UIColor *navigationBackgroundColor;//导航背景颜色
@property (strong, nonatomic) UIColor *navigationItemColor;//导航按钮颜色
@property (strong, nonatomic) UIColor *navigationTitleColor;//导航标题颜色
@property (strong, nonatomic) UIColor *projectMainColor;//工程主色调
@property (strong, nonatomic) UIColor *textBlackColor;//黑色字体
@property (strong, nonatomic) UIColor *textGrayColor;//灰色字体
@property (strong, nonatomic) UIColor *viewBackgroundColor;//视图背景颜色
@property (strong, nonatomic) UIColor *tableViewBackgroundColor;//列表视图背景颜色

@end

NS_ASSUME_NONNULL_END
