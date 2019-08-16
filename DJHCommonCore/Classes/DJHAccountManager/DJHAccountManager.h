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

/**
 登录账户

 @param accountId 账户id
 @param completion 回调
 */
- (void)loginWithAccountId:(NSString *)accountId completion:(void (^ __nullable)(void))completion;

@property (strong, nonatomic, readonly, nullable) DJHAccount *loginAccount;//当前登录账户
@property (strong, nonatomic, readonly, nullable) DJHAccount *lastAccount;//最后一次登录的账户
@property (assign, nonatomic) BOOL isLogin;//是否登录

@end

NS_ASSUME_NONNULL_END
