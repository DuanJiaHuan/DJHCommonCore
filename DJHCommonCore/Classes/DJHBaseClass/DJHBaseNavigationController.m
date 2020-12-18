//
//  DJHBaseNavigationController.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/6.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseNavigationController.h"
#import "DJHProjectConfig.h"

@interface DJHBaseNavigationController ()

@end

@implementation DJHBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[DJHProjectConfig sharedInstance].theme.navigationTitleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
