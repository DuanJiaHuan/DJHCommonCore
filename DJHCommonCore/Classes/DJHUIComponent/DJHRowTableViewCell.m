//
//  DJHRowTableViewCell.m
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHRowTableViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

@implementation DJHRowTableViewCell

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
        _rowTitleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_rowTitleLabel];
        
        [_rowTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rowIconImgView.mas_right).offset(12);
            make.right.equalTo(self.rowDetailLabel.mas_left).offset(-10);
            make.height.mas_equalTo(22);
            make.center.equalTo(self.contentView);
        }];
    }
    
    return _rowTitleLabel;
}

- (UILabel *)rowDetailLabel
{
    if (_rowDetailLabel == nil) {
        _rowDetailLabel = [[UILabel alloc] init];
        _rowDetailLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_rowDetailLabel];
        
        [_rowDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rowTitleLabel.mas_right).offset(10);
            make.right.equalTo(self.rowNextImgView.mas_left).offset(-10);
            make.height.mas_equalTo(22);
            make.center.equalTo(self.contentView);
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
            make.right.equalTo(self.contentView).offset(-17);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
            make.center.equalTo(self.contentView);
        }];
    }
    
    return _rowNextImgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
