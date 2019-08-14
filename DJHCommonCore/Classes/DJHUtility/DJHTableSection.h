//
//  DJHTableSection.h
//  DJHCommonCore
//
//  Created by 段佳欢 on 2019/8/14.
//  Copyright © 2019 duanjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJHTableRow : NSObject

@property (copy, nonatomic) NSString *rowTitle;
@property (copy, nonatomic) NSString *rowSubTitle;
@property (copy, nonatomic) NSString *rowDetail;
@property (copy, nonatomic) NSString *rowIconName;

@end

@interface DJHTableSection : NSObject

@property (copy, nonatomic) NSString *sectionTitle;
@property (strong, nonatomic) NSArray *sectionRows;

@end

NS_ASSUME_NONNULL_END
