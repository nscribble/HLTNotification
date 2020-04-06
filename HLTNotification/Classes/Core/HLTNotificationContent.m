//
//  HLTNotificationContent.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationContent.h"

@interface HLTNotificationContent ()

@property (nonatomic,strong,readwrite) NSDictionary *payload;

@end

@implementation HLTNotificationContent

+ (instancetype)contentWithPayload:(NSDictionary *)payload {
    HLTNotificationContent *content = [self new];
    content.payload = payload;
    
    return content;
}

@end
