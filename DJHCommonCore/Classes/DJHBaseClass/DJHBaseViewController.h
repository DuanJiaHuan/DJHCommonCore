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

@property (strong, nonatomic) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
