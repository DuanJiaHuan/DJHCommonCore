//
//  DJHAccountManager.m
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHAccountManager.h"

#define DJHLastAccountKey @"DJHLastAccountKey"

@interface DJHAccountManager ()

@property (strong, nonatomic, readwrite, nullable) DJHAccount *loginAccount;//当前登录账户
@property (strong, nonatomic, readwrite, nullable) DJHAccount *lastAccount;//最后一次登录的账户

@end

@implementation DJHAccountManager

#pragma mark - 初始化

/**
 MARK:单例
 
 @return DJHAccountManager
 */
+ (DJHAccountManager *)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 MARK:初始化
 
 @return DJHAccountManager
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)loginWithAccountId:(NSString *)accountId completion:(void (^ __nullable)(void))completion
{
    accountId = [NSString stringWithFormat:@"%@", accountId];
    if (accountId.length == 0) {
        completion();
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:accountId forKey:DJHLastAccountKey];
    
    self.isLogin = YES;
    completion();
}

- (void)logoutAccountCompletion:(void (^)(void))completion
{
    self.loginAccount = nil;
    self.isLogin = NO;
    completion();
}

#pragma mark - getter

- (DJHAccount *)loginAccount
{
    if (_loginAccount == nil) {
        if (self.isLogin) {
            NSString *accountId = [[NSUserDefaults standardUserDefaults] valueForKey:DJHLastAccountKey];
            _loginAccount = [[DJHAccount alloc] initWithAccountId:accountId];
        }
    }
    
    return _loginAccount;
}

- (DJHAccount *)lastAccount
{
    if (_lastAccount) {
        NSString *accountId = [[NSUserDefaults standardUserDefaults] valueForKey:DJHLastAccountKey];
        _lastAccount = [[DJHAccount alloc] initWithAccountId:accountId];
    }
    
    return _lastAccount;
}

@end
