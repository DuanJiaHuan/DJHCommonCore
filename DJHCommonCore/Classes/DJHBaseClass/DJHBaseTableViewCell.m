//
//  DJHBaseTableViewCell.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHBaseTableViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

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
        _rowTitleLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:_rowTitleLabel];
    }
    
    return _rowTitleLabel;
}

- (UILabel *)rowDetailLabel
{
    if (_rowDetailLabel == nil) {
        _rowDetailLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:_rowDetailLabel];
        
        [_rowIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.left.equalTo(self.contentView).offset(16);
            make.width.mas_equalTo(self->_rowIconImgView.mas_height).multipliedBy(1);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
    }
    
    return _rowDetailLabel;
}

- (UIImageView *)rowIconImgView
{
    if (_rowIconImgView == nil) {
        _rowIconImgView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_rowIconImgView];
        
        [_rowIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.left.equalTo(self.contentView).offset(16);
            make.width.mas_equalTo(self->_rowIconImgView.mas_height).multipliedBy(1);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
    }
    
    return _rowIconImgView;
}

- (UIImageView *)rowNextImgView
{
    if (_rowNextImgView == nil) {
        _rowNextImgView = [[UIImageView alloc] init];
        _rowNextImgView.image = [UIImage imageNamed:@"general_icon_right"];
        
        [self.contentView addSubview:_rowNextImgView];
        
        [_rowNextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.left.equalTo(self.contentView).offset(16);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
            make.center.mas_equalTo(self.contentView);
        }];
    }
    
    return _rowNextImgView;
}

#pragma mark - setter

- (void)setNoRowIcon:(BOOL)noRowIcon
{
    _noRowIcon = noRowIcon;
    if (noRowIcon) {
        _rowIconImgView.frame = CGRectZero;
    } else {
        CGFloat rowIconHeight = self.contentView.frame.size.height/48*22;
        CGFloat rowIconWidth = rowIconHeight;
        _rowIconImgView.frame = CGRectMake(16, (self.contentView.frame.size.height - rowIconHeight)/2, rowIconWidth, rowIconHeight);
    }
}

- (void)setNoRowNext:(BOOL)noRowNext
{
    _noRowNext = noRowNext;
    if (noRowNext) {
        _rowNextImgView.frame = CGRectZero;
    } else {
        _rowNextImgView.frame = CGRectMake(self.contentView.frame.size.width - 16 - 14, (self.contentView.frame.size.height - 14)/2, 14, 14);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
