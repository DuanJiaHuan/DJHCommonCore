//
//  DJHAccountManager.m
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHAccountManager.h"

#define DJHLastAccountKey @"DJHLastAccountKey"

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

- (void)loginWithAccountId:(NSString *)accountId
{
    accountId = [NSString stringWithFormat:@"%@", accountId];
    if (accountId.length == 0) return;
    
    [[NSUserDefaults standardUserDefaults] setValue:accountId forKey:DJHLastAccountKey];
}

- (void)logoutAccount
{
    
}

#pragma mark - getter

- (DJHAccount *)loginAccount
{
    if (_loginAccount == nil) {
        _loginAccount = [[DJHAccount alloc] init];
    }
    
    return _loginAccount;
}

@end
