//
//  DJHBaseTabBarController.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/6.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJHBaseTabBarController : UITabBarController

/**
 设置tabBar底部按钮显示
 
 @param vcArray vc数组
 @param vcNormalImgArray 正常图片数组
 @param vcSelectedImgArray 选中图片数组
 @param vcTitleArray 标题数组
 @param vcTitleFont 标题字体
 @param vcNormalTitleColor 标题正常颜色
 @param vcSelectedTitleColor 标题选中颜色
 */
- (void)setTabBarChildViewControllerWithVCArray:(NSArray *)vcArray
                               vcNormalImgArray:(NSArray *)vcNormalImgArray
                             vcSelectedImgArray:(NSArray *)vcSelectedImgArray
                                   vcTitleArray:(NSArray *)vcTitleArray
                                    vcTitleFont:(UIFont *)vcTitleFont
                             vcNormalTitleColor:(UIColor *)vcNormalTitleColor
                           vcSelectedTitleColor:(UIColor *)vcSelectedTitleColor;

@end

NS_ASSUME_NONNULL_END
