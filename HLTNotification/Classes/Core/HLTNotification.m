//
//  HLTNotification.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotification.h"

#pragma mark - HLTNotification

@interface HLTNotification()

@property (nonatomic, strong, readwrite) HLTNotificationRequest *request;
@property (nonatomic, assign) NSTimeInterval presentTime;

@end

@implementation HLTNotification

@synthesize presentTime = _presentTime;

- (void)dealloc {
    HLTLog(@"HLTNotification dealloc");
}

- (instancetype)initWithRequest:(HLTNotificationRequest *)request {
    if (self = [super init]) {
        _request = request;
    }
    
    return self;
}

+ (instancetype)notificationWithRequest:(HLTNotificationRequest *)request {
    HLTNotification *notification = [[self alloc] initWithRequest:request];
    return notification;
}

#pragma mark -

- (NSDictionary *)payload {
    return self.request.content.payload;
}

@end
