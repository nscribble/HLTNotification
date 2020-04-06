//
//  HLTNotificationDisplayOption.h
//  HLTNotification
//
//  Created by Ryan on 2017/12/17.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 优先级
typedef NSInteger HLTNotificationPriority;
extern NSInteger const HLTNotificationPriorityDefault;
extern NSInteger const HLTNotificationPriorityHigh;
extern NSInteger const HLTNotificationPriorityLow;

@interface HLTNotificationDisplayOption : NSObject

//! 优先级（暂不对优先级处理）
@property (nonatomic, assign) HLTNotificationPriority priority;
//! 正常展示时间
@property (nonatomic, assign) CGFloat duration;
//! 最短展示时间
@property (nonatomic, assign) CGFloat minDuration;
//! 是否独占
@property (nonatomic, assign) BOOL exclusive;

@end

NS_ASSUME_NONNULL_END
