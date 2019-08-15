//
//  DJHBaseViewController.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/6.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseViewController.h"
#import <YYKit/YYKit.h>

@interface DJHBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation DJHBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"---viewWillAppear:%@--", [self class]);
    //当前导航栏是否隐藏，默认NO
    [self.navigationController setNavigationBarHidden:self.currentNavigationBarHidden animated:animated];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"---viewDidAppear:%@--", [self class]);
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"---viewWillDisappear:%@--", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.navigationController.navigationBar.translucent = NO;
    
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
    
    //禁止自动偏移，从零开始
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self buildView];
}

- (void)buildView
{
    //子类中重写
}

#pragma mark - getter

- (UIBarButtonItem *)backBarButtonItem
{
    if (_backBarButtonItem == nil) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [backButton addTarget:self action:@selector(backBarButtonItemClick) forControlEvents:(UIControlEventTouchUpInside)];
        backButton.backgroundColor = [UIColor redColor];
        
        UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 22, 22)];
        backImgView.image = [UIImage imageNamed:@"head_icon_back"];
        [backButton addSubview:backImgView];
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    return _backBarButtonItem;
}

- (void)backBarButtonItemClick
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL isRootViewController = (self == self.navigationController.viewControllers.firstObject || self.parentViewController.navigationController.viewControllers.firstObject);
    
    if (isRootViewController) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
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
