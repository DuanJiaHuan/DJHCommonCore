//
//  DJHTheme.m
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHTheme.h"
#import <YYKit/YYKit.h>

@implementation DJHTheme

#pragma mark - getter

- (UIColor *)navigationBackgroundColor
{
    if (_navigationBackgroundColor == nil) {
        _navigationBackgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];//默认选择
    }
    
    return _navigationBackgroundColor;
}

- (UIColor *)navigationItemColor
{
    if (_navigationItemColor == nil) {
        _navigationItemColor = [UIColor colorWithHexString:@"#333333"];//默认选择
    }
    
    return _navigationItemColor;
}

- (UIColor *)navigationTitleColor
{
    if (_navigationTitleColor == nil) {
        _navigationTitleColor = [UIColor colorWithHexString:@"#333333"];//默认选择
    }
    
    return _navigationTitleColor;
}

- (UIColor *)projectMainColor
{
    if (_projectMainColor == nil) {
        _projectMainColor = [UIColor colorWithHexString:@"#4CAF50"];//默认选择
    }
    
    return _projectMainColor;
}

- (UIColor *)textBlackColor
{
    if (_textBlackColor == nil) {
        _textBlackColor = [UIColor colorWithHexString:@"#333333"];//默认选择
    }
    
    return _textBlackColor;
}

- (UIColor *)textGrayColor
{
    if (_textGrayColor == nil) {
        _textGrayColor = [UIColor colorWithHexString:@"#999999"];//默认选择
    }
    
    return _textGrayColor;
}

- (UIColor *)viewBackgroundColor
{
    if (_viewBackgroundColor == nil) {
        _viewBackgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];//默认选择
    }
    
    return _viewBackgroundColor;
}

- (UIColor *)tableViewBackgroundColor
{
    if (_tableViewBackgroundColor == nil) {
        _tableViewBackgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];//默认选择
    }
    
    return _tableViewBackgroundColor;
}

@end
