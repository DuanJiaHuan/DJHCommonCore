//
//  DJHAccount.h
//  DJHCommonCore
//
//  Created by duanjiahuan on 2019/8/15.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJHAccount : NSObject

- (instancetype)initWithAccountId:(NSString *)accountId;

@property (copy, nonatomic) NSString *accountId;//唯一性
@property (copy, nonatomic) NSString *userId;

@end

NS_ASSUME_NONNULL_END
