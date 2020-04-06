//
//  HLTNotificationRequest.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationRequest.h"
#import "HLTNotificationContent.h"

@interface HLTNotificationRequest ()

@property (nonatomic, strong) HLTNotificationContent *content;

@end

@implementation HLTNotificationRequest

- (instancetype)initWithPayload:(NSDictionary *)payload {
    if (self = [super init]) {
        _content = [HLTNotificationContent contentWithPayload:payload];
        HLTNotificationDisplayOption *option = [[HLTNotificationDisplayOption alloc] init];
        option.duration = 2.0;
        option.minDuration = 1.0;
        option.exclusive = NO;
        option.priority = HLTNotificationPriorityDefault;
        _option = option;
    }
    
    return self;
}

+ (instancetype)requestWithPayload:(NSDictionary *)payload {
    HLTNotificationRequest *request = [[self alloc] initWithPayload:payload];
    
    return request;
}

@end
