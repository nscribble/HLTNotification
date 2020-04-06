//
//  HLTNotificationDisplayOption.m
//  HLTNotification
//
//  Created by Ryan on 2017/12/17.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationDisplayOption.h"

NSInteger const HLTNotificationPriorityDefault  = 1000;
NSInteger const HLTNotificationPriorityHigh     = 9999;
NSInteger const HLTNotificationPriorityLow      = 100;

@implementation HLTNotificationDisplayOption

- (instancetype)init {
    if (self = [super init]) {
        _duration = 10; // 正常展示10s
        _minDuration = 10;// 最短展示
        _exclusive = NO;
    }
    
    return self;
}

@end
