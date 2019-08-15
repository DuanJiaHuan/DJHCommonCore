//
//  DJHBaseTableViewCell.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJHBaseTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *rowTitleLabel;
@property (strong, nonatomic) UILabel *rowDetailLabel;
@property (strong, nonatomic) UIImageView *rowIconImgView;
@property (strong, nonatomic) UIImageView *rowNextImgView;
@property (assign, nonatomic) BOOL noRowIcon;
@property (assign, nonatomic) BOOL noRowNext;

@end

NS_ASSUME_NONNULL_END
