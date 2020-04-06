//
//  HLTNotificationResponse.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationResponse.h"

@interface HLTNotificationResponse ()

@property (nonatomic, strong, readwrite) HLTNotification *notification;
@property (nonatomic, copy, readwrite) NSString *actionIdentifier;
@property (nonatomic, copy, readwrite) NSDictionary *actionInfo;

@end

@implementation HLTNotificationResponse

- (instancetype)initWithNotification:(HLTNotification *)notification {
    if (self = [super init]) {
        _notification = notification;
    }
    
    return self;
}

+ (instancetype)responseForNotification:(HLTNotification *)notification action:(NSString *)action actionInfo:(NSDictionary *)actionInfo {
    HLTNotificationResponse *resp = [[self alloc] initWithNotification:notification];
    resp.actionIdentifier = action;
    resp.actionInfo = actionInfo;
    
    return resp;
}

@end
