//
//  DJHBaseTabBarController.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/6.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseTabBarController.h"
#import "DJHBaseNavigationController.h"

@interface DJHBaseTabBarController ()

@end

@implementation DJHBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

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
                           vcSelectedTitleColor:(UIColor *)vcSelectedTitleColor
{
    for (int i = 0; i < vcArray.count; i++) {
        UIViewController *viewController = vcArray[i];
        if (i < vcTitleArray.count) viewController.title = vcTitleArray[i];
        
        //设置图片
        if (i < vcNormalImgArray.count) viewController.tabBarItem.image = [[UIImage imageNamed:vcNormalImgArray[i]] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        if (i < vcSelectedImgArray.count) viewController.tabBarItem.selectedImage = [[UIImage imageNamed:vcSelectedImgArray[i]] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        
        //设置文字
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:vcNormalTitleColor, NSFontAttributeName:vcTitleFont} forState:(UIControlStateNormal)];
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:vcSelectedTitleColor, NSFontAttributeName:vcTitleFont} forState:(UIControlStateSelected)];
        
        DJHBaseNavigationController *navigationController = [[DJHBaseNavigationController alloc] initWithRootViewController:viewController];
        [self addChildViewController:navigationController];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
