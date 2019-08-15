//
//  DJHAccountManager.h
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJHAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJHAccountManager : NSObject

#pragma mark - 初始化

/**
 MARK:单例
 
 @return DJHAccountManager
 */
+ (DJHAccountManager *)sharedManager;

@property (strong, nonatomic) DJHAccount *loginAccount;//当前登录账户
@property (strong, nonatomic) DJHAccount *lastAccount;//最后一次登录的账户，如果已登录，和loginAccount一样

@end

NS_ASSUME_NONNULL_END
