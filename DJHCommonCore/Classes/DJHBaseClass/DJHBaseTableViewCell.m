//
//  DJHBaseTableViewCell.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseTableViewCell.h"

@implementation DJHBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - getter

- (UILabel *)rowTitleLabel
{
    if (_rowTitleLabel == nil) {
        _rowTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.contentView addSubview:_rowTitleLabel];
    }
    
    return _rowTitleLabel;
}

- (UILabel *)rowSubTitleLabel
{
    if (_rowSubTitleLabel == nil) {
        _rowSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.contentView addSubview:_rowSubTitleLabel];
    }
    
    return _rowSubTitleLabel;
}

- (UILabel *)rowDetailLabel
{
    if (_rowDetailLabel == nil) {
        _rowDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.contentView addSubview:_rowDetailLabel];
    }
    
    return _rowDetailLabel;
}

- (UIImageView *)rowIconImgView
{
    if (_rowIconImgView == nil) {
        _rowIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.contentView addSubview:_rowIconImgView];
    }
    
    return _rowIconImgView;
}

- (UIImageView *)rowNextImgView
{
    if (_rowNextImgView == nil) {
        _rowNextImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.contentView addSubview:_rowNextImgView];
    }
    
    return _rowNextImgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
