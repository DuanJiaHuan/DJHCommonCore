//
//  DJHRowTableViewCell.h
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJHRowTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *rowTitleLabel;
@property (strong, nonatomic) UILabel *rowDetailLabel;
@property (strong, nonatomic) UIImageView *rowIconImgView;
@property (strong, nonatomic) UIImageView *rowNextImgView;

@end

NS_ASSUME_NONNULL_END
