//
//  DJHAccount.m
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import "DJHAccount.h"

static NSString *DJHAccountDefaultKey(NSString *accountId) {
    return [NSString stringWithFormat:@"DJHAccount_%@", accountId];
}

@interface DJHAccount ()

@property (nonatomic, strong) NSMutableArray *propertyNamesArray;

@end

@implementation DJHAccount

- (void)dealloc
{
    [self.propertyNamesArray enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:self forKeyPath:key];
    }];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return  @{@"uid":@"id"};
}

- (instancetype)initWithAccountId:(NSString *)accountId
{
    self = [super init];
    if (self) {
        if (accountId.length > 0) {
            [self setupAccountWithAccountId:accountId];
        }
    }
    
    return self;
}

- (void)setupAccountWithAccountId:(NSString *)accountId
{
    self.propertyNamesArray = [NSMutableArray array];
    self.accountId = accountId;
    
    //获取所有属性
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    
    //获取缓存的值进行初始化
    NSDictionary *accountDict = [[NSUserDefaults standardUserDefaults] valueForKey:DJHAccountDefaultKey(accountId)];
    
    for (NSInteger i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
        
        id value = accountDict[propertyName];
        if(value) {
            [self setValue:value forKey:propertyName];
        }
        
        //add KVO
        [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:nil];
        
        //添加到数组当中
        [self.propertyNamesArray addObject:propertyName];
    }
    free(properties);
}

#pragma makr - KVO method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSDictionary *accountDict = [[NSUserDefaults standardUserDefaults] valueForKey:DJHAccountDefaultKey(self.accountId)];
    NSMutableDictionary *tempAccountDict = [NSMutableDictionary dictionaryWithDictionary:accountDict];
    
    id value = [self valueForKey:keyPath];
    [tempAccountDict setValue:value forKey:keyPath];
    [[NSUserDefaults standardUserDefaults] setValue:tempAccountDict forKey:DJHAccountDefaultKey(self.accountId)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
