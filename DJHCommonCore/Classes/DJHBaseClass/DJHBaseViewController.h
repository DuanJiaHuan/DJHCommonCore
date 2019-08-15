//
//  DJHBaseViewController.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/6.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJHBaseViewController : UIViewController

/**
 建立初始视图
 */
- (void)buildView;
//返回按钮
@property (strong, nonatomic, nullable) UIBarButtonItem *backBarButtonItem;
//当前导航栏是否隐藏，默认NO
@property (assign, nonatomic) BOOL currentNavigationBarHidden;
//当前导航栏是否透明，默认NO
@property (assign, nonatomic) BOOL currentNavigationBarTransparent;
//当前导航栏背景颜色
@property (strong, nonatomic) UIImage *currentNavigationBarBackgroundImage;

@end

NS_ASSUME_NONNULL_END
