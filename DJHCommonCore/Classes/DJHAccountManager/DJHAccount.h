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

@property (nonatomic, copy) NSString *accountId;//唯一性

- (instancetype)initWithAccountId:(NSString *)accountId;

@end

NS_ASSUME_NONNULL_END
