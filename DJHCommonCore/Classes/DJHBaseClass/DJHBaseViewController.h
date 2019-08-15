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

- (void)buildView;

@property (strong, nonatomic) UIBarButtonItem *backBarButtonItem;

//当前导航栏是否隐藏，默认NO
@property (assign, nonatomic) BOOL currentNavigationBarHidden;
//当前导航栏是否透明，默认NO
@property (assign, nonatomic) BOOL currentNavigationBarTransparent;

@end

NS_ASSUME_NONNULL_END
