//
//  HLTNotification+Private.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/18.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotification.h"

@interface HLTNotification (Private)

//! 开始展示时间
@property (nonatomic,assign) NSTimeInterval presentTime;

//! 优先级（暂不对优先级处理）
@property (nonatomic,assign,readonly) CGFloat priority;
//! 正常展示时间
@property (nonatomic,assign,readonly) CGFloat duration;
//! 最短展示时间
@property (nonatomic,assign,readonly) CGFloat minDuration;
//! 是否独占
@property (nonatomic,assign,readonly) BOOL isExclusive;

@end
