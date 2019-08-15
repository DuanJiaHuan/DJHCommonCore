//
//  DJHBaseTableViewController.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJHBaseTableViewController : DJHBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
