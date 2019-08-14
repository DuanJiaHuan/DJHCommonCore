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
        _navigationBackgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    
    return _navigationBackgroundColor;
}

- (UIColor *)navigationItemColor
{
    if (_navigationItemColor == nil) {
        _navigationItemColor = [UIColor colorWithHexString:@"#333333"];
    }
    
    return _navigationItemColor;
}

- (UIColor *)projectMainColor
{
    if (_projectMainColor == nil) {
        _projectMainColor = [UIColor colorWithHexString:@"#4CAF50"];
    }
    
    return _projectMainColor;
}

- (UIColor *)textBlackColor
{
    if (_textBlackColor == nil) {
        _textBlackColor = [UIColor colorWithHexString:@"#333333"];
    }
    
    return _textBlackColor;
}

- (UIColor *)textGrayColor
{
    if (_textGrayColor == nil) {
        _textGrayColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    return _textGrayColor;
}

@end
