//
//  HLTNotification.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTNotificationDef.h"
#import "HLTNotificationRequest.h"

@interface HLTNotification : NSObject

@property (nonatomic,strong) NSDate *date;
@property (nonatomic, strong, readonly) HLTNotificationRequest *request;

+ (instancetype)notificationWithRequest:(HLTNotificationRequest *)request;

#pragma mark - Accessors

- (NSDictionary *)payload;

@end
